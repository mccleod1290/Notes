# API testing — operator board

**These are operator batches (reusable methodology), not CTF writeups.**

| Layer | What | Where |
|-------|------|--------|
| **Runbooks** | Generic HOW TO test any API | `execution_batches/` |
| **Engagement proofs** | One lab/target evidence, flags, JWTs redacted | `notes/inlanefreight-*/` |

**Vibe path:** read **00** once → run **01–07** with *your* `BASE=` and accounts.  
Lab “WORKED EXAMPLE” blocks at bottom of batches are **optional** — skip on real engagements.

**Only authorized targets.**

| # | Focus | File |
|---|--------|------|
| **00** | Compare Broken Auth / BOLA / BOPLA / BFLA + evidence comments | [execution_batches/00-authz-authn-compare.md](./execution_batches/00-authz-authn-compare.md) |
| **01** | BOLA / IDOR (operator) | [execution_batches/01-bola-idor.md](./execution_batches/01-bola-idor.md) |
| **02** | Broken Authentication (operator) | [execution_batches/02-broken-authentication.md](./execution_batches/02-broken-authentication.md) |
| **03** | BOPLA — EDE + Mass Assignment (operator) | [execution_batches/03-bopla-ede-mass-assignment.md](./execution_batches/03-bopla-ede-mass-assignment.md) |
| **04** | Unrestricted Resource Consumption (operator) | [execution_batches/04-unrestricted-resource-consumption.md](./execution_batches/04-unrestricted-resource-consumption.md) |
| **05** | BFLA — Broken Function Level Authorization (operator) | [execution_batches/05-bfla-broken-function-level-authz.md](./execution_batches/05-bfla-broken-function-level-authz.md) |
| **06** | Unrestricted Access to Sensitive Business Flows (operator) | [execution_batches/06-unrestricted-sensitive-business-flows.md](./execution_batches/06-unrestricted-sensitive-business-flows.md) |
| **07** | Server-Side Request Forgery (operator) | [execution_batches/07-ssrf.md](./execution_batches/07-ssrf.md) |

```text
[ ] 00 Compare classes
[ ] 01 BOLA
[ ] 02 Broken Auth
[ ] 03 BOPLA
[ ] 04 Unrestricted Resource Consumption
[ ] 05 BFLA
[ ] 06 Sensitive Business Flows
[ ] 07 SSRF
```

## Engagement folders (lab archive — not the runbook)

| Folder | Class practiced |
|--------|-----------------|
| [notes/inlanefreight-bola/](./notes/inlanefreight-bola/) | BOLA |
| [notes/inlanefreight-broken-auth/](./notes/inlanefreight-broken-auth/) | Broken Auth |
| [notes/inlanefreight-bopla/](./notes/inlanefreight-bopla/) | BOPLA |
| [notes/inlanefreight-resource-consumption/](./notes/inlanefreight-resource-consumption/) | Unrestricted Resource Consumption |
| [notes/inlanefreight-bfla/](./notes/inlanefreight-bfla/) | BFLA |
| [notes/inlanefreight-business-flows/](./notes/inlanefreight-business-flows/) | Sensitive Business Flows |
| [notes/inlanefreight-ssrf/](./notes/inlanefreight-ssrf/) | SSRF |

Each has `FINDINGS.md` + `evidence/` (screenshots, JSON). **Do not** treat FINDINGS as the operator procedure.

## Tools

| Tool | Use |
|------|-----|
| curl | Primary |
| pinchtab | Swagger UI / screenshots |
| gori | Capture + repeater ID/property swaps |
| ffuf | Login/OTP spray |

## Sources

- OWASP API Security Top 10 (API1–7)  
- HTB Academy API Attacks (practice only; methodology generalized in batches)
