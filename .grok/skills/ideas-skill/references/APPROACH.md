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

These are his choices about what to look at. On the web pentest series the ideas and the structure are his in both halves. Black-box wording is mostly his, with some AI lines, so a lab move can come from that narration. White-box wording is fully the model's. Where that wording was too complex, he paraphrased it. Keep the move and the order of the sections. Do not keep the sentences, and do not keep the paraphrase.

**Black box.** His idea and his structure. In the series the lab narration is mostly his voice, with some AI lines. Use the feature. Do not promote one smooth sentence from that narration into a new model.

His rule of thumb, from the 989 black-box lab: fuzz one parameter at a time. Two insertion points in one request hide which field is vulnerable. He had just fuzzed both, then wrote that correction.

That rule is for finding which field is vulnerable. It is not a rule for every form. In the 978 login bypass he fuzzes username and password together, same payload, to bypass the login.

A failed response is data. He keeps the class of response (an error, an odd number, a leak, no delay) and that class picks the next edit. He does not always name the check. The payload that counts is the one the application accepted, not the famous one. He then says why the working payload has the extra piece. In 989, no delay means add `#` and URL-encode it.

**White box.** His idea and his structure. Full reliance on the model for the sentences. Find the line that places user input into an interpreter, a query, a template, or a command (`system`, `exec`, `eval`, and the same class of sink). The payload shape comes from how that string is built. The fix is the check that line was missing. Then say what changed. If a white-box sentence was only paraphrased because it was too complex, the structure still counts and the sentence still does not.

**Lookalikes.** Separate them by what they do, not by synonyms, when mixing them up would cause the wrong next step. Replay is not relay. A loose compare is not a strict one.

**Defender.** Name the concrete control that removes a required condition. Not a slogan.

**Rooms.** The old TryHackMe writeups and the HTB writeups are fully his idea and his voice. No AI. He tried first principles in them. The ideas were premature, so the explanation is not always the best one. The attempt is real. A room log still follows the steps the room needs. 626 prices a skipped step at about 15 minutes. A side path that does not change the outcome can be dropped, and he says so (540, 627, 694). Do not read that task shape as "first principles was missing." For the clean names of the models, use 1630. For evidence that he already tried, use these writeups and the initial blogs 480, 596, and 825. 835's outline is the same try, and the wording of the opener and the close is not his.

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
- 989 white box, idea and structure only: `system("ping -c4 ${ip_address}")` is the line the payload has to match. The commentary around it is the model's, including a paraphrase of a sentence that was too complex.
- Old TryHackMe writeups, HTB writeups, and initial blogs 480, 596, 825: his idea, no AI. He tried first principles. The try is early, so it is not the best statement of the model. 835 is the same early try. Its Kerberos steps are his idea and not his best wording. Do not repeat the wrong NTLM expansion.
- 626: room approach is follow the steps the room needs. He says the room will not carry the long explanation. That limit sits next to the early first-principles try. It does not erase it.
- 1470: one vulnerability, in depth, beats a pile of short tricks. A free path exists beside the paid one. The piece is not a buy-this review.

## Uncertain

- He has not named a fourth model. Do not add one. Diligence and discernment are named once, in 1630. They are not extra models.
- 658 and 1329 are still unlabeled. Do not treat them as new models. 835's Kerberos outline is his early idea. Do not promote it into the best form of the model, and do not repeat the wrong NTLM expansion.
- 614's preference for a tool whose manual he can read is one post. Not a method.
- 1470's "application context beats a bug catalog" and "where did this id come from" are the instructor's method, adopted in one post. Not a model he defined.

## Learned from corrections

- 2026-09-23: Voice and ideas are separate skills. Voice is the writer. Ideas are this file. First principles is the default. Invariant and second-order thinking are added only when the topic needs that model.
- 2026-09-23, corpus pass: A slogan is not the lesson. One-parameter fuzzing is the 989 rule for finding the vulnerable field, not a rule for every form. A failed response picks the next edit. "A model suggested it" is not understanding. The preferred check is a person one step ahead.
- 2026-09-23, collab tightened: On the web pentest series, ideas and structure are his in both halves. Black-box wording is mostly his, with some AI lines. White-box wording is fully the model's. A paraphrase of wording that was too complex is not evidence of how he thinks or how he sounds.
- 2026-09-23, early posts, checked: Old TryHackMe writeups, the HTB writeups, and 480, 596, and 825 are his idea and his wording. He tried first principles. The ideas were premature. Count the attempt. 1630 remains the clean statement of the three models. 835's ideas count. Its brochure wording does not.
