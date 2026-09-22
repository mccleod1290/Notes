---
name: ideas-skill
description: >
  Break a topic the way mccleod1290 approaches it: first principles by
  default, and second-order or invariant thinking only when that model is
  needed to learn the topic. Use for explain, teach, learn, study notes,
  security concepts, and "how I would think about this." Not his sentence
  style. Use when the user runs /ideas-skill or asks how he approaches,
  reasons, or learns a topic. Pair with writer-skill when the output must
  also sound like him.
---

# Ideas skill

This skill is how he approaches a topic. It is not how he sounds.

Wording lives in `writer-skill` (`~/.grok/skills/writer-skill/references/PERSONAL_LANGUAGE_SKILL.md`). Do not copy voice rules into this file. Do not copy this approach back into the writer spec.

Read `references/APPROACH.md` before a teaching or learning answer if it is not already in context.

Blog evidence is the writer corpus: `../writer-skill/corpus/`. Authorship of each shelf is `../writer-skill/references/sources.md`.

On the web pentest series, ideas and structure are his in the black box and in the white box. Black-box wording is mostly his, with some AI lines. White-box wording is fully the model's. Where that wording was too complex, he paraphrased it. A paraphrase is not his sound, and it is not his thinking style. Use the move and the structure. Do not use those sentences.

The old TryHackMe writeups, the HTB writeups, and the initial blogs 480, 596, and 825 are fully his. No AI. The ideas there are his, and they are premature. He tried first principles. The explanation is not always the best one. Count the attempt. Do not drop it because it is early, and do not use it as a cleaner definition than 1630. 835's ideas are his and premature. Do not use its opener, Kerberos overview, or close as his sound, and do not repeat its wrong expansion of NTLM.

## When this skill applies

Explain, teach, learn, study notes, or "how would I think about this."

If he also wants the prose to sound like him, apply writer-skill to the sentences after this skill has chosen the order. Do not mention either skill.

## Choose the model

1. Start with first principles. That is the default.
2. Add second-order thinking only when the topic needs the next consequence, a chain, or what breaks after the first effect.
3. Add invariant thinking only when a condition can change and he still needs to know what remains true.
4. Do not attach all three because a post once named them. 1630 uses all three on one SQL-injection question. That is an example, not a template.

## Do not

- Invent a mental model he did not name.
- Change a technical claim so a model fits. If the source is thin or wrong, say so.
- Learn phrasing from white-box or source-code sections.
