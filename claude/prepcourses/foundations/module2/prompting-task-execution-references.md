# Prompting and task execution — Official docs and gold-mine references

**Pair:** [prompting-task-execution-principles.md](./prompting-task-execution-principles.md)  
**Course:** Associate · Module 2 · Prompting and Task Execution  
**Use this file when:** you need vendor truth, prompt-engineering depth, or primary sources — not for first read of the mechanism.

## How to use this pack

1. Learn the five components, decompose, iterate, and task-type dials from the **principles** pair first.
2. Open this file for official Anthropic guidance and mechanism-depth blogs.
3. Prefer the **suggested read order** if time is short.

---

## Official product / standard docs

| Link | What it teaches (mechanism) | Operator so-what |
|------|-----------------------------|------------------|
| [Prompting best practices (Claude Platform)](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) | Current platform guide: clarity, structure, examples, thinking, agentic patterns | Map course "components" to production prompt sections; re-fetch when models change |
| [Prompt engineering overview (docs.anthropic.com)](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview) | Official overview of strategies and when to use them | Baseline vocabulary for role/instruction/examples vs course component names |
| [Claude 4 prompting best practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices) | Explicit instruction needs on newer models ("above and beyond" is not free) | Tighten task + constraints; do not assume old chatty behavior |
| [Long context tips](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/long-context-tips) | Placement and use of large documents in context | Put source material where the model sees it; ties to "context component" |
| [Build with Claude (Anthropic Academy)](https://www.anthropic.com/learn/build-with-claude) | Learning hub into API and practice material | Path from Associate course habits into platform docs |

## Gold-mine first-principles sources

| Link | Why gold | Extra tip from that source |
|------|----------|----------------------------|
| [Effective context engineering for AI agents (Anthropic Engineering)](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) | Separates **prompt engineering** (instruction craft) from **context engineering** (what tokens sit in the window) | Course "context component" is the human face of context engineering; system prompts need clear altitude and sections |
| [Equipping agents for the real world with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) | Skills as reusable procedure packs with progressive disclosure | When a prompt repeats weekly, promote it to a Skill (Module 1 capability layer), not a longer chat paste |
| [PortSwigger Research](https://portswigger.net/research) | First-principles security writeups with repro | For appsec prompts: demand method + evidence format the same way research papers demand method |
| [Simon Willison — LLM / agents posts](https://simonwillison.net/) | Clear mechanism writing on tools, evals, and failure modes | Use "show your intermediate artifact" the same way this course uses decomposition steps |

## Cross-stack / cross-vendor map

| Principle here (Claude course) | Same idea elsewhere |
|--------------------------------|---------------------|
| Role + task + constraints + format | System/developer message + user message patterns (OpenAI, Gemini, Grok) |
| Context gaps | RAG / project knowledge / memory / @-files — still only what you attach |
| Decomposition | Multi-step agent plans, scratchpads, "plan then execute" |
| Parallel independent legs | Fan-out subagents / separate chats, then merge |
| Iterate one component | Ablation: change one variable when debugging a model call |
| Analysis vs brainstorm latitude | Temperature/sampling is not a substitute for clear constraints |

## Suggested read order

1. Principles pair (this module) — component stack + decompose + iterate  
2. [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) — official production habits  
3. [Effective context engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — why context gaps dominate  
4. Model-specific best-practices page for the model you actually use (re-fetch; labels move)  

## Gaps

| Missing source | Why it matters | Status |
|----------------|----------------|--------|
| Live CPN / Associate module page URL (authenticated course) | Canonical course copy changes | `gap` — use your course UI; do not invent quiz answers from memory |
| Module 7 troubleshooting deep link | Course points iteration forward to Module 7 | `gap` until that module is captured |

---

## Do not put here

- Full first-principles re-teach (that is the principles pair)
- Orphan tips with no source row (if critical → principles pair)
