# PERSONAL_LANGUAGE_SKILL

How mccleod1290 sounds. Not how he decides what to think about.

The approach (first principles, second-order, invariant, black-box and white-box moves) is `ideas-skill`: `../../ideas-skill/references/APPROACH.md`. Do not copy it into this file.

Corpus map: `../corpus/INDEX.md`.

## Which voice

Two different facts. Do not collapse them.

**Sound.** Prose he wrote:

- Old TryHackMe writeups in `old-tryhackme/`. Fully his. No AI. Wording and idea are his.
- HTB writeups in `walkthroughs-htb-ctf/`: 694, 949, 951, 957, 958, 959, 962. Fully his. No AI. Wording and idea are his. 949's first paragraph is smoother than the steps, and in that post he says he used ChatGPT to read one script. The steps after that are still his. 658 is not one of these.
- Initial blogs 480, 596, and 825. Fully his. No AI. Wording and idea are his. Install commands pasted from a tool page are not his sentences. 835 is not in this set: the ideas are his and premature, but the opener, the Kerberos overview, and the close are a different cadence. 1470 and 1630 are later posts he also wrote. 1329 is not in this set.
- On those writeups and initial blogs he tried first principles. The ideas were premature, so the explanation is not always the best one. The wording is still his. The attempt is still his. Do not treat a rough early explanation as proof that first principles was missing, and do not treat it as the best statement of the model.
- Web-pentest series: a human and AI collab. **Ideas and structure are his** in both halves. **Black-box wording is mostly his**, with some AI lines here and there. **White-box wording is fully the model's.** Where that wording was too complex, he paraphrased it. A paraphrase is not his voice.

**Depth is not voice.** Old rooms are still often a task log, and they are still how he sounds. Inside that log he tried first principles. The ideas were premature. Sentence style for a mechanism lesson still comes from the list above, not from white-box wording. Which model to use is the ideas skill. The clean names of the models are in 1630, not in the early posts.

White-box sections are labeled `White box`, `Whitebox`, or `Source code analysis`. Full reliance on the model. Do not copy those sentences, that cadence, or a paraphrase of a sentence that was too complex. The decision that the section exists, and where it sits, is his structure. That decision is the ideas skill, not a voice sample.

Black-box sections are labeled `Black box`, `Blackbox`, or a lab walkthrough with no source. The lab narration is mostly his sound: what he tried, what came back, and why the miss mattered. Some lines in those sections are AI. One smooth sentence is not enough to call a habit his. A pattern still needs two posts, and it still has to be the lab narration, not a catalog.

A series file can mix in another cadence with no `White box` heading. A definition list, a tool catalog, or a fix cookbook in the same file is not his sound. 965's curl and wget catalog, the type lists in 974 and 978, 998's directive catalog and remediation section, and 1059's opening stack are that cadence. 998's lab-setup aside is his: he tried Docker, then installed bee-box on VMware.

He said the collab split on 2026-09-23, and he tightened it the same day. Black box is mostly human, not purely human. White box is fully the model, including a paraphrase of wording that was too complex. Ideas and structure stay his. This replaces the rule that the whole series was the voice, the rule that every black-box sentence is his, and the rule that TryHackMe and Pilgrimage were not.

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

- Learning sentence style from white-box or source-code sections. The idea and the structure can stay. The wording cannot, including a paraphrase of wording that was too complex.
- Learning sentence style from a tool catalog, a type list, or a fix cookbook inside a series post. Same ban, even with no `White box` heading.
- Copying typos, missing articles, or a wrong definition from a post.
- Pasting lab secrets, flags, or hashes from the corpus into new writing.
- Empty hype on top of a section that already explained the mechanism.
- Forcing 2023 room openers (`this time on tryhackme`) onto a concept note. They are his room voice, not a required costume.
- `delve`, `tapestry`, `robust`, stacked metaphors, fake certainty.
- Hiding the failed try. The black-box labs keep the payload that did nothing.

## Evidence

Not lines to reuse.

- 626 and the other old TryHackMe rooms: his sound and his idea. No AI. Task, command, what came back. He tried first principles there. The try is early.
- 694 and the other HTB writeups listed above: his sound and his idea. No AI. Same walkthrough shape. Same early try.
- 989 black box: mostly his sound inside the series. One parameter at a time, the character that worked, the reason the failed try mattered, then the payload. A single smooth line in that lab can still be one of the AI lines.
- 989 white box, from `Source code analysis` on: his structure and his choice to show `system` / `exec` / `eval`. The commentary under those headings is the model's, even where a complex sentence was only paraphrased.
- 1470 and 1630: what the piece is not, principle then simpler words, the objection answered, one or two takeaways.

## Uncertain — not rules

- 658, the VIT CTF post. He claimed the HTB writeups, not this file.
- 1329. It is later than the initial blogs, and he has not claimed it. Do not use it as his sound.
- Line-by-line authorship of series intros and case-study posts (1037, 1039, 1041, 966–969, 1123). Those sit in the collab series. Do not promote a catalog inside them into his sound.
- Punchy series titles. They exist. They are not required on notes.
- Smoother closing paragraphs with a GuidedHacking link, after his own "we are done" close, on 540, 626, and 627. The grammar is cleaner than the body. Do not copy that cadence. Do not treat it as proven to be someone else.
- 1329's body uses mnemonics, a stacked analogy, and a hype close. That conflicts with the essay sound. The post is still unlabeled. Do not use it as sound.

## Learned from corrections

- 2026-09-23, split: Voice stays in this file. How he approaches a topic moved to `ideas-skill`. First principles is the default there. Invariant and second-order thinking are only when the topic needs them.
- 2026-09-23, corpus pass: Lab narration is the series voice. Catalogs and cookbooks in the same file are not, even with no `White box` heading. Room moves added here: the "why this?" in the sentence, the wrong first guess, the sign the reader's run worked, an optional side path, the fenced room answer, and a close on the task done plus one lesson.
- 2026-09-23, collab checked: Web pentest is a human and AI collab. In 978 the CTF labs are his narration, and the type list, the X-Forwarded paragraph, and the second-order section are the other cadence, with no White box heading. 989 from `Source code analysis` on stays in that other cadence, and the sentences stay complex. A paraphrase did not turn that block into his room voice. Ideas and structure stay his.
- 2026-09-23, early posts, checked: Old TryHackMe writeups, the HTB writeups, and initial blogs 480, 596, and 825 match one writer. His typos, his misses, his task log. No second cadence. He tried first principles. The ideas were premature. 835 does not pass that check. 949's opener is smoother than its steps. This replaces the rule that those rooms are only do-this-get-that, and the rule that HTB posts other than Pilgrimage were unconfirmed.
