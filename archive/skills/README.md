# Archived skills

Moved on 2026-09-23 out of the live skill folders.

Live skills stay in `.grok/skills/` only:

- `writer-skill` — how the writing sounds
- `ideas-skill` — how a topic is approached (first principles by default; second-order and invariant only when that model is needed)

Nothing in `.agents/skills/` is live. That folder was removed. Agent files (`.agents/*.md`, `.agents/*.yaml`) were not archived. They still point at the old skill paths.

## from-grok

These used to live in `.grok/skills/`.

| Folder | Former path | What it was |
|--------|-------------|-------------|
| `content-eval` | `.grok/skills/content-eval` | Notes eval loop |
| `first-principles-blog` | `.grok/skills/first-principles-blog` | Three-part block for each command and flag in a lab writeup |
| `lab-writeup` | `.grok/skills/lab-writeup` | Medium-style CTF / HTB writeup shape |
| `notes-ship` | `.grok/skills/notes-ship` | Notes ship workflow skill |

`.grok/skills/simple-english` was not a copy. It was a symlink to `.agents/skills/simple-english`. The symlink was removed. The skill itself is `from-agents/simple-english`.

## from-agents

These used to live in `.agents/skills/`.

| Folder | Former path | What it was |
|--------|-------------|-------------|
| `first-principles-blog` | `.agents/skills/first-principles-blog` | Same tree as the `.grok` copy |
| `lab-writeup` | `.agents/skills/lab-writeup` | Same tree as the `.grok` copy |
| `simple-english` | `.agents/skills/simple-english` | Simplified Technical English rules |

`first-principles-blog` and `lab-writeup` were byte-identical in both places. Both copies are here so each old path still has a folder.

## Not updated

Rules, workflows, and agent files still name the old paths (`.grok/skills/lab-writeup`, `.agents/skills/simple-english`, and the others). Those references were left as they were. Opening a live skill means `.grok/skills/writer-skill` or `.grok/skills/ideas-skill` only.
