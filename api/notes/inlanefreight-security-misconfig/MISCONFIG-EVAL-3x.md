# Security Misconfiguration notes — 3× evaluation

**Scope:** Academy § Security Misconfiguration + batch 08 + lab evidence  
**Bar:** Operator-first, beyond lab (injection methodology + headers + other surfaces)

---

## Pass 1 — Academy teaching points

| # | Point | Covered? |
|---|-------|----------|
| 1 | APIs share classic misconfigs with web apps | YES |
| 2 | CWE-89 SQLi via user input in SQL | YES |
| 3 | p12 Products count by name substring | YES |
| 4 | Quote breaks query | YES |
| 5 | OR 1=1 full table count | YES |
| 6 | HTTP security headers / CORS risk | YES |
| 7 | Prevention: parameterized queries + secure headers | YES |
| 8 | Q1 another misconfig → supplier table count | YES 151 |
| 9 | Q2 header + value | YES ACAO * |

**Pass 1: 9/9 PASS**

---

## Pass 2 — Beyond lab (trained operator depth)

| # | Item | Covered? |
|---|------|----------|
| 1 | Misconfig umbrella taxonomy (injection/CORS/debug/cloud) | YES |
| 2 | SQLi probe methodology (baseline → break → tautology) | YES |
| 3 | URL-encoding gotcha for path params | YES |
| 4 | Boolean/ORDER BY/second-order edges | YES |
| 5 | CORS Origin probe + credentialed vs * impact | YES |
| 6 | Preflight note | YES |
| 7 | Broader checklist (stack traces, swagger, TRACE) | YES Part C |
| 8 | Evidence comments for reports | YES |
| 9 | Gotchas G1–G7 | YES |
| 10 | Conti-style FILL IN / DO THIS / IF THEN | YES |
| 11 | Lab only under WORKED EXAMPLE | YES |
| 12 | Not “only submit 151” as the whole note | YES |

**Pass 2: 12/12 PASS**

---

## Pass 3 — First principles operator path

| Step | Covered? |
|------|----------|
| What misconfiguration means vs pure authz bugs | YES |
| How to find string→SQL sinks | YES |
| How to prove SQLi with minimal payloads | YES |
| How to audit CORS/headers | YES |
| How to write dual findings (SQLi + CORS) | YES |
| Prevention | YES |

**Pass 3: 6/6 PASS**

---

## Overall: **ALL PASS**

| Q | Answer |
|---|--------|
| Q1 | `151` |
| Q2 | `Access-Control-Allow-Origin: *` |
