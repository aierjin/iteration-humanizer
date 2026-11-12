param(
    [Parameter(Mandatory)][string]$Path,
    [ValidateScript({ $_ -gt 0 -and $_ -le 100 })][decimal]$Target = 10,
    [ValidateSet('ZeroGPT','GPTZero')][string]$Detector = 'ZeroGPT'
)
$ErrorActionPreference = 'Stop'

function Fail($Reason, $Status = 0, $RetryAfter = '') {
    @{ ok = $false; detector = $Detector; reason = $Reason; status = $Status; retryAfter = $RetryAfter } | ConvertTo-Json -Compress
    exit 1
}

function Reject($Status, $Message, $RetryAfter) {
    $reason = 'api_rejected'
    if ($Status -eq 413 -or $Message -match '(?i)too long|(?:character|input length|text length) limit|maximum.{0,20}characters') {
        $reason = 'input_too_long'
    } elseif ($Status -eq 402 -or $Message -match '(?i)insufficient (?:balance|credit)|out of credits|quota (?:exceeded|exhausted)|monthly.{0,20}limit|word limit|please make a purchase') {
        $reason = 'quota_exhausted'
    } elseif ($Status -eq 429) {
        $reason = 'limit_unspecified'
        if ($RetryAfter -or $Message -match '(?i)rate limit|too many requests|hourly') { $reason = 'rate_limited' }
    }
    Fail $reason $Status $RetryAfter
}

if ($Detector -eq 'GPTZero') {
    $uri = 'https://api.gptzero.me/v2/predict/text'
    $headers = @{ 'x-api-key' = $env:GPTZERO_API_KEY }
    $field = 'document'
} else {
    $uri = 'https://api.zerogpt.com/api/detect/detectText'
    $headers = @{ ApiKey = $env:ZEROGPT_API_KEY }
    $field = 'input_text'
}
if ([string]::IsNullOrWhiteSpace(@($headers.Values)[0])) { Fail 'missing_api_key' }
try {
    $resolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $inputText = [IO.File]::ReadAllText($resolved, [Text.UTF8Encoding]::new($false, $true))
} catch { Fail 'unreadable_input' }
if ([string]::IsNullOrWhiteSpace($inputText)) { Fail 'empty_input' }

$requestBody = @{ $field = $inputText } | ConvertTo-Json -Compress
$request = @{
    Uri = $uri
    Method = 'Post'
    Headers = $headers
    ContentType = 'application/json; charset=utf-8'
    Body = [Text.Encoding]::UTF8.GetBytes($requestBody)
    TimeoutSec = 45
    MaximumRedirection = 0
    SkipHttpErrorCheck = $true
}
try { $response = Invoke-WebRequest @request } catch { Fail 'request_failed' }
$status = [int]$response.StatusCode
$retryAfter = [string](@($response.Headers['Retry-After'])[0])
if ($status -lt 200 -or $status -ge 300) { Reject $status $response.Content $retryAfter }
try { $result = $response.Content | ConvertFrom-Json -ErrorAction Stop } catch { Fail 'invalid_response' $status }

if ($Detector -eq 'GPTZero') {
    $documents = @($result.documents)
    if ($documents.Count -ne 1) { Fail 'invalid_response' $status }
    $rawScore = $documents[0].class_probabilities.human
    $maximum = 1
    $metric = 'nonHumanClassProbabilityPercent'
    $highlights = @()
} else {
    if ($result.success -isnot [bool] -or -not $result.success) {
        $reported = 0
        if (-not [int]::TryParse([string]$result.code, [ref]$reported)) { $reported = $status }
        Reject $reported $result.message $retryAfter
    }
    $rawScore = $result.data.fakePercentage
    $maximum = 100
    $metric = 'fakePercentage'
    $highlights = @($result.data.h | Where-Object { $_ -is [string] })
}

$score = [decimal]0
if ($null -eq $rawScore -or $rawScore -is [bool] -or
    -not [decimal]::TryParse([string]$rawScore, [Globalization.NumberStyles]::Float,
        [Globalization.CultureInfo]::InvariantCulture, [ref]$score) -or
    $score -lt 0 -or $score -gt $maximum) { Fail 'invalid_score' $status }
if ($Detector -eq 'GPTZero') { $score = (1 - $score) * 100 }

@{
    ok = $true
    detector = $Detector
    metric = $metric
    score = $score
    target = $Target
    belowTarget = $score -lt $Target
    highlights = $highlights
} | ConvertTo-Json -Compress -Depth 4
