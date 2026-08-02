# API testing — operator board

**These are operator batches (reusable methodology), not CTF writeups.**

| Layer | What | Where |
|-------|------|--------|
| **2023 runbooks** | OWASP API Top 10 **2023** HOW TO | [`execution_batches/`](./execution_batches/) |
| **2019 gap pack** | Standalone risks **merged/removed** in 2023 | [`owasp-2019/`](./owasp-2019/) |
| **Engagement proofs** | Inlanefreight lab evidence (JWTs redacted) | [`notes/`](./notes/) + [`owasp-2019/notes/`](./owasp-2019/notes/) |

**Only authorized targets.**

---

## A) OWASP API Security Top 10 — **2023**

**Vibe path:** read **00** once → run **01–10** with *your* `BASE=` and accounts.  
Lab “WORKED EXAMPLE” blocks are **optional**.

| # | Focus | File |
|---|--------|------|
| **00** | Compare Broken Auth / BOLA / BOPLA / BFLA | [execution_batches/00-authz-authn-compare.md](./execution_batches/00-authz-authn-compare.md) |
| **01** | BOLA / IDOR | [execution_batches/01-bola-idor.md](./execution_batches/01-bola-idor.md) |
| **02** | Broken Authentication | [execution_batches/02-broken-authentication.md](./execution_batches/02-broken-authentication.md) |
| **03** | BOPLA (EDE + Mass Assignment) | [execution_batches/03-bopla-ede-mass-assignment.md](./execution_batches/03-bopla-ede-mass-assignment.md) |
| **04** | Unrestricted Resource Consumption | [execution_batches/04-unrestricted-resource-consumption.md](./execution_batches/04-unrestricted-resource-consumption.md) |
| **05** | BFLA | [execution_batches/05-bfla-broken-function-level-authz.md](./execution_batches/05-bfla-broken-function-level-authz.md) |
| **06** | Sensitive Business Flows | [execution_batches/06-unrestricted-sensitive-business-flows.md](./execution_batches/06-unrestricted-sensitive-business-flows.md) |
| **07** | SSRF | [execution_batches/07-ssrf.md](./execution_batches/07-ssrf.md) |
| **08** | Security Misconfiguration | [execution_batches/08-security-misconfiguration.md](./execution_batches/08-security-misconfiguration.md) |
| **09** | Improper Inventory Management | [execution_batches/09-improper-inventory-management.md](./execution_batches/09-improper-inventory-management.md) |
| **10** | Unsafe Consumption of APIs | [execution_batches/10-unsafe-consumption-of-apis.md](./execution_batches/10-unsafe-consumption-of-apis.md) |

```text
[ ] 00 Compare  [ ] 01 BOLA  [ ] 02 Auth  [ ] 03 BOPLA  [ ] 04 URC
[ ] 05 BFLA     [ ] 06 Flows [ ] 07 SSRF  [ ] 08 Misconfig
[ ] 09 Inventory [ ] 10 Unsafe consumption
```

### 2023 engagement folders

| Folder | Class |
|--------|--------|
| [notes/inlanefreight-bola/](./notes/inlanefreight-bola/) | BOLA |
| [notes/inlanefreight-broken-auth/](./notes/inlanefreight-broken-auth/) | Broken Auth |
| [notes/inlanefreight-bopla/](./notes/inlanefreight-bopla/) | BOPLA |
| [notes/inlanefreight-resource-consumption/](./notes/inlanefreight-resource-consumption/) | URC |
| [notes/inlanefreight-bfla/](./notes/inlanefreight-bfla/) | BFLA |
| [notes/inlanefreight-business-flows/](./notes/inlanefreight-business-flows/) | Business flows |
| [notes/inlanefreight-ssrf/](./notes/inlanefreight-ssrf/) | SSRF |
| [notes/inlanefreight-security-misconfig/](./notes/inlanefreight-security-misconfig/) | Misconfig / SQLi / CORS |

---

## B) OWASP API Security Top 10 — **2019 gaps** (6 standalone)

2023 **merged or dropped** these as first-class Top-10 rows. Full map: [owasp-2019/MAPPING-2019-vs-2023.md](./owasp-2019/MAPPING-2019-vs-2023.md).

| 2019 | Still train? | Batch |
|------|----------------|-------|
| API3 Excessive Data Exposure | Yes (read half of BOPLA) | [owasp-2019/…/01-…](./owasp-2019/execution_batches/01-excessive-data-exposure-2019.md) |
| API6 Mass Assignment | Yes (write half of BOPLA) | [02-…](./owasp-2019/execution_batches/02-mass-assignment-2019.md) |
| API4 Lack of Resources & Rate Limiting | Yes (rate/quota lens) | [03-…](./owasp-2019/execution_batches/03-lack-of-resources-rate-limiting-2019.md) |
| API8 Injection | Yes (not only “misconfig”) | [04-…](./owasp-2019/execution_batches/04-injection-2019.md) |
| API9 Improper Assets Management | Yes (= inventory) | [05-…](./owasp-2019/execution_batches/05-improper-assets-management-2019.md) |
| API10 Insufficient Logging & Monitoring | Yes (**removed** in 2023) | [06-…](./owasp-2019/execution_batches/06-insufficient-logging-monitoring-2019.md) |

Lab suite + screenshots: [owasp-2019/notes/inlanefreight-2019-suite/](./owasp-2019/notes/inlanefreight-2019-suite/)  
3× eval: [owasp-2019/EVAL-3x.md](./owasp-2019/EVAL-3x.md)

---

## Tools

| Tool | Use |
|------|-----|
| curl | Primary |
| pinchtab | Swagger screenshots |
| gori | Repeater |
| ffuf | Auth spray |

## Evals (3×)

| Scope | File |
|-------|------|
| **Full suite (final)** | [FULL-SUITE-EVAL-3x.md](./FULL-SUITE-EVAL-3x.md) |
| 2019 gap pack | [owasp-2019/EVAL-3x.md](./owasp-2019/EVAL-3x.md) |
| Per-class | `notes/inlanefreight-*/…-EVAL-3x.md` |

## Sources

- OWASP API Security Top 10 **2019** and **2023**  
- HTB Academy API Attacks (Inlanefreight practice only; methodology generalized)
