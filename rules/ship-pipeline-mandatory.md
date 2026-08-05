# HARD RULE: ship pipeline

**Non-negotiable** default for every keepable deliverable in this vault.

Vault purpose (see `AGENTS.md`): personal **bug bounty → architect → first
principles** learning. Not a university term track. Side folders such as
`agriculture/` (one-off SVU help) do not change this pipeline’s defaults.

## Pipeline (order fixed — do not reorder)

```text
0. STUDY RESEARCH  (learning topics)  rules/study-sources-mandatory.md
1. WRITER          draft on disk + simple-english 1× pragmatic
2. FRUGAL-EVAL     simple-english 3× hardcore (strict + checklist)
3. CONTENT_EVAL    slop_chop → first_principles → core_questions
4. GIT             commit + push to origin (never force-add logs/ or secrets)
5. MAIL            email markdown + PDF to study inbox (pwnjournal SMTP)
```

A task is **not done** until applicable steps finish. Chat-only delivery without
git + mail is incomplete (unless skip phrases below).

## Hardcoded map (agents + skills + rules)

| Step | Agent name | Spawn | YAML / body | Skill | Passes | Mode | Rule file |
|------|------------|-------|-------------|-------|--------|------|-----------|
| 1 | **writer** | `writer` | `.agents/writer.yaml` · `.grok/agents/writer.md` | simple-english | 1 | pragmatic | `rules/writer-mandatory.md` |
| 2 | **frugal-eval** | `frugal-eval` | `.agents/frugal-eval.yaml` · `.grok/agents/frugal-eval.md` | simple-english | 3 | hardcore | `rules/frugal-eval-mandatory.md` |
| 3 | **content_eval** | `content_eval` | `.grok/agents/content_eval.md` | content-eval | 3 | structure | `rules/content-eval-mandatory.md` |

| Skill | Canonical path | Grok path |
|-------|----------------|-----------|
| simple-english | `.agents/skills/simple-english/` | `.grok/skills/simple-english/` (symlink) |
| content-eval | `.grok/skills/content-eval/` | same |

Index: `.agents/README.md` · `AGENTS.md` · `rules/README.md`.

## Step detail

### 0 — Study research (when applicable)

See `rules/study-sources-mandatory.md`. Then continue at step 1.

### 1 — writer (draft + STE 1×)

See `rules/writer-mandatory.md`.

- Prefer `subagent_type: writer` (contract: `.agents/writer.yaml`).
- Write real files (core folders: `AI/`, `api/`, `IIS/`, `AEM/`, `web-app-testing/`, etc.).
- Must run **simple-english** once in **pragmatic** mode before handoff.

### 2 — frugal-eval (STE hardcore 3×)

See `rules/frugal-eval-mandatory.md`.

- Prefer `subagent_type: frugal-eval` (contract: `.agents/frugal-eval.yaml`).
- Load `.agents/skills/simple-english/SKILL.md` + `references/checklist.md`.
- Mode: **hardcore** only. Three sequential passes; max 2 rewrites each.
- Overall **SHIP** | **REVISE** | **BLOCKED**.

### 3 — content_eval (learning structure 3×)

See `rules/content-eval-mandatory.md`.

After STE-clean draft on disk:

1. Load content_eval skill/agent (`/content-eval` or `subagent_type: content_eval`).
2. Three passes: `slop_chop` → `first_principles` → `core_questions`.
3. FAIL → rewrite (max 2 per pass) → re-check that pass.
4. Overall **SHIP** or **BLOCKED** (≤5 human questions). Report all three verdicts.

### 4 — Git (always)

1. Stage only intended artifacts.
2. Commit with clear message.
3. Push to `origin` (pull/rebase if needed).
4. Report commit hash + push result.

Never `git add -f logs/`. Never commit SMTP secrets or live credentials.

### 5 — Mail (always for keepable artifacts)

```bash
python3 /home/kali/HTB/PwnJournal/scripts/md_to_pdf.py PATH.md -o PATH.pdf
python3 /home/kali/HTB/PwnJournal/scripts/send_report_email.py \
  --subject "[Notes] <short title>" \
  --body "<one-line what shipped>" \
  PATH.pdf PATH.md
```

Config: `~/.config/pwnjournal/smtp.env`. Default To: `SMTP_TO` study inbox.
On mail failure: keep files + git; report error (do not pretend mailed).

## Skip phrases (only valid opt-outs)

| Phrase | Skips |
|--------|--------|
| `skip ste` / `skip simple-english` / `skip writer ste` | step 1 STE + step 2 |
| `skip frugal-eval` / `no hardcore ste` | step 2 only |
| `skip content-eval` / `raw dump ok` / `no eval` | step 3 |
| `skip git` / `no push` / `local only` | step 4 |
| `skip mail` / `no email` / `don't mail` | step 5 |
| `skip research` / `course text only` | step 0 |
| `ship pipeline off` | steps 2–5 for that turn only |

No phrase → full pipeline.
