# Benchmark: Intigriti July 2026 Medium writeup

**URL:**  
https://medium.com/@zabedullahpoyel/intigriti-july-2026-ctf-write-up-exploiting-json-parser-differential-duplicate-key-confusion-to-29b94d6001e4

**Challenge:** Canonically Yours — JSON parser differential (duplicate-key confusion)

## Section map (as published)

| Order | Section | Job |
|-------|---------|-----|
| 1 | Title + meta lines | Challenge, Platform, Category, Vulnerability, Difficulty, Target |
| 2 | Introduction | Name the bug class and the business effect |
| 3 | Root cause | Two services parse the same JSON differently (first vs last key) |
| 4 | Steps 1–6 | Register → session/CSRF → craft dual package → sign → publish → fetch flag |
| 5 | Why it works | ASCII flow + duplicate `package` JSON |
| 6 | Security impact | BAC, disclosure, logic abuse |
| 7 | Mitigation | Reject dup keys, one canonical parser, authZ after parse, shared object |
| 8 | Conclusion + disclaimer | Educational CTF scope |

## Scorecard: their post → our skill

| Dimension | Medium post | lab-writeup skill |
|-----------|-------------|-------------------|
| Clear small steps | Strong | Required (Step N shape) |
| Exact commands | Strong (curl) | Required + first-principles table per command |
| Why between steps | Partial (one “Why it works”) | **Why we do this** on every step |
| Core concept one-liner | Implicit in intro | Explicit block at top |
| Pre-req knowledge | Missing | Required at start |
| Root cause early | Strong | Required |
| Screenshots | Present | Required for blog; skip for short Obsidian |
| Blue team | Mitigation list | Expanded in Beyond Root + Mitigation |
| Beyond root / path drill | Missing | Required after flag/root |
| Language control | Informal blog | simple-english 1× pragmatic only |

## Portable lesson from that CTF (for wiki concepts)

**Parser differential:** signer and consumer must share one parse tree.  
Duplicate keys are not “interesting JSON” — they are a split-brain authZ risk.

File under `~/llm-wiki/concepts/` when used in a real engagement.
