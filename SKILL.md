---
name: iteration-humanizer
description: Rewrite a sentence, paragraph, or essay with live academic examples and iterate using ZeroGPT and GPTZero website readings while preserving claims, figures, and citations.
---

# Iteration Humanizer

Use this workflow to rewrite and retest text. Read [detector rules](references/detectors.md) before the first measurement. Use the official sites through browser tools. Text pasted for measurement goes to the respective providers. If browser control is unavailable, ask the user to run the checks manually and share the results.

## Set up

- Resolve the exact scope and preserve the original. Use temporary UTF-8 files for candidates and a log of candidate identity, detector, metric, scope, score or error, and edit strategy.
- Ask once if the user has a preferred primary detector, unless already specified. Default to ZeroGPT if the user has no preference. ZeroGPT and GPTZero are both required for final verification, regardless of the primary choice.
- Default to strictly below 10% and 30 candidates per block. Honor an explicit threshold or block size. Score the complete original as a baseline with the primary detector. Baseline calls and secondary verification calls do not count as candidate revisions. If the original already passes the primary, verify it with both before returning it as-is unless edits are requested.

## Revise and measure

1. For academic prose follow [live academic retrieval](references/academic-retrieval.md) after attempting the baseline. Remove boilerplate, use concrete details from the original, match register, adjust rhythm, and proofread. Keep arguments, claims, units, figures, citations, qualifications, and conclusions intact.
2. Adjust clauses for one sentence. Use highlighted sentences if available for a paragraph. For an essay, revise sections as needed, then reread the assembled draft for consistency and transitions. Reject factual drift before sending a candidate for measurement.
3. Use the primary detector on each full candidate and retain the best content-checked versions and their exact text. After three measured candidates without a new best on the same detector and scope, use the live retrieval guide to find a different writing approach. Follow the detector rules for rejection, paragraph diagnostics, switching providers, and verifying promising candidates.
4. Finish successfully only when both websites have scored the same complete candidate strictly below the threshold. If either cannot score it, retain the best eligible candidate and clearly report the missing or failing verification. Do not claim that either score establishes authorship.
5. At the end of each block of 30 candidates, or the user's explicit block size, pause if the dual threshold is unmet. Report the latest and best readings by provider and scope, the candidate count, and any missing checks. Ask whether to continue searching for examples and iterating or stop. Resume only after the user chooses to continue. Retain the current log and best drafts across blocks while the workspace is available.

Recommend that the user review the final draft and cross-check with authorized Turnitin access or another appropriate tool before use. Explain that detector readings can be inaccurate.

Deliver the exact text assessed, both provider readings and metric names when available, the threshold and result, number of candidates, and the papers actually consulted.
