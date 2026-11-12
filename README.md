# Iteration Humanizer

A Codex skill for revising academic prose with live writing examples and checking the resulting draft with ZeroGPT and GPTZero. It works on a sentence, a paragraph, or a full essay. The workflow preserves the writer's claims, figures, citations, and qualifications while revising how they are presented.

**AI detectors can misclassify human writing and miss AI-generated text.** Before using the final draft, review it yourself and cross-check with [Turnitin](https://guides.turnitin.com/hc/en-us/articles/28457596598925-How-to-access-the-AI-Writing-Report), if you have authorized access, or another appropriate tool. Follow applicable AI-use and disclosure rules.

## Install in Codex

### One-command install

With Node.js installed, run this in your terminal:

```sh
npx skills add aierjin/iteration-humanizer --global --agent codex
```

Use `$iteration-humanizer` in Codex after installation. The Git commands below are a manual alternative.

Requirements for manual installation: Git, plus browser access to ZeroGPT and GPTZero for scoring. Live academic retrieval also requires browser or web search access.

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

Use [ZeroGPT](https://www.zerogpt.com/) and [GPTZero](https://gptzero.me/) in the browser. No API keys are required. The websites may apply sign-in or scan limits. Scoring sends the selected text to the respective website.

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
5. **Verify and report.** Both websites must score the exact same complete draft strictly below the target. By default the target is below 10% and the skill pauses after 30 candidate revisions if verification is incomplete. It reports the latest and best readings and asks whether to continue.

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


Codex manages the search and revision loop within the active session and uses the official detector websites. If browser automation is unavailable, you can paste the candidate into each site and return the readings.

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
| GPTZero | Uses 100 minus Human probability when that number is visible. A class-only result leaves the numeric check unverified. |
| Dual verification | Scores are reported separately. A reading equal to the threshold does not pass. |
| Provider quota or limits | If ZeroGPT runs out of quota, GPTZero can continue working measurements when configured. Final verification stays pending until both have scored the same full candidate. Overlong text may be assessed in sections for diagnosis. |
| Test status | A prior ZeroGPT website session was verified. The updated dual-website workflow has not been tested end to end. |

Before submitting or publishing the final draft, independently check its facts and citations and use an authorized secondary review tool if appropriate. Detector scores do not establish authorship.

## Worked example

This example revises an abstract comparing how Hong Kong and Hollywood films frame villains. The excerpts show how the revision made the unit of analysis and the two weighting rules explicit.

**Before**

> The five-pair comparison summarizes valid submitted annotation rows within each film and then gives each film equal weight.

**After**

> For each title we summarized the valid entries. The mean of the five film values for normalized distance from the frame center was 0.2155 on the Hong Kong side and 0.2416 on the Hollywood side.

The revised abstract then reports the middle-ground and low-angle results. It explains that the second comparison used three complete pairs and weighted the sampling windows equally. The middle-ground and low-angle differences kept the same direction, while the occlusion difference reversed. The revision makes clear that the second comparison changes both the included films and the weighting.

For the **full abstract**, the ZeroGPT website returned 100% on the original and 0% on the final version, which was tested twice. These readings apply to the full drafts. GPTZero was not run for this example, so it illustrates a single-detector revision session and has no dual-provider verification result.
