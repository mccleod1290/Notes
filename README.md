# Notes vault

Personal learning vault: **bug bounty → security architect → first principles**.  
Not a university term track. Authorized study and authorized testing only.

Live skills are only under [`.grok/skills/`](./.grok/skills/). The old rules, commands, agents, and ship workflow are in [`archive/`](./archive/).

---

## Live skills

| Skill | What it owns |
|-------|----------------|
| [`writer-skill`](./.grok/skills/writer-skill/SKILL.md) | How the sentences sound. Room-log sound and black-box narration. |
| [`ideas-skill`](./.grok/skills/ideas-skill/SKILL.md) | How a topic is broken down. First principles by default. Second-order or invariant only when that model is needed. |

Explain a concept with both: ideas-skill picks the order, writer-skill writes the sentences.

```text
/writer-skill
/ideas-skill
```

---

## Archive

The old create path (writer agent, frugal-eval, simple-english, notes-ship, lab-writeup) is not live.

| What | Where |
|------|--------|
| Map | [`archive/README.md`](./archive/README.md) |
| Older skills | [`archive/skills/`](./archive/skills/) |
| Rules | [`archive/rules/`](./archive/rules/) |
| Commands | [`archive/commands/`](./archive/commands/) |
| Agents | [`archive/agents/`](./archive/agents/) |
| notes-ship workflow | [`archive/workflows/notes-ship.rhai`](./archive/workflows/notes-ship.rhai) |

---

## Helper scripts

| Script | Job |
|--------|-----|
| [`scripts/md_to_pdf.py`](./scripts/md_to_pdf.py) | Markdown → PDF (WeasyPrint) |
| [`scripts/send_notes_email.py`](./scripts/send_notes_email.py) | Attach MD+PDF to study inbox |

Mail config (first match):

1. `~/.config/pwnjournal/smtp.env`
2. `~/.grok/skills/cve-daily-brief/config.json` (fallback)

```bash
python3 scripts/md_to_pdf.py path/to/note.md -o path/to/note.pdf
python3 scripts/send_notes_email.py \
  --subject "[Notes] title" \
  --body "what shipped" \
  path/to/note.pdf path/to/note.md
```

---

## Core folders

```text
AI/                 AI / MCP / LLM attack surface
api/                OWASP API operator batches
AEM/                Adobe Experience Manager
IIS/                IIS / .NET surfaces
web-app-testing/    web app attack classes
claude/             Claude prep courses (e.g. prepcourses/foundations/module2)
Checklists/         session + bug-class questions
Templates/          engagement + two-doc skeletons
```

---

## Related

| Doc | Purpose |
|-----|---------|
| [`archive/README.md`](./archive/README.md) | Where the old pipeline went |
| [`suggestions.md`](./suggestions.md) | Operator cadence |
| [`todo.md`](./todo.md) | Build todo |
| Example notes | [`claude/prepcourses/foundations/module2/`](./claude/prepcourses/foundations/module2/) |
