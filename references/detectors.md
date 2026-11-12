# Detector rules

Run `pwsh -NoProfile -File scripts/score.ps1 -Path <utf8-file> -Target <threshold> -Detector ZeroGPT` or use `-Detector GPTZero`. The script returns one measured result or a structured failure. If the user names a different detector, explain what is available and ask how they want to proceed when it cannot be used. Do not claim support for an unimplemented API.

## Metrics and final verification

- ZeroGPT uses its reported fakePercentage.
- GPTZero uses 100 × (1 − class_probabilities.human). This is a document classification probability including mixed text. It is a different metric from ZeroGPT's estimated share of flagged text. Report the two separately.
- The first time a full candidate meets the working detector's threshold, measure the exact same full text with the other required detector. An earlier valid score may be reused only for the identical full text and provider. Continue if either score is at or above the threshold. Use the failing detector to guide the next edits when it repeatedly blocks delivery, and recheck both on any new promising candidate.
- Preserve a record per candidate, provider and scope. Never average detector readings or paragraph readings to certify the whole essay.

## Service limits

- If the full essay is too long or a service rate-limits requests, notify the user that you are splitting the essay into its existing paragraphs for diagnostics. Preserve order, headings and boundaries. For rate limits, queue any diagnostic calls until the service's Retry-After permits requests. Do not flood a throttled service with paragraph requests. If the wait is unavailable or impractical, continue through the other configured detector where authorized and resume the original service when it is available.
- On confirmed ZeroGPT quota exhaustion, notify the user and automatically switch working measurements to GPTZero if configured. Score the complete current candidate to establish a GPTZero comparison point. If the response only says 429 with no clear cause, report the ambiguity and use the configured fallback for progress. Do not call it confirmed quota exhaustion.
- If ZeroGPT is still unavailable at handoff, report the candidate as pending ZeroGPT verification unless this exact candidate already has a valid, passing ZeroGPT result. Apply the same rule when GPTZero is unavailable. If there is no usable service, report what is missing and retain the best candidate.
- Do not retry ambiguous network timeouts automatically because the request may have been billed.

[ZeroGPT Business API](https://api.zerogpt.com/docs) · [GPTZero API quickstart](https://docs.gptzero.me/quickstart/)
