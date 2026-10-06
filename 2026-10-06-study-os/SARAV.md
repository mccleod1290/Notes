# Nick Saraev — AI learning, saved to combine later

Date: 2026-10-06
Status: source capture. Not merged into the study loop. Not a spec.

He typed the name as "nick sarav." The channel is Nick Saraev. Video: *How I Learn Complex Skills & Difficult Subjects So Fast with AI* (2026-10-03).

https://www.youtube.com/watch?v=FSXHk4hMrY8

Chapters on the video: AI Learning Principles, AI Learning Roles, Spaced Repetition Strategy, Interviewer and Map Maker, Explainer and Review, Socratic Learning Loop, Examiners and Checks, Listener and Diagnosis, Sparring for Practice, Clerk and Organization, Learning at the Right Level, Simulations and Practice Apps, When AI Hinders Learning.

This file is the approach, in his order. It is not a transcript.

## The principle

People treat learning as consumption. Read it, watch it, get it explained. That feels like learning.

Encoding and retrieval run on production. Recall it, predict it, explain it, try it in the world. Production feels harder. The brain dodges it to save energy.

AI is there to augment production. An explainer-only habit leaves the other roles unused.

### The numbers he gave

He did not name the study. Recorded as his figures.

| Pass | 5 minutes later | A week later |
| --- | --- | --- |
| Reread the source four times | 83% | 40% |
| Read once, then get tested three times | 71% | about 61% |

He called the week-later drop about 10% for the test group, and at least 50% for the reread group. The thing he cares about is the week, the month, the year. Not the five-minute score.

## Ten roles

He said most people only use the explainer, and about nine other roles sit on the table. Those nine are mostly production.

### Explainer

Use it on the one part where he is stuck. Paste the source, ask for that part only, at his level.

Then redo the original task from the first step, with no help. Nodding along is reading, not learning. The redo is about 10 to 15% more time. He treats that as the part that makes the rest stick.

Prompt shape he gave: "I tried X. I got stuck at Y. Explain just that part at my level." Then circle back and finish it himself.

### Interviewer

Starting out. He does not know what he does not know. The model asks, it does not teach yet.

It has to get the real goal, the current level, and how he will be tested. His example: the stated goal was "learn coding." The real goal was "pass a live-coding interview in three weeks." Basic Python was already there, so reteaching it is waste. The practice has to look like the test: timed, live, from a named question bank.

Vague goals and vague plans fail this role. Specific beats "I want to pass an interview."

Prompt shape: before any teaching, ask about the goal, the level, and what has to be true for this to work.

### Mapmaker

The subject is shapeless. No curriculum. Without a next step, time goes into the anxiety of not knowing what comes next. A rough map still beats no map.

Break the subject into the main parts, what depends on what, and where people usually get stuck. His statistics sketch: averages, then spread and probability, then distributions and sampling, then an A/B test.

Prompt shape: map the main parts, the dependencies, and the usual stuck points, so the time can be planned.

### Socratic questioner

He thinks he gets it. The model asks why it works, then what changes if an input changes. It does not hand the answer. The miss shows the gap. That gap goes back to the explainer, then a new map if the miss reveals a topic he did not know he needed. Circle those three.

Prompt shape: "I want to learn X. Do not give me the answer. Ask until I find what I do not know."

### Examiner

He covered the topic and wants a score. One question at a time. Each one harder. Stop at the first level he misses. That level is where the next study goes. Oral, verbal, or written. He compared it to an old thesis defense.

Prompt shape: "Quiz me. One question at a time. Harder until I miss. That miss is the gap."

### Checker

He made something. The checker scores the path, not only the product. Show the work. Find what is wrong or missing, and whether a shorter path hits the same point. Do not rewrite his work. Next time the process itself is faster.

Fits a summary, a proof, code, a math solution.

Prompt shape: "Here is my work for X. What is wrong or missing? Is there a faster way? Do not rewrite it."

### Listener

Same knowledge, more than one highway. Say it. Draw it. Write a short version, because speech runs long. Grade all three against the source. Report exactly what he missed.

Prompt shape: "I will explain this in my own words. Grade it against the source. Tell me what I missed."

### Diagnostician

The same mistake shows up across subjects. The surface topics differ. The root is shared. Feed it the last many sessions (he said 5, 10, 20, or 100) and ask for the recurring leap. Example he gave: the leap from X to Y keeps happening because Z is missing. Learn Z once, instead of patching every surface topic.

Prompt shape: "Here is what I keep getting wrong. What misunderstanding do they share?"

### Sparring partner

The skill is a real-world performance. Interview, public speaking, a sales call, a negotiation. The model plays the other side and pushes back. Difficulty is a slider: less time, harder counterpart. A timer per answer (he used 30 seconds).

A sim is not the real room. It is the first rep, so the real room is not the first time. He uses this for podcasts, interviews, and negotiations, and he tells people to spar a sales call against a template before they take a live one.

Prompt shape: "Play a tough hiring manager. Here are this interviewer's past interviews. Do not go easy. Push back. I answer in 30 seconds."

### Clerk

Messy notes and messy checks go in. A clean outline or flashcards come out. Add nothing he did not write. Hierarchy only. The thinking stays his. The claim he attached: organize, then review on a schedule, and the same time holds about 5 to 10 times more. That multiplier is his claim.

Prompt shape: "Turn my messy notes into a clean outline. Do not add anything I did not write."

## Spaced repetition

He named the Ebbinghaus forgetting curve. Strength starts high and falls off, steep at first.

Each return visit does two things. The slope gets flatter, so the memory lasts longer. The floor gets higher, so it never drops as far. A few minutes on the return beats relearning the topic from zero later.

AI can write the cards, hold the schedule, and turn a miss from a sparring session or a listening session into the next card.

## At the right level

Zone of proximal development, as he used it: just past the current reach. Too easy and too far both waste the session.

- Quiz from easy to hard. Stop when he is guessing. Tell him the level.
- Explain the same concept at more than one level (child, beginner, expert).
- Find the best explanations already written by people, at that level, with links, and say why each one is good. A line that clicks can save weeks. He treats human explanations as still ahead on that kind of taste.

## Simulation and practice apps

Past the interview role-play. Give a realistic task and the deliverable he would actually have to produce (his example: a stack of customer emails). Grade the result and the path.

Agents can build a small practice app: cards, a picture of the idea, run, feedback, make it harder, run again. He called that a hyperbolic time chamber for the knowledge. Cost, in his words, cents on the dollar.

## When AI hinders

Learning sits in the struggle. The difficulty is a hump. An explanation skips the hump. It feels like understanding. A few minutes later nothing is there.

His analogy: GPS users build a poorer map of the place in their heads. A shortcut that always supplies the route weakens the part that would have built the route.

Failure modes he named:

- The model agrees when he is half right.
- It invents numbers and sources.
- The session turns into collecting notes.

Default use ("make it happen, no mistakes") is the bad mode. The tool can be a thought partner. The mode has to be chosen on purpose. Same pattern he draws for any default-bad technology.

## What this file does not do

- It does not merge these roles into the four-skill loop. He said we will combine them.
- It does not set the rule for moving a topic from the new shelf to the known shelf. That rule is a gray area. See `DESIRE.md`.
- It does not treat his percentages, the 5 to 10 times claim, or the GPS line as papers we checked. He did not cite them.
