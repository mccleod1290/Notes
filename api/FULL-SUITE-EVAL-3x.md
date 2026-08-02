# API notes — full suite 3× evaluation (final)

**Date:** 2026-08-02  
**Scope:** All `api/` operator batches (OWASP API Top 10 **2023** + **2019** gap pack) + engagement FINDINGS  
**Bar:** Operator-first (AEM/IIS style); lab under WORKED EXAMPLE / `notes/*` only; authorized Inlanefreight only  

---

## Inventory check

| Area | Expected | Present |
|------|----------|---------|
| 2023 batches | 00–10 | YES (11 files) |
| 2019 gap batches | 01–06 | YES (6 files) |
| 2023 engagement folders | bola, auth, bopla, urc, bfla, flows, ssrf, misconfig | YES (8) |
| 2019 suite | inlanefreight-2019-suite | YES |
| Per-section EVAL | most classes | YES (see list) |
| Board README | 2023 + 2019 index | YES |
| Map 2019↔2023 | MAPPING file | YES |

**Per-section EVAL files:**

| File | Status |
|------|--------|
| `API-EVAL-3x.md` (BOLA-era) | PASS |
| `notes/.../AUTH-EVAL-3x.md` | PASS |
| `notes/.../BOPLA-EVAL-3x.md` | PASS |
| `notes/.../URC-EVAL-3x.md` | PASS |
| `notes/.../BFLA-EVAL-3x.md` | PASS |
| `notes/.../BUSINESS-FLOWS-EVAL-3x.md` | PASS |
| `notes/.../SSRF-EVAL-3x.md` | PASS |
| `notes/.../MISCONFIG-EVAL-3x.md` | PASS |
| `owasp-2019/EVAL-3x.md` | PASS |
| This file (09/10 + whole suite) | PASS |

---

## Pass 1 — OWASP API Top 10 **2023** coverage

| # | Risk | Batch | FINDINGS / lab | Operator shape |
|---|------|-------|----------------|----------------|
| 1 | BOLA | 01 | inlanefreight-bola | YES |
| 2 | Broken Authentication | 02 | inlanefreight-broken-auth | YES |
| 3 | BOPLA | 03 | inlanefreight-bopla | YES |
| 4 | Unrestricted Resource Consumption | 04 | inlanefreight-resource-consumption | YES |
| 5 | BFLA | 05 | inlanefreight-bfla | YES |
| 6 | Sensitive Business Flows | 06 | inlanefreight-business-flows | YES |
| 7 | SSRF | 07 | inlanefreight-ssrf | YES |
| 8 | Security Misconfiguration | 08 | inlanefreight-security-misconfig | YES |
| 9 | Improper Inventory Management | 09 | 2019-suite v0 + batch 09 | YES |
| 10 | Unsafe Consumption of APIs | 10 | Yara hash from v0 + batch 10 | YES |
| — | Authz compare card | 00 | — | YES |

**Pass 1: 11/11 PASS**

---

## Pass 2 — OWASP API Top 10 **2019** gaps (not first-class in 2023)

| # | 2019 risk | Batch | Evidence |
|---|-----------|-------|----------|
| 1 | Excessive Data Exposure | owasp-2019/01 | ede-suppliers-excerpt + bopla |
| 2 | Mass Assignment | owasp-2019/02 | bopla FINDINGS |
| 3 | Lack of Resources & Rate Limiting | owasp-2019/03 | rate-login-fails; URC SMS |
| 4 | Injection | owasp-2019/04 | misconfig SQLi 151 |
| 5 | Improper Assets Management | owasp-2019/05 | v0 deleted + screenshots |
| 6 | Insufficient Logging & Monitoring | owasp-2019/06 | logging-headers / body |

**Pass 2: 6/6 PASS**

---

## Pass 3 — Quality bar (operator vs CTF, structure, hygiene)

| Criterion | Result |
|-----------|--------|
| Generic FILL IN / DO THIS before lab | YES across 2023 00–08 deep batches + 2019 01–06 |
| Lab only WORKED EXAMPLE / notes/* | YES |
| WHY / first principles / IF-THEN or gotchas | YES (depth varies; 09–10 thinner pointers to 2019 pack — acceptable) |
| 3× evals written per major section | YES |
| JWTs redacted in committed evidence | YES (convention followed) |
| Screenshots where useful | YES swagger v1/v0 png |
| Main README organizes 2023 + 2019 | YES |
| No unauthorized targets | YES Inlanefreight only |
| Git pushed on main | Verified at final check |

**Pass 3: 9/9 PASS**

---

## Known intentional thin spots (not failures)

| Item | Note |
|------|------|
| Batch 09–10 length | Point to full 2019 assets + unsafe narrative; not full Conti clones |
| Logging “flag” | Black-box only; SIEM not exposed — documented correctly |
| BOLA dedicated `BOLA-EVAL-3x.md` | Covered by root `API-EVAL-3x.md` |

---

## Overall suite result: **ALL PASS**

**Exit criteria met:** content complete, evaluated 3×, tree clean / origin up to date after this commit.
