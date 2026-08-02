# API notes — 3× coverage evaluation (BOLA batch + lab)

**Date:** 2026-08-02  
**Scope:** `api/` operator notes + `notes/inlanefreight-bola/` evidence  
**Target exercised:** `http://154.57.164.65:31687`

---

## Pass 1 — HTB Academy BOLA teaching points

Source: Academy § Broken Object Level Authorization (CWE-639), Supplier JWT, Swagger, yearly-reports BOLA, mass curl, prevention.

| # | Teaching point | Covered? |
|---|----------------|----------|
| 1 | CWE-639 user-controlled key | YES — batch 01 |
| 2 | BOLA = IDOR naming | YES |
| 3 | UUID/GUID vs integer IDs | YES |
| 4 | Object ownership check failure | YES (WHY) |
| 5 | Supplier sign-in endpoint | YES |
| 6 | JWT Bearer Authorize | YES |
| 7 | Swagger UI flow | YES (+ pinchtab) |
| 8 | suppliers/current-user | YES |
| 9 | company Guid baseline | YES + OWN.txt |
| 10 | roles/current-user | YES |
| 11 | Role GetYearlyReportByID | YES |
| 12 | yearly-reports/{ID} integer | YES |
| 13 | id=1 other company | YES + bola-proof-id1.json |
| 14 | id=13 other company | YES + bola-proof-id13.json |
| 15 | Mass for-loop abuse | YES |
| 16 | Revenue / C-level impact | YES |
| 17 | Prevention compare companyID | YES |

**Pass 1 result: 17/17 PASS**

---

## Pass 2 — Beyond Academy (real-world + tooling + lab)

| # | Beyond-notes item | Covered? |
|---|-------------------|----------|
| 1 | No-auth → 401 | YES — edge table + evidence |
| 2 | Bad JWT | YES |
| 3 | Weird IDs 0 / -1 / 99999 | YES |
| 4 | Sequential range (1–18 this spawn) | YES |
| 5 | List endpoint 403 vs item BOLA | YES |
| 6 | Non-GET methods 405 | YES |
| 7 | UUID in integer path | YES |
| 8 | pinchtab Swagger screenshot | YES — swagger-ui.png |
| 9 | gori for capture/repeater | YES — batch tooling |
| 10 | OpenAPI inventory (44 paths) | YES — swagger.json |
| 11 | Evidence folder | YES |
| 12 | 15-item real-world edge table | YES (E1–E15) |
| 13 | OWASP API1:2023 | YES |
| 14 | Conti-style FILL IN / DO THIS / NEXT | YES |
| 15 | Two-account horizontal pattern | YES — edge E8 |

**Pass 2 result: 15/15 PASS**

---

## Pass 3 — First-principles operator completeness

Can a junior follow A→Z without Academy UI?

| Principle step | Covered? |
|----------------|----------|
| What is the bug (first principles) | YES |
| How to auth to API | YES |
| Establish “who am I / my company” | YES |
| Swap object id | YES |
| Mass harvest | YES |
| Prove impact | YES |
| Prevention language for report | YES |
| Swagger / pinchtab / gori usage | YES |
| Evidence location | YES |
| No full live JWT committed | YES (scan clean) |

**Pass 3 result: 10/10 PASS**

---

## Evidence inventory (must be in git)

| File | Role |
|------|------|
| evidence/swagger-ui.png | pinchtab screenshot |
| evidence/swagger.json | OAS |
| evidence/bola-proof-id1.json | cross-tenant report |
| evidence/bola-proof-id13.json | cross-tenant report |
| evidence/yearly-reports-1-20.jsonl | mass dump |
| evidence/edge-cases.txt | edge probe log |
| evidence/current-user-*.json | baseline identity |
| evidence/roles-current-user.json | role grant |
| FINDINGS.md | narrative |
| execution_batches/01-bola-idor.md | operator runbook |

---

## Overall

| Pass | Focus | Outcome |
|------|--------|---------|
| 1 | Academy BOLA section | **PASS 17/17** |
| 2 | Beyond / lab / tools | **PASS 15/15** |
| 3 | First-principles ops | **PASS 10/10** |

**Verdict:** Operator notes + beyond-academy edge cases + lab evidence fully cover the BOLA module content and real-world extension. Ready for operator use via `api/README.md` → batch 01.
