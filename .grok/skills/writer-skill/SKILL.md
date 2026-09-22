---
name: writer-skill
description: >
  Write and rewrite in mccleod1290's voice, learned from his Hacklido posts.
  Controls wording only: tone, sentence shape, room-log sound, and the
  black-box narration. Does not choose the thinking model. For first
  principles, second-order, or invariant approach, use ideas-skill. Use
  when the user runs /writer-skill or asks to write in their voice.
---

# Writer skill

Apply this skill whenever the user asks to write, rewrite, explain, teach, summarize, make notes, or turn documentation, research, or a security concept into understandable language. Also when they run `/writer-skill`.

Do not mention this skill in the output.

The voice spec is `references/PERSONAL_LANGUAGE_SKILL.md`. Read it before drafting if it is not already in context. That file is the only home for how he sounds. This file is only how to use it.

How he approaches a topic lives in `ideas-skill` (`../ideas-skill/references/APPROACH.md`). Do not restate those models here.

Local copies of all 61 Hacklido posts are in `corpus/`. The map is `corpus/INDEX.md`. Checked against the live profile on 2026-09-23: 61 posts, none missing. Do not load the whole corpus for an ordinary draft. Open one or two files from the matching shelf only if a wording choice is actually in doubt.

Sound comes from posts he wrote with no AI: the old TryHackMe writeups, the HTB writeups (694, 949, 951, 957, 958, 959, 962), the initial blogs 480, 596, and 825, and the later posts 1470 and 1630. On those, wording and idea are his. He tried first principles there. The ideas were premature, so do not treat a rough early paragraph as the best statement of the model, and do not treat it as someone else's voice. 835 is not in that set. The ideas there are his and early. The opener, the Kerberos overview, and the close are not his sound.

The black-box lab narration in `corpus/web-pentest-series/` is mostly his, with some AI lines. White-box sections are fully the model's sentences. A paraphrase of wording that was too complex is still not his sound. Ideas and structure in both halves are his, and they belong to `ideas-skill`, not to this voice. A tool catalog, a type list, or a fix cookbook is not his sound either, even with no `White box` heading. Do not imitate those sentences.

If the spec marks a behavior as uncertain, do not treat it as a rule.

## If there is no spec yet

Analyze the references named in `references/sources.md` before writing. Do not invent a voice.

## Writing

1. Get the task, the audience, and the format. A lab writeup, a short note, and an opinion post are not the same shape. Use the matching shape in the spec.
2. Apply the voice spec for the sentences. If the task is to explain, teach, or learn, the order of ideas comes from `ideas-skill`, not from this file. Do not copy white-box wording, and do not copy a paraphrase of wording that was too complex. Black-box lab narration is mostly his, with some AI lines. A room log may stay in the TryHackMe shape, because that shape is his. The target is something he could realistically have written after thinking about the subject.
3. Do not paste phrases from old posts to force the sound.
4. Drop a style habit when it makes the piece less clear or less true.
5. Keep technical claims accurate. On a conflict, accuracy wins.

## Teaching

The approach is `ideas-skill`. This skill only changes the wording after that order is chosen.

Keep the technical meaning. Do not cut a detail that changes the exploit, the fix, or the conclusion. For security topics, correctness outranks sounding natural. Label an analogy as an analogy.

## Source fidelity

When the piece teaches from external material:

source → understand → keep the technical meaning → order it with ideas-skill → write it in this voice

Do not change a claim to make it sound more like him. If the source is ambiguous, incomplete, or likely wrong, say so. Extra context must be labeled as extra context.

## New writing from the user

- If he explicitly says to learn from it, treat it as more evidence and update `references/PERSONAL_LANGUAGE_SKILL.md` and `references/sources.md`.
- If he does not, it is material for this task only.

## Corrections

Update the spec only when a correction is a general preference, not a one-off.

- "Don't use this phrase" → add it under things to avoid in the voice spec.
- "I don't explain it this way" or "this distinction matters" → that is the approach. Update `ideas-skill/references/APPROACH.md`, not this voice file.

One correction about a single sentence does not become a permanent rule. Record real updates as a dated line under "Learned from corrections" in the spec.

Never claim a habit is his unless the spec or the sources support it.

## Conflicts with other instructions

- If he asks for Simplified Technical English, follow that wording constraint. Still use his explanation order.
- If a lab-writeup skill fixes the document shape (sections, screenshots, beyond-root), keep that shape. Use this skill for the prose inside it.
