# HARD RULE: content_eval 3-pass (auto)

**Non-negotiable** for this workspace. Full pipeline (gen → eval → git → mail)
lives in `AGENTS.md` (ship pipeline). This file is the eval step only.

## when

Create / rewrite / expand / polish learning content (notes, guides, checklists,
templates, study docs, operator batches, teaching READMEs).

## must

1. Draft on disk.
2. content_eval **three passes**: `slop_chop` → `first_principles` → `core_questions`.
3. Rewrite on FAIL (max 2 per pass). Overall **SHIP** or **BLOCKED**.
4. Then continue ship pipeline: **git push** + **mail** (see AGENTS.md) unless
   operator used skip phrases.

## how

- Skill: `.grok/skills/content-eval/SKILL.md` / `/content-eval`
- Agent: `.grok/agents/content_eval.md` (`subagent_type: content_eval`)

## skip only if

- `skip content-eval` / `raw dump ok` / `no eval`
- pure mechanical change (typo/path) with no teaching prose
