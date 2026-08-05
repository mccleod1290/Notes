# Notes vault — agent rules

This is a **learning / operator notes** vault (not a live attack tree).

**HARD DEFAULT:** every substantive deliverable follows the **ship pipeline** below.
Do not skip steps unless the operator explicitly opts out with the skip phrases.

---

## Ship pipeline (mandatory — non-negotiable)

Whenever you **create, rewrite, expand, polish, or finish** work in this vault
(study notes, guides, checklists, templates, operator docs, README teaching
sections, eval harness files, or any other artifact the operator will keep):

```text
1. CONTENT GEN     draft / write the file(s) on disk
2. CONTENT EVAL    run content_eval agent/skill 3× (see loop)
3. GIT             commit + push to origin (never force-add logs/)
4. MAIL            email markdown + PDF (when prose) to study inbox
```

A task is **not done** until steps that apply have finished (or the operator
used an explicit skip phrase). Saying “here is the draft” in chat without
git + mail is incomplete.

### Step 1 — Content gen

- Write real files under the vault (prefer `AI/`, topic folders, etc.).
- For **study / course topics**, complete the **study research pack** first
  (official docs + gold-mine blogs), then draft.

### Step 2 — Content gen ↔ content_eval 3× agent loop

After the draft exists on disk:

1. Load **content_eval** (skill `/content-eval` or agent `content_eval`).
2. Run **exactly three sequential passes** on the content:

| Pass | Lens | Job |
|------|------|-----|
| **1** | `slop_chop` | Kill AI fluff; raise density |
| **2** | `first_principles` | Definition, mechanism, high-level map, beginner-clear |
| **3** | `core_questions` | 3–7 core Qs answered or marked gap; force clarity |

3. On **FAIL** for a pass: rewrite (max 2 rewrites per pass) → re-run that lens.
4. Overall must be **SHIP** (or **BLOCKED** with ≤5 human questions).
5. Report the three verdicts + overall before claiming done.

**Sources:**

| piece | path |
|-------|------|
| agent | `.grok/agents/content_eval.md` (`subagent_type: content_eval`) |
| skill | `.grok/skills/content-eval/SKILL.md` → `/content-eval` |
| rule | `.grok/rules/content-eval-mandatory.md` |

**Skip content_eval only if:** operator says `skip content-eval` / `raw dump ok` /
`no eval`, **or** pure mechanical change (typo/path/git metadata) with no teaching prose.

### Step 3 — Git (always)

After content is SHIP (or non-prose change is ready):

1. `git status` / `git diff` / recent log style as usual.
2. Stage **only** intended artifacts (never `git add -f logs/` or secrets).
3. Commit with a clear message (why this change).
4. **Push** to `origin` (SSH/HTTPS as configured). Rebase/pull if needed; resolve conflicts honestly.
5. Report commit hash + push result to the operator.

**Skip git only if:** operator says `skip git` / `no push` / `local only`.

If author/identity or auth fails: fix or report the exact blocker — do not silently leave work uncommitted when git was required.

### Step 4 — Mail (always for keepable artifacts)

Default: **email every keepable deliverable** to the study inbox via pwnjournal SMTP.

```bash
# typical (paths adjust to workspace)
python3 /home/kali/HTB/PwnJournal/scripts/md_to_pdf.py PATH.md -o PATH.pdf
python3 /home/kali/HTB/PwnJournal/scripts/send_report_email.py \
  --subject "[Notes] <short title>" \
  --body "<one-line what shipped>" \
  PATH.pdf PATH.md
```

- Config: `~/.config/pwnjournal/smtp.env` (or `PWNJOURNAL_SMTP_ENV` / `.env.smtp`).
- Default To: `SMTP_TO` (study inbox, e.g. dailyupdatesforstudies@gmail.com).
- Attach **PDF + markdown** when the deliverable is prose notes.
- For multi-file packs, attach the full set in one mail when practical.
- If mail fails: still keep files + git; report the error (do not pretend mailed).

**Skip mail only if:** operator says `skip mail` / `no email` / `don't mail`.

---

## Study research pack (mandatory on every study topic)

Whenever you **create or expand study notes** for a course module, product topic,
or learning unit (Associate modules, platform foundations, etc.):

### 1. Fetch official product docs (Claude / Anthropic when the course is Claude)

Use web search + open primary pages. Prefer:

- `support.claude.com` Help Center
- `platform.claude.com` / `docs.anthropic.com` platform docs
- `anthropic.com/engineering` and `anthropic.com/news` for mechanism-level posts
- Plan/UI limits: re-fetch (they change); never invent caps

Capture **links + one-line so-what** under **Official Claude / Anthropic references**
(or vendor-equivalent if the topic is not Claude).

### 2. Fetch gold-mine sources outside product docs

Reputable **first-principles** material that is *not* a click-path UI tutorial:

| Prefer | Examples |
|--------|----------|
| Vendor engineering (mechanism) | Anthropic / OpenAI engineering |
| Known practitioners | Simon Willison, Addy Osmani, similar long-form |
| Concept explainers | Context eng vs prompt eng, agent memory, tools |
| Avoid as sole authority | SEO listicles, anonymous “top 10”, undated affiliate posts |

Every study note must include:

```markdown
## Gold-mine blogs (outside Claude product docs)
```

(or “outside &lt;vendor&gt; product docs”). Each row: link + why it is gold.

### 3. Do not restrict examples to one vendor

Map concepts to ChatGPT / Gemini / Grok / local agents when principles transfer.

### 4. Then run the full ship pipeline

Research → draft → content_eval 3× → git push → mail.

**Skip research pack only if:** operator says `skip research` / `course text only`.

Rule file: `.grok/rules/study-sources-mandatory.md`.

---

## Skip phrases (only valid opt-outs)

| Phrase | Skips |
|--------|--------|
| `skip content-eval` / `raw dump ok` / `no eval` | Step 2 |
| `skip git` / `no push` / `local only` | Step 3 |
| `skip mail` / `no email` / `don't mail` | Step 4 |
| `skip research` / `course text only` | Study research pack |
| `ship pipeline off` | All of steps 2–4 for that turn only (still write files if asked) |

No skip phrase → **run the full pipeline**.

---

## Tone for this vault

- frugal, copy-paste useful, just-in-time why
- first principles over tour-guide fluff
- authorized-testing scope only when discussing attacks
