# Evaluating and validating Claude output — Official docs and gold-mine references

**Pair:** [evaluating-validating-output-principles.md](./evaluating-validating-output-principles.md)  
**Course:** Associate · Module 3 · Evaluating and Validating Claude's Output  
**Use this file when:** you need vendor verification guidance, product features for grounding, or primary sources.

## How to use this pack

1. Learn discernment, failure patterns, diligence thresholds, and format reliability from the **principles** pair first.  
2. Open this file for official Anthropic reduce-hallucination and verification pages.  
3. Re-fetch product pages. Course notes cite behavior as of mid-2026. Labels move.  

---

## Official product / standard docs

| Link | What it teaches (mechanism) | Operator so-what |
|------|-----------------------------|------------------|
| [Reduce hallucinations (Claude Platform)](https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations) | Allow uncertainty, ground in quotes, verify with citations | Maps 1:1 to course prompt habits. Paste techniques into high-stakes prompts. |
| [Reduce hallucinations (docs.anthropic.com mirror path)](https://docs.anthropic.com/en/docs/test-and-evaluate/strengthen-guardrails/reduce-hallucinations) | Same guardrail guidance on docs host | Bookmark both if one host renames paths. |
| [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) | Clarity, structure, examples, verification patterns | Pair with Module 2 components when building grounded prompts. |
| [Claude Help Center (support.claude.com)](https://support.claude.com) | Product help including code execution and Excel-related citation features (re-fetch names) | Confirm which plan has code execution and spreadsheet cite behavior before you depend on it. |
| [Build with Claude / Academy hub](https://www.anthropic.com/learn/build-with-claude) | Entry to learning and platform practice | Course-adjacent path into current docs. |

**Course-named sources (verify live):**

- AI Fluency Framework: **Discernment** and **Diligence** competencies (behavioral indicators).  
- Claude product: code execution and cell-level citations where offered.  

## Gold-mine first-principles sources

| Link | Why gold | Extra tip from that source |
|------|----------|----------------------------|
| [Effective context engineering for AI agents (Anthropic Engineering)](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) | Context vs prompt engineering: what sits in the window drives errors | Completeness and source-restriction fail when noise or missing files dominate context. |
| [Equipping agents for the real world with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) | Procedure packs reduce variance | Encode your do-not-ship checklist and verification prompts as a Skill so review does not depend on memory. |
| [PortSwigger Research](https://portswigger.net/research) | Evidence-first security writeups | Same bar as course: claim needs method and evidence, not fluent narrative. |
| [Simon Willison on LLMs](https://simonwillison.net/) | Clear writing on evals, tools, and failure modes | Treat "capability hallucination" like any other false tool success: verify outside the chat. |

## Cross-stack / cross-vendor map

| Principle here | Same idea elsewhere |
|----------------|---------------------|
| Three references (requirements, source, standards) | Acceptance criteria + evidence + field convention in any eng/review process |
| Permit uncertainty | "Refuse when unknown" system rules across vendors |
| Source restriction | RAG with "answer only from retrieved chunks" |
| Auditable citations | Quote + pointer (page, clause, cell) |
| Code execution for numbers | Tool-using agents, notebooks, spreadsheet formulas |
| Human override thresholds | Change control / dual control in ops and security |
| Capability hallucination | Fake tool success in any agent UI |

## Suggested read order

1. Principles pair (this module)  
2. [Reduce hallucinations](https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations)  
3. [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)  
4. Current Help Center pages for code execution / spreadsheet citations  
5. Context engineering essay when outputs keep missing the hard file  

## Gaps

| Missing source | Why it matters | Status |
|----------------|----------------|--------|
| Authenticated CPN Module 3 exercise "Triage the Output Set" full items | Exact self-assessment items | `gap` — use operator triage card in principles until captured |
| Stable public URL for AI Fluency Framework PDF | Exam language for Discernment / Diligence | `gap` — re-fetch from Anthropic learn / fluency pages at study time |
| Live plan matrix for code execution | Feature availability by plan | `gap` — check support.claude.com before relying |

---

## Do not put here

- Full re-teach of discernment protocol (principles pair)  
- Orphan tips with no source row  
