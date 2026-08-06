# HARD RULE: ship pipeline

**Non-negotiable** default for every keepable deliverable in this vault.

Vault purpose (see `AGENTS.md`): personal **bug bounty → architect → first
principles** learning. Not a university term track. Side folders such as
`agriculture/` (one-off SVU help) do not change this pipeline’s defaults.

---

## Document create workflow (core — this is the product)

**Only two agents. Only one skill for language: simple-english.**

```text
1. WRITER        write once on disk + simple-english 1× pragmatic
2. FRUGAL-EVAL   simple-english 3× hardcore (filter / rewrite)
```

| Step | Agent | Skill (required) | Passes | Mode |
|------|-------|------------------|--------|------|
| 1 | **writer** | **simple-english** | 1 | pragmatic |
| 2 | **frugal-eval** | **simple-english** | 3 | hardcore |

Both agents **must** load and apply
`.agents/skills/simple-english/SKILL.md` (and checklist for frugal-eval).
No document create step without that skill.

**content_eval is not in the default create path.** It is optional on request
only (`rules/content-eval-mandatory.md`). Structure noise on top of STE 3× is
not worth the default cost.

Done for **create** when: draft on disk, writer STE 1× done, frugal-eval overall
**SHIP** (or operator accepts REVISE).

---

## Full ship (after create — delivery, not more language eval)

```text
0. RESEARCH (optional facts)  rules/study-sources-mandatory.md — do not invent
1. WRITER                     simple-english 1× pragmatic
2. FRUGAL-EVAL                simple-english 3× hardcore
3. GIT                        commit + push origin
4. MAIL                       PDF + MD to study inbox
```

Research is **not** an agent eval layer. Use it only so writer does not invent
caps, APIs, or vendor limits. Prefer sources into Doc 2 when using two-doc.

### Learning topics: two files, two PDFs (shape, not extra eval)

| PDF | File | Content |
|-----|------|---------|
| **1** | `TOPIC-principles.md` | Mechanism, gotchas, critical tips (almost no URLs) |
| **2** | `TOPIC-references.md` | Official + gold-mine sources + so-what tips |

Rule: [`rules/two-doc-ship-mandatory.md`](./two-doc-ship-mandatory.md).  
Templates: `Templates/topic-principles.md`, `Templates/topic-references.md`.

Writer writes both → frugal-eval filters both with simple-english 3× each.
No third language/structure agent required.

A task is **not done** for full ship until git + mail finish (unless skip
phrases). Create-only is done after frugal-eval SHIP.

## Hardcoded map (agents + skills + rules)

| Step | Agent name | Spawn | YAML / body | Skill | Passes | Mode | Rule file |
|------|------------|-------|-------------|-------|--------|------|-----------|
| 1 | **writer** | `writer` | `.agents/writer.yaml` · `.grok/agents/writer.md` | **simple-english** | 1 | pragmatic | `rules/writer-mandatory.md` |
| 2 | **frugal-eval** | `frugal-eval` | `.agents/frugal-eval.yaml` · `.grok/agents/frugal-eval.md` | **simple-english** | 3 | hardcore | `rules/frugal-eval-mandatory.md` |

| Optional (not default) | Skill |
|------------------------|--------|
| content_eval (only if operator asks) | content-eval — see `rules/content-eval-mandatory.md` |

| Skill | Canonical path | Grok path |
|-------|----------------|-----------|
| **simple-english** (only language skill in default create) | `.agents/skills/simple-english/` | `.grok/skills/simple-english/` (symlink) |

Index: `.agents/README.md` · `AGENTS.md` · `rules/README.md`.

## Step detail

### 0 — Research (optional facts)

See `rules/study-sources-mandatory.md`. Fetch when the topic needs vendor truth.
Do not invent. Then continue at step 1.

### 1 — writer (write once + STE 1×)

See `rules/writer-mandatory.md`.

- Prefer `subagent_type: writer` (contract: `.agents/writer.yaml`).
- Write real files (core folders: `AI/`, `api/`, `IIS/`, `AEM/`, `web-app-testing/`, etc.).
- **Must** load and run **simple-english** once in **pragmatic** mode per file.
- Hand off to frugal-eval. Do not claim final ship.

### 2 — frugal-eval (STE hardcore 3×)

See `rules/frugal-eval-mandatory.md`.

- Prefer `subagent_type: frugal-eval` (contract: `.agents/frugal-eval.yaml`).
- **Must** load **simple-english** + `references/checklist.md`.
- Mode: **hardcore** only. Three sequential passes; max 2 rewrites each.
- Overall **SHIP** | **REVISE** | **BLOCKED**.
- Create path ends here (language). Delivery continues only if full ship wanted.

### 3 — Git (full ship)

1. Stage only intended artifacts.
2. Commit with clear message.
3. Push to `origin` (pull/rebase if needed).
4. Report commit hash + push result.

Never `git add -f logs/`. Never commit SMTP secrets or live credentials.

### 4 — Mail (full ship)

**Learning topics (default — two PDFs):**

```bash
python3 /home/kali/HTB/PwnJournal/scripts/md_to_pdf.py TOPIC-principles.md -o TOPIC-principles.pdf
python3 /home/kali/HTB/PwnJournal/scripts/md_to_pdf.py TOPIC-references.md -o TOPIC-references.pdf
python3 /home/kali/HTB/PwnJournal/scripts/send_report_email.py \
  --subject "[Notes] <topic> — principles + references" \
  --body "Doc1: first principles + critical tips. Doc2: official + gold-mine refs." \
  TOPIC-principles.pdf TOPIC-principles.md \
  TOPIC-references.pdf TOPIC-references.md
```

**Single-file deliverables only** (batches, pure checklists, or skip phrase):

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
| `skip ste` / `skip simple-english` / `skip writer ste` | writer STE + frugal-eval |
| `skip frugal-eval` / `no hardcore ste` | frugal-eval only |
| `skip git` / `no push` / `local only` | git |
| `skip mail` / `no email` / `don't mail` | mail |
| `skip research` / `course text only` | research |
| `create only` / `no ship` | git + mail (stop after frugal-eval) |
| `single doc ok` / `one pdf only` | two-doc pair |
| `skip references` / `principles only` | Doc 2 |
| `skip principles` / `refs only` | Doc 1 |
| `run content-eval` / `structure eval` | **enables** optional content_eval (off by default) |
| `ship pipeline off` | frugal-eval + git + mail for that turn |

No phrase → **writer + frugal-eval (simple-english)** + git + mail for keepable
deliverables. Two-doc pair for learning topics
(`rules/two-doc-ship-mandatory.md`).

## Do not

- Add content_eval (or any non–simple-english language agent) to the default create path
- Claim create done after writer without frugal-eval (unless skip phrase)
- Run frugal-eval without loading simple-english skill + checklist
- Invent a third mandatory “polish” agent
