# API testing — operator board

**These are operator batches (reusable methodology), not CTF writeups.**

| Layer | What | Where |
|-------|------|--------|
| **Runbooks** | Generic HOW TO test any API | `execution_batches/` |
| **Engagement proofs** | One lab/target evidence, flags, JWTs redacted | `notes/inlanefreight-*/` |

**Vibe path:** read **00** once → run **01–03** with *your* `BASE=` and accounts.  
Lab “WORKED EXAMPLE” blocks at bottom of batches are **optional** — skip on real engagements.

**Only authorized targets.**

| # | Focus | File |
|---|--------|------|
| **00** | Compare Broken Auth / BOLA / BOPLA / BFLA + evidence comments | [execution_batches/00-authz-authn-compare.md](./execution_batches/00-authz-authn-compare.md) |
| **01** | BOLA / IDOR (operator) | [execution_batches/01-bola-idor.md](./execution_batches/01-bola-idor.md) |
| **02** | Broken Authentication (operator) | [execution_batches/02-broken-authentication.md](./execution_batches/02-broken-authentication.md) |
| **03** | BOPLA — EDE + Mass Assignment (operator) | [execution_batches/03-bopla-ede-mass-assignment.md](./execution_batches/03-bopla-ede-mass-assignment.md) |

```text
[ ] 00 Compare classes
[ ] 01 BOLA
[ ] 02 Broken Auth
[ ] 03 BOPLA
```

## Engagement folders (lab archive — not the runbook)

| Folder | Class practiced |
|--------|-----------------|
| [notes/inlanefreight-bola/](./notes/inlanefreight-bola/) | BOLA |
| [notes/inlanefreight-broken-auth/](./notes/inlanefreight-broken-auth/) | Broken Auth |
| [notes/inlanefreight-bopla/](./notes/inlanefreight-bopla/) | BOPLA |

Each has `FINDINGS.md` + `evidence/` (screenshots, JSON). **Do not** treat FINDINGS as the operator procedure.

## Tools

| Tool | Use |
|------|-----|
| curl | Primary |
| pinchtab | Swagger UI / screenshots |
| gori | Capture + repeater ID/property swaps |
| ffuf | Login/OTP spray |

## Sources

- OWASP API Security Top 10 (API1–3, API5)  
- HTB Academy API Attacks (practice only; methodology generalized in batches)
