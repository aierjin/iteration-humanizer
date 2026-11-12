# Iteration Humanizer

A Codex skill for revising sentences, paragraphs, and essays. It can look up academic writing examples, score drafts through the ZeroGPT and GPTZero APIs, and track whether the same complete draft meets your chosen threshold on both services.

## How it works

**Baseline → find writing examples → revise → rescore → verify with both detectors**

| Capability | Behavior |
| --- | --- |
| Scope | One sentence, one paragraph, or an entire essay |
| Writing examples | Looks for papers published through 2021 by default. Searches Google Scholar first when available and reads accessible abstracts or sections. |
| Iteration | Uses ZeroGPT by default, tracks the best verified candidates, and pauses after 30 revisions by default. |
| Final verification | Checks both APIs on the same complete draft. The threshold is strict. |

## Install in Codex

Requirements: Git, PowerShell 7 (`pwsh`), and access to the two detector APIs. To retrieve live academic examples, Codex also needs browser or web search access.

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

Set `ZEROGPT_API_KEY` and `GPTZERO_API_KEY` in the environment that starts Codex. Obtain keys from the [ZeroGPT Business API](https://api.zerogpt.com/docs) and [GPTZero API](https://docs.gptzero.me/quickstart/). Keep keys out of prompts and commits. Requests may incur charges and send the selected draft to the respective service.

## Quick start

Restart Codex if the skill does not appear. Invoke the skill with your text, threshold, and preferred starting detector.

> Use $iteration-humanizer to revise this essay. Start with ZeroGPT, aim for both scores below 10%, and pause after 30 revisions if needed.

## What the scores mean

**AI detectors can misclassify human writing and miss AI-generated text.** A low score does not establish who wrote a draft or whether it complies with a course or publisher's rules. ZeroGPT's `fakePercentage` and GPTZero's non-human classification probability are different measurements. Paragraph scores are diagnostic. A pass requires both APIs to score the same complete draft below the threshold.

**Before using the final draft, review its claims, numbers, and citations yourself and cross-check with Turnitin, if you have authorized access, or another appropriate tool.** Treat the additional score as one signal alongside human review. Follow your institution's AI-use and disclosure rules. Turnitin documents its own [AI Writing Report limitations](https://guides.turnitin.com/hc/en-us/articles/28457596598925-How-to-access-the-AI-Writing-Report).

If an API is unavailable, the skill reports which verification is pending. The API client has been checked with simulated responses. Live dual-provider operation has yet to be verified.

## Repository layout

| File | Purpose |
| --- | --- |
| `SKILL.md` | Revision and verification workflow |
| `references/academic-retrieval.md` | Live search and source selection |
| `references/academic-style.md` | Editing guidance and offline fallback |
| `references/detectors.md` | Detector metrics, quota fallback, and verification rules |
| `scripts/score.ps1` | Single-request API client |
