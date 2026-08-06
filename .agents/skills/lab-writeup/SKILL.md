---
name: lab-writeup
version: 1.0.0
description: |
  Write CTF / HTB / authorized-lab writeups like a clear Medium-style walkthrough:
  pre-req knowledge, one-line core concept, small steps with why + first-principles
  per command, screenshots for blogs, and a Beyond Root section (exploit path
  depth + blue-team patch/detect). Uses simple-english once (pragmatic). No
  frugal-eval. Use when: lab writeup, CTF writeup, blog writeup, HTB writeup,
  beyond root notes, /lab-writeup, or writeup-writer agent.
license: MIT
compatibility: claude-code cursor codex gemini-cli opencode grok
metadata:
  benchmark: https://medium.com/@zabedullahpoyel/intigriti-july-2026-ctf-write-up-exploiting-json-parser-differential-duplicate-key-confusion-to-29b94d6001e4
  ste: simple-english 1x pragmatic only
  eval: none
---

# lab-writeup — clear step blogs + short vault notes

## Mission

Turn a solved (or partial) **authorized** lab into a writeup a tired reader can
follow without guessing. Match the **shape** of strong Medium CTF posts
(Intigriti-style steps + root cause + mitigation), then raise the bar with
first principles on every command and a real **Beyond Root** section.

**Language:** load and apply **simple-english** exactly **once** (pragmatic).  
**Eval:** **none**. Do not run frugal-eval or content_eval on this path.

Canonical STE skill: `.agents/skills/simple-english/SKILL.md`  
(also `skills/simple-english/` in PwnJournal / `~/.grok/skills/`).

## When to use

| Trigger | Product |
|---------|---------|
| lab / CTF / HTB writeup, blog post | **blog** mode (screenshots required) |
| short vault / Obsidian card | **obsidian** mode (no screenshots) |
| `/lab-writeup` or agent `writeup-writer` | default **blog** unless user says short |

## Deliverable targets (pick from user instruction)

| Target | Path habit |
|--------|------------|
| Live brain | `~/llm-wiki/boxes/<slug>.md` or `concepts/` for portable bugs |
| Blog site | `mccleod1290.github.io` repo when present; else stage under Notes `web-app-testing/writeups/` or box folder |
| Notes git | learning folders or `web-app-testing/writeups/<slug>.md` |
| PwnJournal seed | `wiki/boxes/` or engagement `STUDY_NOTES.md` |

If the user names a target, use it. If silent, write:

1. blog-ready markdown on disk (path in report)
2. one short pointer in `~/llm-wiki/` when the lesson is portable

## Benchmark (shape we match)

Reference post (July 2026 Intigriti CTF — JSON duplicate-key / parser differential):

https://medium.com/@zabedullahpoyel/intigriti-july-2026-ctf-write-up-exploiting-json-parser-differential-duplicate-key-confusion-to-29b94d6001e4

### What that post does well (keep)

1. **Meta block** up front: Challenge, Platform, Category, Vulnerability, Difficulty, Target
2. **Introduction** — 2–4 sentences on what the bug is
3. **Root cause** — mechanism before the long step list
4. **Numbered steps** — each step is one job + exact command
5. **Why it works** — diagram or short mechanism between steps when needed
6. **Impact** — short list
7. **Mitigation** — blue-team actions
8. **Conclusion + disclaimer**

### What we add (operator bar)

| Add | Why |
|-----|-----|
| **Pre-req knowledge** at the very start | reader knows what to study first |
| **Core concept** one-liner | sticky mental model |
| **Why this step** after each step | no cargo-cult commands |
| **First principles of the command** | what each flag/tool does |
| **Beyond Root** after flag/root | path study + patch + detect + document |
| **Screenshots** for blog mode only | blogs need proof; short notes do not |

Full skeleton: `templates/blog-writeup.md`  
Short form: `templates/obsidian-short.md`  
Notes: `references/medium_benchmark.md`

---

## Fixed header (every writeup)

Place **before** Step 1:

```markdown
# <Title: bug class in plain words>

| Field | Value |
|-------|-------|
| Challenge / Box | |
| Platform | HTB / Intigriti / … |
| Category | |
| Vulnerability | |
| Difficulty | |
| Target | URL or IP (authorized) |
| Outcome | flag / user / root / partial |

## Pre-req knowledge

- <topic a reader must already know or accept learning mid-way>
- …

## Core concept (one line)

> <one sentence: the mechanism that makes the bug real>

## Introduction

<2–4 sentences: what the app does, what you break, what you get>

## Root cause

<how the system fails — trust boundary + transform + wrong assumption>
```

---

## Step blocks (blog and long notes)

For **every** step use this shape. Small steps. One job per step.

```markdown
### Step N: <verb phrase — what you achieve>

**Why we do this**

<one short paragraph: goal of this step in the chain>

**Command / action**

\`\`\`bash
# exact command; placeholders in ANGLE_BRACKETS or YOUR_*
\`\`\`

**First principles (this command)**

| Piece | Meaning |
|-------|---------|
| tool / flag | what it does at the protocol/OS layer |

**What you should see**

- success signal
- failure signal (so you do not thrash)

**Screenshot** *(blog mode only)*

![Step N — short caption](screenshots/<slug>-step-N.png)
<!-- or: TODO_SCREENSHOT: describe what to capture -->
```

Rules:

- Prefer **copy-pasteable** commands. Mark secrets as placeholders.
- Never invent a probe that was not run. Mark `not_tested` if needed.
- Authorized lab only. No production abuse recipes as “live targets.”

---

## Beyond Root (required when flag or root is claimed)

Not a dump of “try harder” slogans. Pick **one exploit path** from this lab
and drill it.

### Required subsections

1. **Path under the microscope**  
   Why this path worked (conditions). What had to be true.

2. **First principles drill**  
   Trust boundary, input → transform → sink, canary that proves the class.

3. **Blue team — stop the vuln**  
   Patch ideas (code/config). Detection (logs, WAF, unit tests). Secure default.

4. **If the CTF shortcut dies**  
   3–5 concrete next probes when labels, `/flag`, or weak parsers disappear.

5. **Document the engagement**  
   What to leave in ATTACK_LOG / loot / wiki concept so chat amnesia cannot erase it.

Short Obsidian notes may use a **3-bullet Beyond Root** instead of full sections.

---

## Screenshots

| Mode | Screenshots |
|------|-------------|
| **blog** / Medium / github.io | **Required** for key steps (register, payload, flag). Use real captures when available. |
| **obsidian** / short vault | **Skip**. Text + commands only. |

### How to capture (agent convenience)

Prefer in order:

1. **Existing files** in the engagement folder (`screenshots/`, `loot/`, terminal logs)
2. **Host tools:** ImageMagick `import`, `scrot`, or browser export — save under `screenshots/<slug>-step-N.png`
3. **Diagrams:** ASCII in the doc, or image tools for architecture “why it works” figures
4. If capture is impossible: write  
   `TODO_SCREENSHOT: <exactly what the reader must see>`  
   Do not fake a binary image.

Blogs without any screenshot **or** TODO markers fail this skill.

---

## Pipeline (fixed)

```text
1. Gather facts (logs, ATTACK_LOG, loot) — do not invent
2. Choose mode: blog | obsidian
3. Choose land path (user / defaults above)
4. Draft full skeleton on disk
5. simple-english 1× pragmatic (load skill, self-check once)
6. Report paths + ste_self_check — STOP (no eval agents)
```

### simple-english (mandatory 1×)

1. Load `.agents/skills/simple-english/SKILL.md`
2. Mode: **pragmatic**
3. Passes: **1**
4. Do not touch code fences, commands, paths, quoted errors
5. Self-check once; fix obvious STE hits; stop

---

## Tone

- Clear, small steps. Mentor, not flex.
- First useful sentence early.
- Explain **why** before the next step piles on.
- No marketing filler. No emoji decoration.
- American English (STE). Active voice.

## Forbidden

- frugal-eval / content_eval on this path
- Flag-only posts with no root cause
- Invented commands presented as run
- Screenshots in short Obsidian cards (waste)
- Skipping Beyond Root after a full root/flag (blog mode)
- Unauthorized targets

## Output report (every run)

```text
# lab-writeup / writeup-writer

mode: blog | obsidian
path_written: <file>
screenshots: yes | todo | n/a
skill_language: simple-english
ste_mode: pragmatic
ste_passes: 1
ste_self_check: PASS | FAIL
eval: none
land: llm-wiki | notes | github.io | pwnjournal | other
one_line: <what you wrote>
beyond_root: full | short | n/a
```

## References

- `references/medium_benchmark.md` — structure scorecard vs Intigriti post
- `templates/blog-writeup.md` — full paste skeleton
- `templates/obsidian-short.md` — vault-short skeleton
- simple-english skill (required)
