# Evaluating and validating Claude output — Principles and critical tips

**Pair:** [evaluating-validating-output-references.md](./evaluating-validating-output-references.md)  
**Course:** Associate · Module 3 · Evaluating and Validating Claude's Output  
**Related:** Module 2 prompting stack under `claude/prepcourses/foundations/module2/`  
**Goals this note serves:** AI as operator · bug bounty / appsec · audit work · architect judgment  
**Scope:** authorized study and authorized testing only

---

## One-sentence definition

**Discernment** checks AI output against requirements, sources, and professional standards. **Diligence** sets when human review is mandatory and keeps accountability on you when you ship.

## Why it exists

Time saved is small and visible. Cost of an unverified error is large and arrives later. One fabricated figure in a client deck can cost more trust than the minutes the draft saved. You own every claim you ship, whether you wrote the words or the model did. This module is the largest exam section because **accountability** is the product.

### Cautionary pattern

A consultant asked for market-sizing stats. Four figures were sound. One growth rate was fabricated and still looked clean. The client analyst caught it in the room. Ten minutes of "research" became a week of trust repair. Nothing on the screen looked wrong. That is the failure mode.

## Mechanism (first principles)

1. Fluent text is not evidence. The model uses the same confident voice for a fact and a guess.
2. Evaluation is a **protocol**, not a feeling. Run the same three references every time.
3. **Accuracy** asks if present claims are correct. **Completeness** asks if anything critical is missing. They fail separately.
4. Prevention in the **prompt** (uncertainty allowed, source limits, auditable cites) beats cleanup after ship.
5. **Stakes** set review depth. Casual review on zero-tolerance work is the main process failure.
6. Format is a **reliability** choice. Prose numbers are guesses in answer shape. Code execution returns a checkable computation.

## High-level map

```text
AI draft
  → set stakes (depth of review)
  → check requirements + sources + professional standards
  → scan failure signatures (hallucination, inconsistency, bias, completeness)
  → triage: ready | revise | human override
  → if high stakes: ground prompt, recompute figures, escalate by policy
  → edit for audience + pick format by reliability
  → ship only if you can stand behind every claim
```

| Part | Job |
|------|-----|
| Discernment | How you review (three references + completeness) |
| Failure patterns | What to spot fast (signatures, not "looks wrong") |
| Fact-check and grounding | How to prevent and audit |
| Diligence | When human review is non-negotiable |
| Editing | Clarity, tone, format for the reader |
| Output formats | Inline, artifact, structured, code-executed |

**Fundamental unit:** one **claim** that will leave the chat.  
**Mechanism:** verify the claim against source or recompute it, or do not ship it.

---

## Discernment: three evaluation references

| Reference | Question | Failure example |
|-----------|----------|-----------------|
| **Requirements** | Does output match what you asked, not only the easy parts? | Missed one competitor in a three-competitor ask |
| **Source material** | Do claims match uploaded or supplied docs? | "$40/user" without "minimum 10 seats" from the PDF |
| **Professional standards** | Does this pass in your field? | Number without units, recommendation without reasoning, untraceable cite |

### Stakes calibration

| Stakes | Review depth |
|--------|----------------|
| Zero-tolerance (legal, financial figures, compliance) | Verify every claim. Accuracy beats speed. |
| Low-stakes internal brainstorm | Lighter review is fine. |
| Risk | Same casual review on both domains |

Set stakes **before** you set review depth.

### Three-way triage

| Verdict | When |
|---------|------|
| **Ready to use** | Meets requirements, matches sources, clears standards. Ship. |
| **Needs revision** | Close. One specific gap remains. Note the gap. Iterate. |
| **Needs human override** | Stakes, errors, or uncertainty block ship on draft alone. Escalate. |

Document the reasoning. Do not only feel "looks good."

### Completeness is a separate pass

Accurate text can still omit the one factor that changes the decision. Missing items are harder to see than wrong items. Nothing on the screen points at silence.

### Three protocol examples

| Output | References result | Verdict |
|--------|-------------------|---------|
| Competitor pricing from uploaded PDFs | Clean form, but one price drops seat minimum from source | **Needs revision** (source-restricted re-prompt) |
| Three options to cut invoice time (internal) | Requirements met, no source file, low stakes | **Ready to use** (do not over-verify) |
| Compliance gap vs regulation not uploaded | Confident gaps from training recall, regulatory stakes | **Needs human override** (expert must own) |

Polish is not the signal. References and stakes are the signal.

---

## Hallucinations, inconsistencies, and bias

**Plausible is not verified.**

### Hallucination signatures

| Pattern | Signature |
|---------|-----------|
| Plausible-but-unsupported | Fits the topic. No basis in source or fact. Looks fine. |
| Fabricated specifics | Invented stats, dates, names, quotes, citations. Precision fakes authority. |
| Confident tone masks uncertainty | Guess and grounded fact share the same assured voice. |

**Tell for uncited precision:** real figures this specific usually ship with a source. An uncited "63 percent" is often a number-shaped guess.

### Inconsistency and bias

| Pattern | What to do |
|---------|------------|
| Internal contradiction (long docs) | Hold whole document in view. Run a consistency pass, not only paragraph skim. |
| Confirmation bias in framing | If the prompt leans one way, watch for over-agreement on open questions. |

### Completeness failure pattern

Compare many files. Output lists differences and feels thorough. It missed differences in the **most important** file. Completeness fails where attention is lowest. A confident summary of easy files masks silence on the hard one.

### Capability hallucination

Claims like "I emailed your team" or "I saved the file" without a tool that can do that are unverified. In the product, Claude works with conversation, connected tools, and uploads. It does not perform external actions without a granted tool. Confirm external actions in the real system.

---

## Fact-checking and grounding

**Strongest verification lives in the prompt, before the draft exists.**

### Prompt for verifiability

| Habit | Effect |
|-------|--------|
| Permit "I do not know" | Cuts invented fill under pressure to answer |
| Restrict to provided sources | Bounded retrieval. Flag what sources do not cover. |
| Require auditable citations | Source + location you can open. Untraceable cite is not a cite. |

### Grounding techniques

| Technique | Use |
|-----------|-----|
| Quote first, then analyze | Extract supporting quotes before conclusions |
| Best-of-N comparison | Re-run. Agreement raises confidence. Divergence marks soft spots. |
| Validate against authority | High-stakes claims need a trusted external reference, not only a second model pass |
| In-product aids | e.g. cell-level citations in spreadsheet tools when available |

### Paste-ready prompt fragments (course skill)

**Permission to not know**

```text
If the answer is not supported by the documents I provided, say so explicitly
rather than estimating. It is acceptable to answer "the provided materials
do not cover this."
```

**Source restriction**

```text
Answer using only the attached contract. Do not use general knowledge.
For anything the contract does not address, list it under
"Not covered by this document."
```

**Auditable citation**

```text
For every claim, cite the section and clause number it comes from,
in parentheses, so I can verify it against the source.
```

**Quote-grounding**

```text
Before you analyze, extract the exact sentences from the document that
bear on my question. Then base your analysis only on those quotes.
```

### Verification checklist (before you rely on output)

1. Did I allow uncertainty?
2. Did I restrict to sources when appropriate?
3. Did I require citations I can audit?
4. Did I check high-stakes claims against something authoritative?

---

## Diligence: when human review is non-negotiable

Some outputs must never leave as a solo model draft, no matter how good they look. Set thresholds **in advance**. Policy beats panic.

### Four risk thresholds

| Threshold | Question |
|-----------|----------|
| **Stakes** | Cost if wrong? |
| **Reversibility** | Can you undo? Sent client pack vs private draft |
| **Audience** | External, executive, regulatory vs internal working |
| **Regulatory exposure** | Rule, contract, or law in play? AI does not remove obligations |

### Do-not-ship-without-review list (decide ahead)

- Final client deliverables  
- Audit-critical or financially material calculations  
- Regulated, confidential, or highly sensitive data  
- Public or legal communications with lasting consequence  

### Iteration versus escalation

Productive iteration improves each round. When rounds stop improving, stop prompting. Bring a human expert. More prompts do not manufacture required judgment.

### You own the output

Accountability does not transfer to the tool. Shipped work with Claude is your work. Standards match unaided work.

### Escalation scenarios

| Case | Thresholds | Action |
|------|------------|--------|
| Fast "yes" — internal agenda | Low stakes, reversible, internal | Ship. No escalation. |
| Deceptive "looks fine" — board financial summary | High stakes, executive, partly irreversible | Human review. Recompute figures with code. |
| Slow creep — five proposal rounds, flat improvement | External high stakes + diminishing returns | Stop. Colleague fresh read. |

---

## Editing and adapting for audience

Claude drafts. You deliver. Accurate is not finished.

### Three edit passes

| Pass | Job |
|------|-----|
| **Clarity** | Cut hedging. Tighten. Remove dead weight. Prefer precision over thorough fluff. |
| **Tone** | Match peer, client, or regulator register. |
| **Formatting** | Scannable for exec. Detail for team. Clean for external. |

### Audience calibration

Same facts, different selection and depth:

| Audience | Shape |
|----------|-------|
| Executive | Decision and impact first |
| Working team | Method, detail, next action and owner |
| External | Disclosure control and framing |

### Compare before you lock a base

When quality matters, generate more than one draft (runs or models). Pick the strongest base to edit. Comparison is cheaper than rescuing a weak first draft.

### Same 18 percent, two audiences (pattern)

- **Exec:** "Q3 processing time rose 18 percent, driven by volume plus onboarding three new hires. Recommend standardized onboarding docs."  
- **Team:** Keep drivers, add action, owner, and timeline.  

Neither is the raw long hedge paragraph.

---

## Choosing output formats

Format is a **reliability** decision.

| Format | Use |
|--------|-----|
| **Inline** | Conversational answer you act on inside chat |
| **Artifacts** | Standalone document or code you refine and reuse |
| **Structured** | Tables and schemas for tools or readers |
| **Code execution** | Numbers that must be right — compute, do not invent |

### Prose vs code-executed numbers

| Path | Result |
|------|--------|
| Prose total | Fluent. Fast. Often unverifiable. Wrong total poisons every slide. |
| Code on the file | Computed sum, ranked accounts, chart. Traceable to rows. |

Determinism attaches to the **executed** calculation. The model writes the code, so the logic can still contain a bug. You can read, verify, and re-run. That is the trust path for reported figures.

Low-stakes gut-check can use prose. Reportable decisions need code execution when numbers matter.

### Curate inputs

| Technique | Why |
|-----------|-----|
| De-duplicate sources | Avoid three near-copies that force false reconcile |
| Label each input role | "Approved policy" vs "draft responses" |
| Prune noise | Noise in → noise out |

Clean, labeled, minimal inputs beat a large undifferentiated pile.

---

## Operator triage card (exercise pattern)

For each AI output before ship:

1. Stakes? (low / medium / zero-tolerance)  
2. Requirements complete?  
3. Sources match?  
4. Professional standards?  
5. Completeness pass (what is missing)?  
6. Failure signatures (fabricated specific, contradiction, over-agreement, capability claim)?  
7. Verdict: ready / revise / human override  
8. If numbers material: code path used?  
9. Audience edit done?  

---

## Critical points everyone misses

1. **Accountability stays with you.** Exam weight matches that fact.  
2. **Completeness fails silently.** Scan for silence, not only wrong text.  
3. **Uncited precision is a tell.**  
4. **Long docs need a consistency pass.**  
5. **Set do-not-ship list before the moment.**  
6. **Diminishing returns mean escalate, not re-prompt.**  
7. **Format by reliability, not by prettiness.**  

## Gotchas

| If you see… | Then… |
|-------------|--------|
| Fluent generic market stats | Demand source or mark unverified. Do not paste into client decks. |
| Compliance analysis without uploaded regulation | Human override. Training recall can be stale. |
| "I emailed / saved / filed that" | Confirm in the real system or treat as false. |
| Board numbers from prose | Recompute with code. Human review. |
| Five flat iteration rounds | Stop. Fresh human read. |
| Thorough-looking multi-file compare | Re-check the hardest or most important file. |

## Critical tips for operator goals

| Goal | Critical tip |
|------|----------------|
| Bug bounty / appsec | Require source-restricted notes on scope docs. Fabricated CVE or "fixed in version X" without advisory is a ship block. Completeness: did it miss the auth surface you care about? |
| Cloud / Azure-style audit | Material findings need evidence path (portal, CLI, log). Regulatory and client reports = human override list. Recompute counts and percentages with code when possible. |
| AI as operator | Pre-send grounding habits (I do not know, sources only, cites). Post-receive: three references + triage. Never skip stakes calibration. |
| Architect judgment | Trade-off recommendations need reasoning and alternatives. Confirmation bias: if you asked for one design, force a counter-option pass. |

## IF / THEN

| IF | THEN |
|----|------|
| Deliverable is external or regulated | Human review before ship |
| Claim is a specific number or date | Source or recompute. Else cut or flag. |
| Source was not provided for a domain rule | Do not treat training recall as current law |
| Output is internal brainstorm only | Lighter review. Do not spend audit budget. |
| Rounds no longer improve | Escalate. Stop prompting. |
| Numbers feed a decision | Code execution path |

## Do this (minimal practice)

1. Take one AI draft you almost shipped this week.  
2. Run three references + completeness. Write a one-line triage verdict.  
3. Add the four grounding fragments to your next high-stakes prompt.  
4. Write your personal do-not-ship-without-review list (five lines).  
5. For one spreadsheet task, force code execution instead of prose totals.  

## Out of scope here

- Official doc tables → **references** pair  
- Module 2 component stack (prompt construction) → module2 principles  
- Full product UI tour → current Anthropic help (re-fetch)  

---

## Module takeaways (operator card)

1. You own every shipped claim.  
2. Evaluate against requirements, sources, standards. Calibrate depth to stakes.  
3. Plausible is not verified. Learn failure signatures.  
4. Build verification into the prompt.  
5. Know review thresholds in advance.  
6. Pick format by reliability. Compute numbers when they must be right.  
