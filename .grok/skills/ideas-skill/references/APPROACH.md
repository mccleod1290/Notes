# How he approaches a topic

His definitions, from the hand-written post 1630. Not a nicer version.

## First principles

Default for a concept.

He means: understand the idea from its roots, and break it into the parts the outcome depends on.

Do this, in order:

1. Name the parts that the result actually depends on. Drop the rest.
2. State the conditions required for it to work.
3. State when it is N/A, meaning a required condition is missing.
4. Only then describe how to do it or how to test it.

His own check, from 1630: "how does this work, what conditions are required, and when is it N/A?" The SQL-injection line in that post is the pattern. The topic changes. The three questions do not.

## Second-order thinking

Use only when the first result is not the thing he needs to learn.

He means: what happens next when that happens. Consequences of consequences, not a stop at the immediate result.

Trigger: a chain, a side effect, "what does the attacker get after this," or "what breaks one step later."

If the question is only "what is this and when does it work," do not add this model.

## Invariant

He spells it both ways. The meaning he gave: test whether the reasoning still holds when an assumption or a condition changes.

His question: "What remains true even when other required conditions for this change?"

Trigger: a filter, a different language, another encoding, a control that removes one condition. Ask what is still true, and what stopped being true.

If nothing about the conditions is changing, do not add this model.

## How that shows up in security work

These are his choices about what to look at. The white-box paragraphs that carry them were written by the model. Keep the choice. Do not keep that wording.

**Black box.** His idea and, in the series, also his voice. Use the feature. One input at a time. A try that fails is data: it shows which check fired. The payload that counts is the one the application accepted, not the famous one. He says this in the 989 black-box labs: fuzzing two parameters together hides which one is vulnerable.

**White box.** His idea. The model wrote the execution. Find the line that places user input into an interpreter, a query, a template, or a command (`system`, `exec`, `eval`, and the same class of sink). The payload shape comes from how that string is built. The fix is the check that line was missing. Then say what changed.

**Lookalikes.** Separate them by what they do, not by synonyms, when mixing them up would cause the wrong next step. Replay is not relay. A loose compare is not a strict one.

**Defender.** Name the concrete control that removes a required condition. Not a slogan.

**Rooms.** Most TryHackMe posts and Pilgrimage are his idea as well as his voice, and the idea there is shallower: do the step, do not skip one, search if a term is missing. That is the right approach for a room log. It is not the approach for learning a mechanism. For a mechanism, use first principles, then black box, then white box if source exists.

## Learning stance

From 1630, which is his:

- Understand the thing first. Then fit a tool, a prompt, or a goal. Not the other way around.
- Do not outsource the understanding. A model draft is something to check against the real mechanism.
- Ask a specific question. "I did not understand this whole topic" is the weak form.
- A real attempt comes before the check. Struggling on purpose is part of the method. Rushing is not.
- If the canonical path is too steep or too expensive, a narrower path that still teaches the mechanism is valid. He does this in 1470.

## Evidence

- 1630: the three definitions, the SQL-injection question, and the rule that understanding is not outsourced.
- 989 black box: one parameter, keep the failed character, then the payload that worked.
- 989 white box, idea only: `system("ping -c4 ${ip_address}")` is the line the payload has to match. The commentary around it is not evidence of his thinking style.
- 626: room approach is follow the steps. He says the room will not carry the long explanation.
- 1470: one vulnerability, in depth, beats a pile of short tricks. A free path exists beside the paid one.

## Uncertain

- He has not named a fourth model. Do not add one.
- Line-by-line credit for series intros and for posts he has not labeled (825, 835, 1329, HTB other than Pilgrimage) is still open. Do not treat them as new models.

## Learned from corrections

- 2026-09-23: Voice and ideas are separate skills. Voice is the writer. Ideas are this file. First principles is the default. Invariant and second-order thinking are added only when the topic needs that model.
