---
description: Notes vault create+ship — writer (STE 1x) then frugal-eval (STE 3x hardcore), two-doc, git, mail
argument-hint: topic=... path=... [create_only] [single_doc]
---

Run the **notes-ship** skill for this vault.

Load and follow: `.grok/skills/notes-ship/SKILL.md`

Also obey:

- `AGENTS.md`
- `rules/ship-pipeline-mandatory.md`
- `rules/two-doc-ship-mandatory.md`

**Process:**

1. Writer drafts on disk + simple-english 1× pragmatic (per file).
2. Frugal-eval simple-english 3× hardcore on each file → create done.
3. Unless `create_only`: PDF via `scripts/md_to_pdf.py`, git commit+push, mail via `scripts/send_notes_email.py`.

**Default learning shape:** `TOPIC-principles.md` + `TOPIC-references.md`.

**User args (this invocation):** $ARGUMENTS

If args empty, ask once for `topic` and preferred `path` under the vault, then run.
