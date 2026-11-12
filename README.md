# Iteration Humanizer

A Codex skill for revising academic prose with live writing examples and checking the resulting draft with ZeroGPT and GPTZero. It works on a sentence, a paragraph, or a full essay. The workflow preserves the writer's claims, figures, citations, and qualifications while revising how they are presented.

**AI detectors can misclassify human writing and miss AI-generated text.** Before using the final draft, review it yourself and cross-check with [Turnitin](https://guides.turnitin.com/hc/en-us/articles/28457596598925-How-to-access-the-AI-Writing-Report), if you have authorized access, or another appropriate tool. Follow applicable AI-use and disclosure rules.

## What it does

| Input | How it revises | What it scores |
| --- | --- | --- |
| Sentence | Adjusts clause order and emphasis while preserving meaning. | The complete sentence, if the detector accepts it. |
| Paragraph | Revises phrasing and flow, using detector highlights when available. | The complete paragraph. |
| Essay | Revises individual sections and checks the assembled draft for consistent terminology, transitions, and argument. | The complete essay. Paragraph scores can help locate issues. |

## Workflow

1. **Establish a baseline.** Preserve the original and score the selected text with the preferred detector. ZeroGPT is the default when the user has no preference.
2. **Find writing examples.** Search for papers whose accessible sections demonstrate the kind of writing the draft needs. Read the actual prose and record the patterns and source links.
3. **Revise and check the content.** Remove boilerplate, clarify the argument, and adjust sentence rhythm or section order where useful. Check all revised claims, values, units, citations, and conclusions against the original.
4. **Score and iterate.** Save the full candidate and record the score, detector, and change. After three measured candidates without a new best score on the same detector and scope, search for a different writing approach.
5. **Verify and report.** Both services must score the exact same complete draft strictly below the target. By default the target is below 10% and the skill pauses after 30 candidate revisions if verification is incomplete. It reports the latest and best readings and asks whether to continue.

## Writing examples and source priority

The default search pool is **any scholarly paper indexed by Google Scholar and published in 2021 or earlier**, across disciplines. Each run searches this pool using queries tailored to the draft and opens a small set of matching sources. You can specify a different date range, field, language, or journal. Search queries use generic terms about the study design or section and omit your draft and unpublished findings.

| Priority | Sources | How they are used |
| --- | --- | --- |
| 1 | Closely relevant peer-reviewed papers in established journals or conferences, verified through the publisher or an authorized copy | Prefer examples that match the section, study design, and discipline. |
| 2 | Peer-reviewed papers from another topic or discipline with a closely matched writing task | Borrow structural patterns, such as how an abstract reports a comparison with two weighting rules. |
| 3 | Other credible scholarly material, such as identifiable preprints or theses from reputable repositories | Use when stronger candidates do not provide accessible prose. Record the source type. |
| 4 | Bundled academic style guide | Use if live searches yield no readable example. |

Within each tier, prioritize the best match for the actual passage. Consider venue and provenance before citation count. Verify title and publication year, read the relevant section when possible, and record its DOI or URL. For an abstract-only source, learn only from the abstract. Borrow organization and expression patterns. The draft supplies the factual claims, numbers, and references.

If Google Scholar requires supported browser access, the skill asks for it. When Scholar remains unavailable, it can search other scholarly indexes or publicly accessible publisher and university repository pages. The final report names the actual discovery route and sources read.

## Architecture

| File | Role |
| --- | --- |
| [SKILL.md](SKILL.md) | Codex instructions for the revision loop and final report |
| [references/academic-retrieval.md](references/academic-retrieval.md) | Search scope, source hierarchy, and example selection |
| [references/academic-style.md](references/academic-style.md) | Writing guidance and offline examples |
| [references/detectors.md](references/detectors.md) | Metrics, provider fallback, and final verification |
| [scripts/score.ps1](scripts/score.ps1) | Sends a single scoring request and returns structured JSON |

Codex manages the search and revision loop within the active session. The PowerShell script measures one file per call.

## Install in Codex

Requirements: Git, PowerShell 7 (`pwsh`), detector API credentials, and network access to the detector endpoints. Live retrieval also requires browser or web search access.

### Windows PowerShell

```powershell
$skillsDir = Join-Path $env:USERPROFILE '.agents/skills'
New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
git clone https://github.com/aierjin/iteration-humanizer.git (Join-Path $skillsDir 'iteration-humanizer')
```

### macOS or Linux

```sh
mkdir -p ~/.agents/skills
git clone https://github.com/aierjin/iteration-humanizer.git ~/.agents/skills/iteration-humanizer
```

Set `ZEROGPT_API_KEY` and `GPTZERO_API_KEY` in the environment that starts Codex. Obtain credentials from the [ZeroGPT Business API](https://api.zerogpt.com/docs) and [GPTZero API](https://docs.gptzero.me/quickstart/). Keep keys out of prompts and commits. Scoring transmits the selected text to the respective providers and may incur charges. Restart Codex if the skill does not appear.

## Quick start

**One sentence**

> Use $iteration-humanizer to revise this sentence. Keep it as one sentence and use a target below 10%.

**One paragraph**

> Use $iteration-humanizer on this Results paragraph. Keep the group order, percentages, and citations. Start with GPTZero and aim for below 12% on both detectors.

**Whole essay**

> Use $iteration-humanizer to revise this essay. Look for comparable empirical papers in Google Scholar, preserve all figures and citations, and target below 10% on both detectors. Pause after 30 revisions if needed.

## Quality checks and limits

| Check | What to expect |
| --- | --- |
| Content fidelity | Each candidate is checked against the original before it is scored. The writer should review the final draft. |
| ZeroGPT | Reports `fakePercentage`, its estimate of the share flagged. |
| GPTZero | Uses 100 × (1 − human class probability), which includes mixed-class probability. |
| Dual verification | Scores are reported separately. A reading equal to the threshold does not pass. |
| Provider quota or limits | If ZeroGPT runs out of quota, GPTZero can continue working measurements when configured. Final verification stays pending until both have scored the same full candidate. Overlong text may be assessed in sections for diagnosis. |
| Test status | The API client was tested with simulated responses. Live dual-provider operation remains unverified. |

Before submitting or publishing the final draft, independently check its facts and citations and use an authorized secondary review tool if appropriate. Detector scores do not establish authorship.
