# The 10-Minute Unstuck Process

> For audits (and any technical work) when you freeze, panic, or halt.

What you're facing often isn't an Azure problem or a GCP problem. It's a **panic problem**.

The moment you don't know something, the brain jumps from:

> "I don't know this yet."

to:

> "I need an answer immediately."

That skips the most valuable part of learning: **structured struggle**.

You don't need to struggle for hours. You need a repeatable process that gives your brain permission to think before asking.

---

## Step 0 — Reset (30 seconds)

Before touching the keyboard:

> "God, give me wisdom. I don't have to know everything. Help me ask the next right question."

Take one deep breath.

**Goal is not to solve the whole audit.**  
**Goal is to find the next unknown.**

---

## Step 1 — Name the control

Ask:

> **What exactly is this control asking?**

Not Azure. Not GCP. The control.

Examples: MFA · Logging · Encryption · Least privilege · Backups · Network segmentation

**Write it down:**

```
Control:
```

---

## Step 2 — First principles

Ask only:

1. Why does this control exist?
2. What risk is it preventing?
3. What bad thing happens if this control doesn't exist?

```
Why it exists:
Risk it prevents:
If missing, bad thing:
```

If you can't answer those:

- Watch **one** short video, **or**
- Read **one** docs page  

Not a masterclass. Five to ten minutes. Then **stop**.

---

## Step 3 — Translate into cloud

Ask:

> How does Azure or GCP implement this idea?

Not every service. Only the one related to the control.

Example — control: MFA

- Which service manages identities?
- Where would MFA be configured?
- Who owns this configuration?

```
Cloud:
Service / product:
Where configured:
Who owns it:
```

---

## Step 4 — Evidence thinking

Imagine you're the auditor.

> If someone says this control exists… how would I believe them?

Possible evidence: screenshot · config · policy · export · logs · user list · report

```
Evidence that would prove this control:
1.
2.
3.
```

---

## Step 5 — Sample thinking

> What would I sample?

Examples: 5 users · 5 VMs · IAM roles · storage buckets · firewall rules

```
Sample set:
How I'd pick them:
```

Now you're thinking like an auditor, not only like a student.

---

## Step 6 — Self-check

Before asking anyone, can you answer:

| # | Question | Y/N |
|---|----------|-----|
| 1 | What is the control? | |
| 2 | Why does it exist? | |
| 3 | Which Azure/GCP service is involved? | |
| 4 | What evidence am I expecting? | |

If **yes** on those — only then ask someone.

---

## When asking others

**Not this:**

> How do I do this?

**This:**

> The control is about MFA. I understand it's preventing unauthorized access. I found Entra ID / Azure AD handles this. I'm unsure what evidence is normally collected. Am I looking at the right place?

You've shown your thinking. People usually respond better.

---

## If someone trolls you

Mentally:

> Their reaction is not part of the audit.

Return to the notebook.

You're there to become competent, not to win everyone's approval.

Some people teach. Some people gatekeep.  
Your growth doesn't depend on either group.

---

## Muscle memory — six questions every time you're stuck

1. What is the control?  
2. Why does it exist?  
3. Which cloud service implements it?  
4. What evidence proves it?  
5. What sample would I collect?  
6. What is the **one** question I still cannot answer?  

Only after those six do you ask another person.

---

## Working log (copy when stuck)

```markdown
### Unstuck — YYYY-MM-DD — [audit / control name]

**Step 0:** breath taken · reset said · yes/no

**1. Control:**

**2. First principles**
- Why:
- Risk:
- If missing:

**Learn bite (≤10 min):** [link or none]

**3. Cloud translate**
- Platform:
- Service:
- Where / who:

**4. Evidence I'd accept:**
-

**5. Sample:**
-

**6. One question I still cannot answer:**
>

**Asked someone?** no / yes — who — what I said:

**Next action (single):**
```

---

## Carry sentences

> **I don't need the whole solution. I only need the next question.**

When anxiety creeps in:

> **Lord, You are with me. Help me be faithful in the next step, not anxious about the whole audit.**

---

Over time this builds the habit you want: comfortable with not knowing, while steadily turning the unknown into the known.
