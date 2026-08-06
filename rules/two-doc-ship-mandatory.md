# HARD RULE: two-doc ship (principles PDF + references PDF)

**Non-negotiable** for keepable **learning / study** deliverables in this vault.
Part of ship pipeline: `rules/ship-pipeline-mandatory.md`.

## Why

Mixing official links, gold-mine blogs, and mechanism prose in one file
weakens both:

| Mix problem | Effect |
|-------------|--------|
| Links inside first-principles text | Mechanism gets thin; doc summaries get shallow |
| Tips buried under URL tables | Critical operator points get lost |
| One fat PDF | Hard to re-read for craft vs hard to open for sources |

**Split is fixed.** Two markdown files → two PDFs. Do not recombine for mail.

## Default audience goals

Write Doc 1 so it improves how you:

- hunt (bug bounty / authorized pentest)
- audit (e.g. Azure / cloud / app)
- use AI as an operator (not as a tour guide)
- think like a future security architect

Doc 2 supports that with **sources only** — not a second full course.

---

## Pair naming (fixed)

For topic slug `TOPIC` under a core folder:

| Role | Markdown | PDF |
|------|----------|-----|
| **Doc 1 — craft** | `TOPIC-principles.md` | `TOPIC-principles.pdf` |
| **Doc 2 — sources** | `TOPIC-references.md` | `TOPIC-references.pdf` |

Examples:

```text
AI/capability-layer-principles.md
AI/capability-layer-references.md

api/bola-principles.md
api/bola-references.md
```

Cross-link once at the top of each file (sibling path only). No other coupling.

---

## Doc 1 — principles + critical tips (PDF 1)

**Job:** teach mechanism + the few tips that change how you work.

### Must include (in order, frugal)

1. **One-sentence definition**
2. **Why it exists** (problem the mechanism solves)
3. **Mechanism** (how it works — first principles)
4. **High-level map** (parts and how they connect)
5. **Critical points everyone misses** (short list; high leverage only)
6. **Gotchas** (failure modes that waste time or create false confidence)
7. **Critical tips for your goals** — only tips that are **critical** for:
   - bug bounty / authorized appsec
   - cloud / Azure-style audit when the topic touches identity/config
   - better cybersec / appsec practice
   - AI-assisted operator work
   - architect-level judgment (tradeoffs, trust boundaries)
8. **IF / THEN** (edges)
9. **Do this** (minimal practice steps — not a link dump)

### Must NOT include

- Official doc tables
- Gold-mine blog tables
- Long “see also” URL lists
- Inline “according to https://…” rewrites of vendor pages
- Extra “nice to know” tips that do not change decisions

**Link budget for Doc 1:** zero external URLs preferred.  
Allowed only if a **command, path, CVE ID, or standard name** needs a single
canonical identifier — still no website tours. Prefer put every URL in Doc 2.

### Tip budget (do not over-write)

| Cap | Rule |
|-----|------|
| Critical points everyone misses | **3–7** bullets max |
| Gotchas | **3–7** bullets max |
| Critical tips for goals | **3–7** bullets max; each tip must change a decision or workflow |
| If you cannot justify “critical” | Delete the tip |

---

## Doc 2 — official docs + gold-mine references (PDF 2)

**Job:** curated sources + short so-what + **extra tips drawn from those sources**.

### Must include

1. **How to use this pack** (2–4 lines: open when you need proof / depth / vendor truth)
2. **Official product / standard docs** table:

   | Link | What it teaches (mechanism, not marketing) | Operator so-what |
   |------|--------------------------------------------|------------------|

3. **Gold-mine first-principles sources** table (outside pure product docs when useful):

   | Link | Why gold | Extra tip from that source |
   |------|----------|----------------------------|

4. **Cross-stack / cross-vendor map** when principles transfer (optional section;
   skip if none)
5. **Suggested read order** (optional, short numbered list)

### Writing bar for Doc 2

- Every row needs a **so-what** or **extra tip** — never bare URLs.
- Explain what the **source** gives you (1–2 lines). Do **not** re-teach the
  full Doc 1 mechanism inside each row.
- Prefer vendor docs, OWASP, RFCs, PortSwigger Research, vendor engineering blogs,
  primary writeups with repro. Avoid SEO listicles as sole authority.
- Mark `gap` if a critical official page was not found.

### Must NOT include

- Full re-explanation of definition / mechanism (that is Doc 1)
- Long narrative that pastes the source page
- Tips with no source row to anchor them (orphan tips → move to Doc 1 only if critical)

Research pack rule: `rules/study-sources-mandatory.md` — **land all fetched
links in Doc 2**, not in Doc 1.

---

## Pipeline interaction

```text
0. STUDY RESEARCH     → notes for Doc 2 (links + so-what)
1. WRITER             → write BOTH files; STE 1× each (pragmatic)
2. FRUGAL-EVAL        → STE hardcore 3× on BOTH (or Doc 1 first if time-box)
3. CONTENT_EVAL       → structure 3× on Doc 1 always; Doc 2 for clarity of tables
4. GIT                → commit both .md (and both .pdf if you keep PDFs in repo)
5. MAIL               → two PDFs + two MDs
```

### Mail (step 5) — always both

```bash
python3 /home/kali/HTB/PwnJournal/scripts/md_to_pdf.py TOPIC-principles.md -o TOPIC-principles.pdf
python3 /home/kali/HTB/PwnJournal/scripts/md_to_pdf.py TOPIC-references.md -o TOPIC-references.pdf
python3 /home/kali/HTB/PwnJournal/scripts/send_report_email.py \
  --subject "[Notes] <topic> — principles + references" \
  --body "Doc1 principles/critical tips. Doc2 official + gold-mine refs." \
  TOPIC-principles.pdf TOPIC-principles.md \
  TOPIC-references.pdf TOPIC-references.md
```

Shipping only Doc 1 or only Doc 2 is **incomplete** for learning topics
(unless a skip phrase below).

---

## Scope: what must use two docs

| Deliverable type | Two-doc? |
|------------------|----------|
| Study notes, first-principles explainers, platform/module notes | **Yes** |
| Topic “how it works” writeups (AI, API class, cloud, IIS theory, …) | **Yes** |
| Operator execution batches (DO THIS cards) | **No** — keep card shape; optional one-line pointer to topic `*-references.md` |
| Pure checklists / engagement templates | **No** (unless they become teaching essays) |
| Pure mechanical path/typo fixes | **No** |

When an execution batch needs sources, put links in the topic-level
`*-references.md`, not as a long mix inside the batch card.

---

## Skip only if

| Phrase | Effect |
|--------|--------|
| `single doc ok` / `one pdf only` | Allow one combined file for that turn |
| `skip references` / `principles only` | Ship Doc 1 only |
| `skip principles` / `refs only` | Ship Doc 2 only |
| `ship pipeline off` | Full pipeline opt-out (existing) |

No phrase → **two docs, two PDFs** for learning topics.

---

## Templates

| File | Use |
|------|-----|
| `Templates/topic-principles.md` | Skeleton for Doc 1 |
| `Templates/topic-references.md` | Skeleton for Doc 2 |

Copy, rename to `TOPIC-principles.md` / `TOPIC-references.md`, fill, then run
writer → frugal-eval → content_eval → git → mail.

---

## Do not

- Mix gold-mine tables into Doc 1
- Pad Doc 1 with non-critical tips
- Call a URL list a “first principles” note
- Invent caps, limits, or vendor behavior — mark `gap` and fetch for Doc 2
- Treat this rule as optional for study notes without a skip phrase
