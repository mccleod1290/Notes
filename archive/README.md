# Archive

Moved out of the live tree on 2026-09-23. Nothing here is a current skill, rule, command, or agent.

Live skills stay in `.grok/skills/` only:

- `writer-skill` — how the writing sounds
- `ideas-skill` — how a topic is approached

## What moved

| Folder | Was | What it was |
|--------|-----|-------------|
| [`skills/`](./skills/) | `.grok/skills/` and `.agents/skills/` | content-eval, first-principles-blog, lab-writeup, notes-ship, simple-english |
| [`rules/`](./rules/) | `rules/` | Mandatory ship, writer, frugal-eval, two-doc, study-sources, content-eval |
| [`commands/`](./commands/) | `.grok/commands/` | `/notes-ship`, `/notes-create`, `/lab-writeup` |
| [`agents/AGENTS.md`](./agents/AGENTS.md) | `AGENTS.md` | Root agent contract for that pipeline |
| [`agents/from-agents/`](./agents/from-agents/) | `.agents/` | writer, frugal-eval, writeup-writer contracts |
| [`agents/from-grok/`](./agents/from-grok/) | `.grok/agents/` | Spawn bodies for those agents, plus content_eval |
| [`workflows/notes-ship.rhai`](./workflows/notes-ship.rhai) | `.grok/workflows/notes-ship.rhai` | Orchestrator for the old ship path |

`.grok/rules/` was not a second copy. Each file was a symlink into `rules/`. The symlinks were removed when `rules/` moved here.

Skill-by-skill detail: [`skills/README.md`](./skills/README.md).
