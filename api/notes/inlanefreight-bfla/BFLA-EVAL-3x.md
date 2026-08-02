# BFLA notes — 3× coverage evaluation

**Scope:** Academy Broken Function Level Authorization + batch 05 + lab evidence  
**Style target:** AEM / IIS / API 01–04 operator batches (WHY + FILL IN + DO THIS + EDGE + IF/THEN + WORKED EXAMPLE appendix)

---

## Pass 1 — Academy teaching points

| # | Point | Covered? |
|---|-------|----------|
| 1 | BFLA definition: unprivileged user invokes privileged endpoint | YES |
| 2 | BOLA vs BFLA (authorized endpoint vs not) | YES WHY table |
| 3 | CWE-200 sensitive info to unauthorized actor | YES |
| 4 | p9 credentials customer sign-in | YES |
| 5 | roles/current-user → no roles assigned | YES |
| 6 | products/discounts requires ProductDiscounts_GetAll (docs) | YES |
| 7 | Zero-role user still gets all discounts | YES |
| 8 | Missing RBAC check in source | YES |
| 9 | Prevention: enforce role at source before processing | YES Prevention |

**Pass 1: 9/9 PASS**

---

## Pass 2 — Beyond Academy + flag + operator depth

| # | Item | Covered? |
|---|------|----------|
| 1 | Systematic GetAll matrix (not only discounts) | YES |
| 2 | Flag on billing-addresses BFLA | YES |
| 3 | OAS description role vs empty security array pattern | YES |
| 4 | Negative controls (403 when security array set) | YES |
| 5 | Unauth 401 vs low-role 200 table | YES DO THIS §4 |
| 6 | Edges E1–E15 (method, v0, GraphQL, UI hide) | YES |
| 7 | Conti FILL IN / DO THIS / IF THEN | YES |
| 8 | Dual-class note vs BOPLA when same data | YES FINDINGS |
| 9 | Evidence + redacted JWT | YES |
| 10 | Report evidence comment block | YES |

**Pass 2: 10/10 PASS**

---

## Pass 3 — First principles operator path (not CTF walkthrough)

| Step | Covered? |
|------|----------|
| What function-level means | YES |
| How to inventory roles of principal | YES |
| How to build OAS function matrix | YES |
| How to test deny-by-default expectation | YES |
| How to prove BFLA vs BOLA vs EDE | YES IF/THEN |
| How to prevent | YES |
| Lab only under WORKED EXAMPLE / FINDINGS | YES |

**Pass 3: 7/7 PASS**

---

## Operator vs CTF check

| Anti-pattern | Status |
|--------------|--------|
| Runbook is only “hit billing-addresses for flag” | **Avoided** |
| No BOLA/BFLA comparison | **Avoided** |
| No negative control | **Avoided** |
| Matches AEM/IIS batch rhythm | **YES** |

---

## Overall: **ALL PASS**

Flag: `HTB{1e2095c564baf0d2d316080217040dae}`
