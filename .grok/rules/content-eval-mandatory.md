# HARD RULE: content_eval 3-pass (auto)

**Non-negotiable** for this workspace (and wherever this rule is installed).

## when it applies

Whenever you **create, rewrite, expand, or polish** learning content the user
will read to understand or operate — including:

- notes, guides, checklists, templates, study docs
- operator batches, engagement notes, README teaching sections
- first-principles explainers, de-slop rewrites, "make this clearer"

## what you must do

1. Produce the draft (write/edit the file).
2. Run **content_eval** / skill **content-eval** with **three sequential passes**:
   - pass 1 `slop_chop`
   - pass 2 `first_principles`
   - pass 3 `core_questions`
3. Apply rewrites after each failed pass (max 2 rewrites per pass).
4. Only mark the task done when overall is **SHIP**, or report **BLOCKED**
   with ≤5 clarifying questions for the human.

## how to run

- Prefer in-process: follow `.grok/skills/content-eval/SKILL.md` and
  `.grok/agents/content_eval.md` (or `~/.grok/...` copies).
- Optional: `spawn_subagent` with `subagent_type: content_eval` for a large
  isolated review, then apply the returned edits.
- Slash: `/content-eval` on a path or paste.

## skip only if

- user says `skip content-eval` / `raw dump ok` / `no eval`
- pure mechanical change (typo, path rename, git metadata) with no teaching prose
- non-content tasks (recon, exploit, logcheck) that do not ship learning docs

## do not

- ship first-draft AI prose as final
- rubber-stamp three PASS with zero critique
- invent technical facts to fill gaps — mark `gap` and ask
