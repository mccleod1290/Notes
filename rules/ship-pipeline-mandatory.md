# HARD RULE: ship pipeline

**Non-negotiable** default for every keepable deliverable in this vault.

## Pipeline

```text
1. CONTENT GEN     draft / write file(s) on disk
2. CONTENT EVAL    content_eval agent/skill — three sequential passes
3. GIT             commit + push to origin (never force-add logs/ or secrets)
4. MAIL            email markdown + PDF to study inbox (pwnjournal SMTP)
```

A task is **not done** until applicable steps finish. Chat-only delivery without
git + mail is incomplete (unless skip phrases below).

## Step detail

### 1 — Content gen

- Write real files (prefer topic folders: `AI/`, etc.).
- Study/course topics: complete **study research pack** first
  (`rules/study-sources-mandatory.md`), then draft.

### 2 — content_eval 3× agent loop

See `rules/content-eval-mandatory.md`.

After draft on disk:

1. Load content_eval skill/agent (`/content-eval` or `subagent_type: content_eval`).
2. Three passes in order: `slop_chop` → `first_principles` → `core_questions`.
3. FAIL → rewrite (max 2 per pass) → re-check that pass.
4. Overall **SHIP** or **BLOCKED** (≤5 human questions). Report all three verdicts.

### 3 — Git (always)

1. Stage only intended artifacts.
2. Commit with clear message.
3. Push to `origin` (pull/rebase if needed).
4. Report commit hash + push result.

Never `git add -f logs/`. Never commit SMTP secrets or live credentials.

### 4 — Mail (always for keepable artifacts)

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
| `skip content-eval` / `raw dump ok` / `no eval` | step 2 |
| `skip git` / `no push` / `local only` | step 3 |
| `skip mail` / `no email` / `don't mail` | step 4 |
| `skip research` / `course text only` | study research pack |
| `ship pipeline off` | steps 2–4 for that turn only |

No phrase → full pipeline.
