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

The same three questions apply to a weird mark in a payload. 998: each odd character has a reader, the browser, the server, or a filter.

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

## When the topic arrives as a slogan

When the topic shows up as a slogan, a secret prompt, or a five-minute trick, that frame is not the lesson.

1. Say what the piece is not.
2. Give the mechanism first.
3. Keep only the slice of the claim the mechanism still allows.

480 does this. Next-token probability comes before the jobs claim. Repetitive work with no correctness check can go. Work that needs someone to check the answer stays. 1630 says the piece is not a niche prompt and not the one right way. 1470 says it is not a buy-this review and not five-minute hacks. One vulnerability, in depth, and a free path beside the paid one.

The sentence habit of saying what the piece is not lives in the writer skill. This section is the decision.

## How that shows up in security work

These are his choices about what to look at. The white-box paragraphs that carry them were written by the model. Keep the choice. Do not keep that wording.

**Black box.** His idea and, in the series, also his voice. Use the feature.

His rule of thumb, from the 989 black-box lab: fuzz one parameter at a time. Two insertion points in one request hide which field is vulnerable. He had just fuzzed both, then wrote that correction.

That rule is for finding which field is vulnerable. It is not a rule for every form. In the 978 login bypass he fuzzes username and password together, same payload, to bypass the login.

A failed response is data. He keeps the class of response (an error, an odd number, a leak, no delay) and that class picks the next edit. He does not always name the check. The payload that counts is the one the application accepted, not the famous one. He then says why the working payload has the extra piece. In 989, no delay means add `#` and URL-encode it.

**White box.** His idea. The model wrote the execution. Find the line that places user input into an interpreter, a query, a template, or a command (`system`, `exec`, `eval`, and the same class of sink). The payload shape comes from how that string is built. The fix is the check that line was missing. Then say what changed.

**Lookalikes.** Separate them by what they do, not by synonyms, when mixing them up would cause the wrong next step. Replay is not relay. A loose compare is not a strict one.

**Defender.** Name the concrete control that removes a required condition. Not a slogan.

**Rooms.** Most TryHackMe posts and Pilgrimage are his idea as well as his voice, and the idea there is shallower: do the step the room needs, search if a term is missing. 626 prices a skipped step at about 15 minutes. A side path that does not change the outcome can be dropped, and he says so (540, 627, 694). That is the right approach for a room log. It is not the approach for learning a mechanism. For a mechanism, use first principles, then black box, then white box if source exists.

## Learning stance

From 1630, which is his:

- Understand the thing first. Then fit a tool, a prompt, or a goal. Not the other way around.
- A finished result is not understanding. If the only reason for the approach is that a model suggested it, he has not learned it. He has to say what he did and why (1630).
- Ask a specific question. "I did not understand this whole topic" is the weak form.
- The full attempt comes first. Struggling on purpose is part of the method. Rushing is not.
- The preferred check is a person one step ahead. A model is the fallback: use it to question the attempt and to cite a source, not to hand the understanding back. People first (1630).
- If the canonical path is too steep or too expensive, a narrower path that still teaches the mechanism is valid. He does this in 1470.

## Evidence

- 1630: the three definitions, the SQL-injection question, and the rule that "a model suggested it" is not an explanation. People one step ahead are the preferred check.
- 480: mechanism before the slogan, then only the slice of the claim that survives.
- 989 black box: one parameter when two would hide the vulnerable field. The failed response picks the next edit. Then why the working payload has the extra piece.
- 978 black box: both login fields, same payload, to bypass the login.
- 998: each odd mark has a reader. First principles on the syntax, not a new model.
- 989 white box, idea only: `system("ping -c4 ${ip_address}")` is the line the payload has to match. The commentary around it is not evidence of his thinking style.
- 626: room approach is follow the steps the room needs. He says the room will not carry the long explanation.
- 1470: one vulnerability, in depth, beats a pile of short tricks. A free path exists beside the paid one. The piece is not a buy-this review.

## Uncertain

- He has not named a fourth model. Do not add one. Diligence and discernment are named once, in 1630. They are not extra models.
- Line-by-line credit for series intros and for posts he has not labeled (825, 835, 1329, HTB other than Pilgrimage) is still open. Do not treat them as new models. 835's outline matches 480. Do not treat its Kerberos steps as his method.
- 614's preference for a tool whose manual he can read is one post. Not a method.
- 1470's "application context beats a bug catalog" and "where did this id come from" are the instructor's method, adopted in one post. Not a model he defined.

## Learned from corrections

- 2026-09-23: Voice and ideas are separate skills. Voice is the writer. Ideas are this file. First principles is the default. Invariant and second-order thinking are added only when the topic needs that model.
- 2026-09-23, corpus pass: A slogan is not the lesson. One-parameter fuzzing is the 989 rule for finding the vulnerable field, not a rule for every form. A failed response picks the next edit. "A model suggested it" is not understanding. The preferred check is a person one step ahead.
