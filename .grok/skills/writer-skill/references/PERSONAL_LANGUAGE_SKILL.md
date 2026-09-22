# PERSONAL_LANGUAGE_SKILL

How mccleod1290 sounds. Not how he decides what to think about.

The approach (first principles, second-order, invariant, black-box and white-box moves) is `ideas-skill`: `../../ideas-skill/references/APPROACH.md`. Do not copy it into this file.

Corpus map: `../corpus/INDEX.md`.

## Which voice

Two different facts. Do not collapse them.

**Sound.** Prose he wrote:

- Most TryHackMe posts in `old-tryhackme/`. His voice and his idea. He said "most," not all. Do not guess which minority is not his.
- Pilgrimage, `walkthroughs-htb-ctf/694-hackthebox-pilgrimage-walkthrough.md`. His voice and his idea.
- Latest post, `longer-explainers/1630-a-comprehensive-guide-on-using-chatbots-for-learning-and-skill-development.md`. His voice and his idea. He also said 480 and 1470 were his voice.
- Web-pentest series: collab. The idea is his. The **black-box walkthrough** is his voice. The **white-box writeup** is his idea and the model's execution.

**Depth is not voice.** Old rooms are do-this-get-that, and they are still how he sounds. The series is where the mechanism lessons are. Sentence style for those lessons still comes from the list above, not from white-box wording. Which model to use is the ideas skill.

White-box sections are labeled `White box`, `Whitebox`, or `Source code analysis`. Do not copy their sentences, headings, or cadence.

Black-box sections are labeled `Black box`, `Blackbox`, or a lab walkthrough with no source. Those sentences are fair evidence of his sound when they are the lab narration: what he tried, what came back, and why the miss mattered.

A series file can mix in another cadence with no `White box` heading. A definition list, a tool catalog, or a fix cookbook in the same file is not his sound. 965's curl and wget catalog, the type lists in 974 and 978, 998's directive catalog and remediation section, and 1059's opening stack are that cadence. 998's lab-setup aside is his: he tried Docker, then installed bee-box on VMware.

He said this on 2026-09-23. It replaces the rule that the whole series was the voice, and the rule that TryHackMe and Pilgrimage were not.

Reasoning wins over catchphrases. Do not paste lines from the corpus to sound like him.

## Writing style

Peer, one step ahead. `we` does the work. `I` is for what he tried, skipped, or personally took. `you` is the reader about to jump to the wrong next step.

Spoken, not academic. Contractions. Connectors he actually uses: `Now`, `Note that`, `do note that`, `in a nutshell`, `simply put`, `for sure`. Use them when they carry a point, not in every paragraph.

He sums the move in one sentence, then the steps. In the 989 black-box labs he says which character worked, then why fuzzing two parameters at once would hide that.

He puts the "why this?" in the sentence and answers it before the next step. Rooms do this, not only essays. 540 and 694.

He shows the wrong first guess, then the correction, and what the wrong guess cost. That is separate from keeping a payload that did nothing. 491 starts at a Caesar shift, then the 13 in the question. 627 opens the wrong Active Directory snap-in and loses about 15 minutes.

After the steps he names the sign the reader's own run worked, not only what his terminal showed. 540: the abnormal status code. 614: `whoami` shows who you are on the box.

A side path is marked optional, and he says it is not required to finish. 540: the other two emails. 627: DNS already works, so that step can go. 694: reading `/etc/passwd` is confirmation only.

If the terms are heavy, he sends the reader to a diagram or a raw request and says the words can wait.

Paragraphs are a few sentences. A short sentence lands the distinction (`The key difference to note is…`).

He marks his own limit: the account is simplified, here is what it is enough for, here is the doc if you want the rest. He marks opinion with `IMHO`, `personally`, `for me the takeaway`.

Essays open on a situation he was in, and they say what the piece is not. Room logs open on the task. A concept post can open on what the thing is. Series titles are often punchy. Do not add a second threat-headline, and do not treat a title as proof of his sentence style.

Closings keep one or two ideas, the fix, and a link if someone else explained a corner better. Thanks when a person or a lab supplied the path.

## Essay sound

Situation first. Say what the piece will not be. State the point, then say it in simpler words. Answer the objection he expects. Close on one or two takeaways. 480, 1470, and 1630 do this. The thinking tools named inside 1630 belong to the ideas skill, not to this sound.

Analogies are single, then he goes back to the step. Do not stack a second metaphor. Do not take analogies from white-box sections.

## Room-log sound

This is his voice when the piece is a room. 626 says the room will not include the long explanation, then gives the command and the answer. Pilgrimage is the same kind of log, and he said that one is his.

Shape: task heading, one or two lines of gloss, command, what came back, the miss if he had one. On a TryHackMe room he repeats the platform's question and fences the answer. That fence stays on rooms. A room ends by saying the task is done, then one lesson or one link. Not a second pep talk. 540 does this. 989 does it per lab ("with this we solve the lab"). Whether a concept needs first principles instead of this shape is decided by the ideas skill. If it does, these sentences are still the sound.

## Preferences

- Enough detail to see why the step works. Not a taxonomy with no request. Not a one-line shrug.
- Prose, then numbers for a sequence, bullets for a short parallel list, a table only to split two terms.
- Code block for the command or payload. The next lines say what it does.
- Headings are the question the section answers (`What's NTLM`, `Where NTLM is flawed`, `Why this works`).
- Credit the lab, the RFC, or the person.
- Prerequisites include searching when stuck. He drops tool ceremony when the idea is the point.

## Things to avoid

- Learning sentence style from white-box or source-code sections. The idea can stay. The wording cannot.
- Learning sentence style from a tool catalog, a type list, or a fix cookbook inside a series post. Same ban, even with no `White box` heading.
- Copying typos, missing articles, or a wrong definition from a post.
- Pasting lab secrets, flags, or hashes from the corpus into new writing.
- Empty hype on top of a section that already explained the mechanism.
- Forcing 2023 room openers (`this time on tryhackme`) onto a concept note. They are his room voice, not a required costume.
- `delve`, `tapestry`, `robust`, stacked metaphors, fake certainty.
- Hiding the failed try. The black-box labs keep the payload that did nothing.

## Evidence

Not lines to reuse.

- 626 and the other TryHackMe rooms: his sound. Task, command, what came back. Less mechanism than the series. Still his.
- 694 Pilgrimage: his sound and his idea. Same walkthrough shape.
- 989 black box: his sound inside the series. One parameter at a time, the character that worked, the reason the failed try mattered, then the payload.
- 989 white box, from `Source code analysis` on: his choice to show `system` / `exec` / `eval`. The commentary under those headings is not the sound to copy.
- 1470 and 1630: what the piece is not, principle then simpler words, the objection answered, one or two takeaways.

## Uncertain — not rules

- Which TryHackMe posts are the minority he did not claim. He said most.
- Line-by-line authorship of series intros, case-study posts (1037, 1039, 1041), 825, 835, 966–969, 1123, 1329, and the HTB logs other than Pilgrimage. Do not promote or reject them as his sound until he says.
- Punchy series titles. They exist. They are not required on notes.
- Smoother closing paragraphs with a GuidedHacking link, after his own "we are done" close, on 540, 626, and 627. The grammar is cleaner than the body. Do not copy that cadence. Do not treat it as proven to be someone else.
- 1329's body uses mnemonics, a stacked analogy, and a hype close. That conflicts with the essay sound. The post is still unlabeled. Do not use it as sound.

## Learned from corrections

- 2026-09-23: Old TryHackMe posts are do-xyz-get-abc and less first-principles. The series and the newer long posts are where he teaches the mechanism. Full corpus is under `corpus/`.
- 2026-09-23, later: Web pentest was a collab. Idea is his. Black-box walkthrough is his voice. White-box execution is the model's. TryHackMe, most of them, is his voice and his idea. Pilgrimage is his voice and his idea. The latest post (1630) is his voice and his idea.
- 2026-09-23, split: Voice stays in this file. How he approaches a topic moved to `ideas-skill`. First principles is the default there. Invariant and second-order thinking are only when the topic needs them.
- 2026-09-23, corpus pass: Lab narration is the series voice. Catalogs and cookbooks in the same file are not, even with no `White box` heading. Room moves added here: the "why this?" in the sentence, the wrong first guess, the sign the reader's run worked, an optional side path, the fenced room answer, and a close on the task done plus one lesson.
