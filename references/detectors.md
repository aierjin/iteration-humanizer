# Website detector rules

Use [ZeroGPT](https://www.zerogpt.com/) and [GPTZero](https://gptzero.me/). Read the visible page state before interacting. Paste only the selected candidate into the detector, submit it, and wait for the new result. Verify that the result corresponds to that complete candidate before recording it. If the site asks for sign-in or a CAPTCHA, request user handoff as needed. If browser tools are unavailable, ask the user to paste the candidate and return the result or a screenshot. No API key is needed for this workflow.

## Metrics and final verification

- Record ZeroGPT's displayed percentage and GPTZero's displayed classification. Use a numeric GPTZero threshold only when the site exposes the necessary probabilities. When Human, AI, and Mixed probabilities are available, use 100 minus Human probability, including Mixed. This is a classification probability and differs from ZeroGPT's text percentage.
- If a GPTZero result has only a class, confidence wording, or an ambiguous number, record the result and mark the numeric check as unverified. Do not infer a percentage from a label.
- Once the primary detector is below target, check the exact same complete draft with the other detector. Mark a final pass only when both numeric results are strictly below the threshold. When either score fails, use it to guide further revisions.
- Keep the actual reported result and distinguish whole-draft scans from paragraph scans. Do not average paragraph results or provider scores.

## Site limits

- If ZeroGPT hits its usage limit, switch working checks to GPTZero and verify the exact final candidate in ZeroGPT when available. If either website refuses a long essay, notify the user and use sections only for diagnosis. Final verification requires both complete-draft results.
- Respect scan limits and any wait requested by the website. If the site blocks measurement, retain the best candidate and identify the missing verification.
- Website results can differ by account, model version, and what the site makes visible. Follow the site's labels and report missing measurements rather than guessing.
