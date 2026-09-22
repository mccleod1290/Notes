---
name: notes-ship
description: >-
  Notes vault document create + ship pipeline. Write once with writer
  (simple-english 1x pragmatic), filter 3x with frugal-eval (simple-english
  hardcore), optional two-doc principles/references pair, then git push and
  email PDFs. Use when the operator says notes-ship, ship notes, create notes
  pipeline, write and ship, /notes-ship, /notes-create, or /workflow notes-ship.
  Default create is ONLY writer + frugal-eval. content_eval is off unless asked.
user-invocable: true
argument-hint: "topic=... path=... [create_only|full] [single_doc]"
disable-model-invocation: false
metadata:
  short-description: "Writer + STE 3x frugal-eval, two-doc, git, mail"
---

# notes-ship — Notes vault create + ship

## Process (hardcoded)

```text
0. RESEARCH (optional facts)     do not invent vendor limits
1. WRITER                        simple-english 1× pragmatic
2. FRUGAL-EVAL                   simple-english 3× hardcore  → CREATE DONE
3. GIT + PDF + MAIL              full ship (default)
```

| Agent | Skill | Passes | Mode |
|-------|--------|--------|------|
| **writer** | **simple-english** | 1 | pragmatic |
| **frugal-eval** | **simple-english** | 3 | hardcore |

**content_eval is not in this path** unless the user says `run content-eval`.

Rules (read if unsure):

- `rules/ship-pipeline-mandatory.md`
- `rules/writer-mandatory.md`
- `rules/frugal-eval-mandatory.md`
- `rules/two-doc-ship-mandatory.md`
- `AGENTS.md`

## Slash / workflow entry

| Invoke | Effect |
|--------|--------|
| `/notes-ship <args>` | This skill (main agent follows steps below) |
| `/notes-create <args>` | Same skill; treat as `create_only` |
| `/workflow notes-ship {...}` | Orchestrated Rhai run (see `.grok/workflows/notes-ship.rhai`) |

## Arguments (parse from user text)

| Arg | Meaning | Default |
|-----|---------|---------|
| `topic` | What to write | required |
| `path` | Folder for files (under vault) | infer from topic |
| `slug` | File basename without `-principles` | kebab from topic |
| `create_only` / `create only` / `no ship` | Stop after frugal-eval SHIP | false |
| `single_doc` / `one pdf only` | One file only | false (two-doc for learning) |
| `skip research` | No source fetch | false |
| `skip mail` | Git only after create | false |
| `skip git` | Local only | false |

### Learning topic file pair (default)

```text
<path>/<slug>-principles.md
<path>/<slug>-references.md
```

Templates: `Templates/topic-principles.md`, `Templates/topic-references.md`.

## Steps (main agent — follow exactly)

### 1. Resolve paths

- Vault root = current Notes workspace.
- Create parent dirs if needed.
- Learning topic → two files unless `single_doc`.

### 2. Research (if needed)

- Fetch official + gold-mine sources for the topic.
- Land **all URLs in Doc 2 only**.
- Mark `gap` when unknown. Do not invent caps.

### 3. Writer (must use simple-english)

Prefer `spawn_subagent` with `subagent_type: writer`, or in-process with the same contract:

- Load `.agents/skills/simple-english/SKILL.md`
- Mode **pragmatic**, **1 pass per file**
- Contracts: `.agents/writer.yaml`, `.grok/agents/writer.md`
- Write real files on disk
- Doc 1: mechanism, gotchas, critical tips only (almost no URLs)
- Doc 2: official + gold-mine tables with so-what
- Cap critical tip lists at 3–7 items

### 4. Frugal-eval (must use simple-english 3× hardcore)

Prefer `spawn_subagent` with `subagent_type: frugal-eval` on **each** written path:

- Load simple-english + `references/checklist.md`
- Mode **hardcore**, **3 sequential passes**
- Contracts: `.agents/frugal-eval.yaml`, `.grok/agents/frugal-eval.md`
- Overall **SHIP** | **REVISE** | **BLOCKED**
- Create is done on SHIP

Do **not** auto-run content_eval.

### 5. Full ship (unless create_only)

From vault root:

```bash
# PDF (local helper — do not depend on missing HTB paths)
python3 scripts/md_to_pdf.py PATH.md -o PATH.pdf

# Git
git add <intended files>
git commit -m "..."
git push origin HEAD

# Mail
python3 scripts/send_notes_email.py \
  --subject "[Notes] <title> — principles + references" \
  --body "Doc1 principles/critical tips. Doc2 official + gold-mine refs." \
  PATH-principles.pdf PATH-principles.md \
  PATH-references.pdf PATH-references.md
```

On mail failure: keep files + git; report the error. Do not pretend mailed.

### 6. Report

```text
# notes-ship

topic: ...
principles_path: ...
references_path: ... | none
two_doc: yes | no
writer: done
frugal_eval: SHIP | REVISE | BLOCKED
create: done | blocked
git: <hash> | skipped
mail: sent | failed | skipped
one_line: ...
```

## Prefer workflow when

Use `/workflow notes-ship` when you want background orchestration with phases visible in `/workflows`:

```text
/workflow notes-ship {"topic":"Module 2 prompting","path":"claude/prepcourses/foundations/module2","slug":"prompting-task-execution"}
```

```text
/workflow notes-ship {"topic":"BOLA tips","path":"api","slug":"bola","create_only":true}
```

## Forbidden

- Skipping simple-english on writer or frugal-eval
- Auto content_eval
- Mixing long URL tables into principles Doc 1
- Claiming create done after writer only
- Inventing domain facts
