# Notes vault

Personal learning vault: **bug bounty → security architect → first principles**.  
Not a university term track. Authorized study and authorized testing only.

Canonical agent rules: [`AGENTS.md`](./AGENTS.md) · hard rules: [`rules/`](./rules/)

---

## Document process (default)

```text
writer        → simple-english 1× pragmatic
frugal-eval   → simple-english 3× hardcore
              → CREATE DONE
git + PDF + mail  → FULL SHIP
```

| Piece | Role |
|-------|------|
| **writer** | Draft on disk. Must load **simple-english** once (pragmatic). |
| **frugal-eval** | Filter 3×. Must load **simple-english** hardcore + checklist. |
| **two-doc shape** | Learning topics → `TOPIC-principles.md` + `TOPIC-references.md` |
| **content_eval** | **Off** by default (say `run content-eval` only if you want it) |

Rules:

- [`rules/ship-pipeline-mandatory.md`](./rules/ship-pipeline-mandatory.md)
- [`rules/two-doc-ship-mandatory.md`](./rules/two-doc-ship-mandatory.md)
- [`rules/writer-mandatory.md`](./rules/writer-mandatory.md)
- [`rules/frugal-eval-mandatory.md`](./rules/frugal-eval-mandatory.md)

Templates: [`Templates/topic-principles.md`](./Templates/topic-principles.md), [`Templates/topic-references.md`](./Templates/topic-references.md)

---

## Slash commands (this vault)

| Command | What it does |
|---------|----------------|
| **`/notes-ship`** | Full process: research (as needed) → writer → frugal-eval → PDF → git push → mail |
| **`/notes-create`** | Create only (writer + frugal-eval). No git/mail |

Skill body: [`.grok/skills/notes-ship/SKILL.md`](./.grok/skills/notes-ship/SKILL.md)  
Legacy command stubs: [`.grok/commands/notes-ship.md`](./.grok/commands/notes-ship.md), [`.grok/commands/notes-create.md`](./.grok/commands/notes-create.md)

### Examples

```text
/notes-ship topic=Module 3 X path=claude/prepcourses/foundations/module3 slug=module3-x

/notes-create topic=BOLA operator tips path=api slug=bola

/notes-ship topic=capability layer path=AI slug=capability-layer single_doc
```

After you type `/`, fuzzy-find `notes-ship` if the menu is slow to refresh (reload session if a brand-new skill does not appear).

---

## Workflow (orchestrated)

| Workflow | Path | Run |
|----------|------|-----|
| **notes-ship** | [`.grok/workflows/notes-ship.rhai`](./.grok/workflows/notes-ship.rhai) | `/workflow notes-ship {...}` or `/notes-ship` via skill |

```text
/workflow notes-ship {"topic":"Module 2 prompting","path":"claude/prepcourses/foundations/module2","slug":"prompting-task-execution"}
```

```text
/workflow notes-ship {"topic":"BOLA","path":"api","slug":"bola","create_only":true}
```

| Arg | Required | Meaning |
|-----|----------|---------|
| `topic` | yes | What to write |
| `path` / `folder` | no | Folder under vault |
| `slug` | no | Basename (kebab) |
| `create_only` | no | Skip PDF/git/mail |
| `single_doc` | no | One file instead of two-doc |
| `skip_research` | no | Skip source fetch |
| `skip_git` / `skip_mail` | no | Partial ship |

Phases: **Resolve → Research → Writer → FrugalEval → Ship**  
Watch live runs: `/workflows`

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

Agents: [`.agents/`](./.agents/) · Grok bodies: [`.grok/agents/`](./.grok/agents/)

---

## Related

| Doc | Purpose |
|-----|---------|
| [`AGENTS.md`](./AGENTS.md) | Hardcoded agents, skills, pipeline |
| [`suggestions.md`](./suggestions.md) | Operator cadence |
| [`todo.md`](./todo.md) | Build todo |
| Example ship | [`claude/prepcourses/foundations/module2/`](./claude/prepcourses/foundations/module2/) |
