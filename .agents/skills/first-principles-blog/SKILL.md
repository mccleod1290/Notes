---
name: first-principles-blog
description: >-
  write first-principles blog and lab writeup explanations: every keyword,
  technique, and command gets a 3-part block (plain definition, adjacent
  terms, variations grounded to the same first principle). use when the user
  says first principles blog, 3-part explanation, explain flags, adjacent
  terms, grounded variations, /first-principles-blog, or when lab-writeup /
  writeup_writer needs keyword teaching blocks.
---

# first-principles-blog

Teach one idea at a time. The reader is tired. One sentence must carry the
definition. Adjacent names exist so they do not mix the idea with its cousins.
Variations stay on the **same primitive**, not a new attack class.

Load this skill whenever you write a **blog**, **lab writeup**, or **study
note** that names a tool, flag, user, file, or bug class.

Companion for **post shape** (steps, screenshots, Beyond Root): `lab-writeup`.
This skill owns **how a word is explained**. `lab-writeup` owns **how the
walkthrough is sequenced**.

## The 3-part block (mandatory)

For **every key term** — keyword, technique, OS object, **and every command** —
emit this block. Part 1 is **one sentence**. Parts 2–3 stay short.

```markdown
**1. What it is (first principle).**
<one sentence a non-expert can repeat. Name the job, not the brand.>

**2. Adjacent terms (same family, different packaging).**
- <cousin A> — how it is the same primitive, and how it differs
- <cousin B> — same
Why the names differ: <one sentence>.

**3. Variations grounded to that primitive.**
Stay on THIS job. List other files, flags, tools, or sites that do the
*same* job faster or in the next obvious place. Do not jump to a new
bug class.
```

### What counts as a key term

Emit a block when the reader meets a name for the first time, or when the
name does work in the chain:

| Kind | Examples |
|------|----------|
| File packaging | `app.min.js`, source map, `main.js` |
| Bug class | IDOR, SSTI, XSS |
| OS object | `www-data`, `adm`, mode `644` |
| Protocol object | session cookie, `HttpOnly` |
| Command | `nmap`, `curl`, `ssh`, `grep` — **every flag used** |

Skip a block only for a name already defined in this post, or for a throwaway
label that does no work (`then`, `also`).

## Grounding rule (part 3)

Part 3 answers: **“If I still believe the same first principle, where else
do I look / what else do I run?”**

| Topic | Primitive | Legal part-3 | Illegal part-3 |
|-------|-----------|--------------|----------------|
| JS analysis | recover the original program | other map names, DevTools Sources, `sourcemapper` | jump to XSS payloads |
| IDOR | read object N without a check | other ids, other filters, IDOR after login | jump to SQLi |
| SSTI | server renders the string as template | other reflected fields, Jinja vs Twig canary | jump to kernel exploits |
| Log privesc | a privileged process wrote a secret to a file you can read | sibling logs (`cloud-init`, `provision*`, `auth.log`) | jump to SUID/cron/kernel |
| Command flags | each flag is one extra question to the tool | related flags of **this** tool | a different tool’s whole tutorial |

If part 3 would need a new first-principle sentence, it is a **new block**,
not a variation.

## Commands (flag law)

When you print a command, explain **every flag and positional you used**.
Table form is fine:

```markdown
| Piece | First principle |
|-------|-----------------|
| `nmap` | knock on ports; write who answers |
| `-sV` | talk a little more so the product name is visible |
```

Do not paste a flag you did not run. Do not dump the man page. Only flags
**in the command the reader is asked to run**.

## Length

- Part 1: **one sentence** (two only if the second is a why-it-exists).
- Part 2: 2–5 cousins. Same/different in one line each.
- Part 3: 3–7 grounded next looks. No new story.

Simple language. No hype. American English. Active voice.

## Worked examples

Full copy-paste examples live in `references/examples.md`.
Paste skeleton: `templates/fp-block.md`.

Minimum you must be able to reproduce from this skill:

1. **JS files** — min.js vs source map vs main.js (why three names).
2. **A command** — every flag (nmap or curl).
3. **An OS object** — `www-data`.
4. **A privesc** — provisioning log, then **sibling logs only**.

## Checklist (done when)

- [ ] Every new key term has a 3-part block
- [ ] Every command has every used flag named
- [ ] Part 1 is one plain sentence
- [ ] Part 2 names cousins and the difference
- [ ] Part 3 stays on the same primitive (grounding rule table)
- [ ] No invented probes; facts from the engagement trail

## Output

Keep the walkthrough in `lab-writeup` shape. Insert 3-part blocks **in the
step where the term first appears**, not in a glossary dump at the end.

```text
# first-principles-blog
path_written: <file>
terms_blocked: <count>
commands_flagged: <count>
grounding_ok: yes | no
one_line: <what you explained>
```
