# HARD RULE: ship pipeline

**Non-negotiable** default for every keepable deliverable in this vault.

## Pipeline

```text
1. CONTENT GEN     writer agent → draft on disk → simple-english 1× pragmatic
2. FRUGAL STE      frugal-eval agent → simple-english 3× hardcore (strict)
3. CONTENT EVAL    content_eval agent/skill — three sequential learning passes
4. GIT             commit + push to origin (never force-add logs/ or secrets)
5. MAIL            email markdown + PDF to study inbox (pwnjournal SMTP)
```

A task is **not done** until applicable steps finish. Chat-only delivery without
git + mail is incomplete (unless skip phrases below).

Agents / skill:

| Piece | Path |
|-------|------|
| writer (YAML) | `.agents/writer.yaml` |
| frugal-eval (YAML) | `.agents/frugal-eval.yaml` |
| simple-english skill | `.agents/skills/simple-english/` |
| Grok twins | `.grok/agents/writer.md`, `.grok/agents/frugal-eval.md` |
| content_eval | `.grok/agents/content_eval.md` + `.grok/skills/content-eval/` |

## Step detail

### 1 — Content gen (writer + STE 1×)

- Prefer `subagent_type: writer` (contract: `.agents/writer.yaml`).
- Write real files (prefer topic folders: `AI/`, `agriculture/`, etc.).
- Study/course topics: complete **study research pack** first
  (`rules/study-sources-mandatory.md`), then draft.
- Writer must run **simple-english** once in **pragmatic** mode before handoff.

### 2 — frugal-eval STE hardcore 3×

- Prefer `subagent_type: frugal-eval` (contract: `.agents/frugal-eval.yaml`).
- Load `.agents/skills/simple-english/SKILL.md` + `references/checklist.md`.
- Mode: **hardcore** (strict STE + full checklist + fail-closed).
- Three sequential passes; FAIL → rewrite (max 2 per pass).
- Overall **SHIP** | **REVISE** | **BLOCKED**.

### 3 — content_eval 3× agent loop

See `rules/content-eval-mandatory.md`.

After STE-clean draft on disk:

1. Load content_eval skill/agent (`/content-eval` or `subagent_type: content_eval`).
2. Three passes in order: `slop_chop` → `first_principles` → `core_questions`.
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
| `skip ste` / `skip simple-english` / `skip writer ste` | writer STE 1× and/or frugal-eval (step 1 STE + step 2) |
| `skip frugal-eval` / `no hardcore ste` | step 2 only |
| `skip content-eval` / `raw dump ok` / `no eval` | step 3 |
| `skip git` / `no push` / `local only` | step 4 |
| `skip mail` / `no email` / `don't mail` | step 5 |
| `skip research` / `course text only` | study research pack |
| `ship pipeline off` | steps 2–5 for that turn only |

No phrase → full pipeline.
