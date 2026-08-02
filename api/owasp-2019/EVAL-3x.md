# OWASP API 2019 gap suite — 3× evaluation

**Scope:** Mapping + 6 standalone 2019 batches + Inlanefreight 2019-suite evidence + screenshots  
**Bar:** Operator notes (not CTF-only); beyond “2023 already covered it”

---

## Pass 1 — Correct 2019 vs 2023 identification

| # | Claim | Covered? |
|---|-------|----------|
| 1 | EDE + Mass Assignment merged into 2023 BOPLA | YES mapping |
| 2 | Rate limiting reframed as URC | YES |
| 3 | Injection not first-class in 2023 | YES |
| 4 | Logging & monitoring removed from 2023 | YES |
| 5 | Assets management ≈ inventory management | YES |
| 6 | Exactly six gap batches A–F | YES |
| 7 | New-in-2023 called out (business flows, SSRF, unsafe) | YES |

**Pass 1: 7/7 PASS**

---

## Pass 2 — Operator completeness + lab proof

| # | Item | Covered? |
|---|------|----------|
| 1 | Standalone EDE methodology | YES batch 01 |
| 2 | Standalone mass assignment methodology | YES batch 02 |
| 3 | Rate-limit-focused burst tests | YES batch 03 + evidence |
| 4 | Injection beyond “misconfig only” framing | YES batch 04 |
| 5 | v0 / deleted assets live unauth | YES batch 05 + flag |
| 6 | Logging checklist + black-box limits | YES batch 06 |
| 7 | Screenshots swagger v1/v0 | YES png |
| 8 | Cross-links to 2023 engagement folders | YES FINDINGS |
| 9 | Conti FILL IN / DO THIS / edges | YES each batch |
| 10 | Password hashes on v0 called out (inventory + later unsafe) | YES |

**Pass 2: 10/10 PASS**

---

## Pass 3 — Organization & first principles

| Step | Covered? |
|------|----------|
| Clear map file 2019↔2023 | YES |
| Dedicated folder `api/owasp-2019/` | YES |
| Main README indexes both editions | YES (after update) |
| Lab under notes/ not as only runbook | YES |
| Why each gap still matters | YES |
| Not inventing probes without evidence | YES |

**Pass 3: 6/6 PASS**

---

## Overall: **ALL PASS**

**v0 inventory flag (assets):** `HTB{43c2754afea99eba70fb2c8dc443c660}`
