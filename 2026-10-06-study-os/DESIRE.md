# Study OS — desire capture

Date: 2026-10-06
Status: desire capture. The first hook is now on disk under `study-os/`. Interviewer, clerk, map maker. The explainer is specified and not hooked. The shelf move is still gray.

He will write the product description, the spec, and the requirements himself. This file is the raw want, in order, plus one draft loop pick he can throw away.

Second source, not merged: `SARAV.md`. Nick Saraev, *How I Learn Complex Skills & Difficult Subjects So Fast with AI* (2026-10-03). He said the loops will be combined later.

---

## What he wants

A study operating system. Agents orchestrate the repetitions. The point is to cut learning time by building the system around the way he already digests a topic.

The soul of the note system is two skills he already has, taken from the blogs consolidated from 2023:

- How he writes. The words, the vocabulary, the sound.
- How he thinks. First principles, and second-order thinking when the next event is the lesson.

Memorizing a tool's output holds no value. He has to interpret the output, change it, vary it, and handle a case the write-up did not contain.

Public blogs stay long. About 1,500 to 3,000 words, sometimes past that. A study note on SharePoint, RBAC, or tenancy does not. That note has its own length.

## The problem he named

An AI explanation sticks for the day. Six months later he cannot say it back. He ties that to what Andrew Ng and Andrej Karpathy have said about LLMs and learning. Recorded as his reason. Not checked against a paper in this capture.

A colleague at the World Bank studies one topic ten times, across a long stretch, so each pass lays another mental rep. He said there is no substitute for the repetitions. The gap is that he has no loop that says how those ten passes are done.

New topic goes into the AI shelf. The system hands him the reps. Reps done, it moves to the shelf he trusts.

## Two shelves

Same split, three names he used. Do not invent a fourth.

| He called it | What sits there |
| --- | --- |
| Concepts studied by hand. Confidence. Acquired. Baked. | The manual method. Countless bits of feedback from colleagues. Or a topic whose reps are done. |
| Concepts studied with AI. Unbaked. | Anything the model taught that has not been repeated yet. |

The only thing between the shelves is repetitions.

### The move between shelves is a gray area

2026-10-06, his call. The first sketch left a gray area on how a new topic becomes a known topic. That gray stays. We do not write the pass rule in advance.

The way we close it is testing and analyzing. Run the reps. Look at what actually moved a topic across. Then name the rule. A metric invented before those tests is a guess.

Until that, "he can say it months later" is a wish, not a gate.

Every new answer the model gives has to point back at the manual method he already uses. That method is the reference, because it is his, and because the feedback pushed it past a surface checklist.

### Specimen: CORS

His manual pass already goes past "what is CORS":

- Why it happens.
- If the site has CSRF protection, can CORS still happen.
- Change the `Origin` header. If the server reflects it, CORS is there. If it does not reflect, CORS is not there.
- Then the intricacies past that check.

He said something heard as "Qpace goes beyond that." The word is unclear. Left as heard. Do not guess the name into the spec.

### Bitter lesson, left open

He also said he believes the "bitter pill" engineering point. LLMs sometimes find a way his method does not have. His method can go stale. He has not chosen.

Two options he put on the table:

1. Take the new method and rely on the model.
2. Enforce the manual method, and make the checklist, the questions, and the digest repeatable.

The likely public text behind "bitter pill" is Rich Sutton's *Bitter Lesson*: general methods that scale beat hand-built knowledge. That link is a label for the phrase. He did not name the essay.

No choice is recorded. The spec has to make the choice.

## One topic, in this order

Example he gave: SharePoint, how RBAC works, how to understand tenancy. Azure and CORS were the other examples.

1. Find the prerequisite skills.
2. Assume he has none. Build the foundation.
3. When the foundation is actually in place, map the adjacent terms. He called this a 3D map of the related terms.
4. Then dive into the topic.
5. The study page stays inside 5 to 10 pages. Ten is the max. Diagrams, annotations, and the rest count toward the ten.

## Four skills, one continuous loop

Until the goal for that pass is met. He said the metrics are not chosen yet.

### 1. Ideas (already exists)

Default is first principles, so the reader does not hit an unknown and stop.

His check, already in the ideas skill: how does this work, what conditions are required, and when is it N/A.

Second-order thinking is the next event. What happens when X, Y, Z happens, and what happens after that event. Use it when the first result is not the thing to learn.

He did not name invariant in this session. The ideas skill already has it, for when a condition changes and he needs what is still true. Whether this loop includes it is open.

### 2. Writer (already exists)

His sound and his vocabulary, from the 2023 blogs. The study page still has to sound like him after it is cut down.

### 3. Brevity is the soul (built)

Home: `.grok/skills/brevity_is_the_soul/SKILL.md`. The lines under this heading are the earlier capture. The skill is what the explainer follows.

Condenses. The study page does not pass 10 pages, and he wants it in the 5 to 10 band, pictures included.

It works with simple English. A simple-English skill already exists on disk. Brevity is the new skill. It calls that constraint. It does not replace the writer.

Writer and brevity act in a loop. The cut has to stay his, and it has to stay short. Brevity does not rewrite the long public blogs. Those stay 1,500 to 3,000 words.

### 4. Ambiguity (built)

Home: `.grok/skills/reduce_ambiguity/SKILL.md`. Principle: "reduce ambiguity by giving as many examples as possible to facilitate a smoother learning curve." The lines below are the earlier capture.

Cuts the friction of an unknown term without leaving the page.

- Examples, diagrams, annotations.
- A term gets two to three lines. He also said "not more than two lines." Both sentences are his. The spec settles the cap.
- A two-paragraph detour is forbidden. It pulls the reader off the point they were on.
- The skill predicts when those two or three lines are still not enough. Then it gives a reference link, so he can go expand the term and come back.
- The link is also the ground for the claim. He wants that to cut hallucination. A term too big for the page stays a one-line or two-line definition plus the link.

Ambiguity sits on the writing. It is not a separate essay.

## Draft loop pick

Source he named: Claude, *Loop engineering: Getting started with loops* (2026-06-30).

https://claude.com/blog/getting-started-with-loops

He remembered five or six types. The post defines four. A loop there is an agent repeating a cycle until a stop condition is met. Each type hands off a different piece.

| Loop | What you hand off | Fits when |
| --- | --- | --- |
| Turn-based | The check. The model decides it is done, or that it needs him. | Short, one-off, still deciding. |
| Goal-based | The stop condition. | Done can be stated up front. |
| Time-based | The trigger, to a clock. | The work comes back on a schedule. |
| Proactive | The prompt. No person in the room. | The same well-defined job, over and over, unattended. |

Draft pick, 2026-10-06. Not locked.

**Inner loop is goal-based.** One pass on one topic. He hands off the stop condition. The four skills cycle inside that goal: ideas set the order, writer drafts, brevity cuts, ambiguity adds the gloss, the picture, and the link, ideas checks the cut still has the mechanism. Repeat until the stop checks pass.

**Outer loop is time-based.** The clock brings the same topic back. Each visit runs the inner goal again. That is the process his ten-rep story was missing. The count he cited is the colleague's ten. He has not said ten is his number.

Turn-based is the wrong inner loop. The model deciding "this is done" is the thing that fades in six months.

Proactive is the wrong outer loop. A rep he did not do stays unbaked. The agent can prepare the pass. He does the pass.

```
YOU name a topic
        |
        v
+---------------------------+
| UNBAKED                   |
| assume no prerequisites   |
| foundation                |
| then the adjacent map     |
| then the dive             |
+---------------------------+
        |
        |  GOAL loop. Stop condition is his, once he writes it.
        v
+----------------------------------------------+
| ideas --> writer --> brevity                 |
|   ^                    |                     |
|   |                    v                     |
|   +-------------- ambiguity                  |
|         2-3 line gloss, diagram, link        |
|         page stays inside 5-10               |
+----------------------------------------------+
        |
        |  TIME loop. The clock brings it back.
        |  rep 1 .......... rep N
        v
+---------------------------+
| GRAY                      |
| new --> known             |
| closed by test + analyze |
| no pass mark written yet |
+---------------------------+
        |
        v
+---------------------------+
| BAKED                     |
| confidence / acquired     |
+---------------------------+
```

Saraev's roles are saved in `SARAV.md` for the combine pass. They are not wired in. The sketch of where they touch, and nothing more:

- Interviewer and mapmaker sit in front of the dive. His own order still says assume no prerequisites, then the foundation, then the adjacent map. Saraev's interviewer refuses to assume that, and skips what is already known. Both sentences stay. The combine pass has to hold them.
- The explainer is allowed on the stuck slice only. Then he redoes the task from the first step with no help. That redo is a rep, in Saraev's terms.
- Socratic questioner, examiner, checker, listener, and sparring partner are candidate shapes for a rep. None is picked.
- The diagnostician reads across reps for one shared root mistake.
- The clerk files his words only. It adds nothing. That matches the rule that the model does not write a second essay on top of his.
- The time loop is the same shape as the Ebbinghaus curve he described. Spacing is still unset.
- The case against AI is the guard on the whole picture. Skipping the struggle feels like learning. Agreement while he is half right, and invented numbers or sources, fail the pass. The ambiguity links were already aimed at invented sources.

## Stop conditions

He said he does not have the metrics. These are the limits he did state. They are not a score.

- Study page is 5 to 10 pages. Ten includes the diagrams and the annotations.
- A side definition is two to three lines. See the conflict with "not more than two."
- A predicted leftover ambiguity gets a reference link.
- The order is foundation, then the adjacent map, then the dive.
- First principles before the procedure. Second-order only when the next event is the lesson.
- The shelf move is a gray area on purpose. Testing and analyzing close it. No pass mark yet. The rep count and the spacing are not set.

## Still open, for when he writes the spec

Not questions for this session. Left here so the spec pass can close them.

1. Gloss cap. Two lines, or two to three.
2. His rep count. The colleague's number is ten. His number is unset. The spacing is unset.
3. The inner stop metrics, past the limits above.
4. Bitter lesson versus a locked manual method, and what happens when a baked note goes stale.
5. The heard word "Qpace."
6. Whether invariant joins this loop.
7. What a single rep actually is. The four-skill loop is the page process. Saraev's production roles are candidates for the hands-on rep. The combine pass picks. Not this file.

## Explicitly not done

- No new skill files.
- No agent.
- No workflow.
- No study note on SharePoint, Azure, CORS, RBAC, or tenancy.
- No product description. He writes that.
