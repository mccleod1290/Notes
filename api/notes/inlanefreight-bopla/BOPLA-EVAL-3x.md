# BOPLA notes — 3× coverage evaluation

**Scope:** Academy BOPLA (EDE + Mass Assignment) + batch 03 + lab evidence

---

## Pass 1 — Academy teaching points

| # | Point | Covered? |
|---|-------|----------|
| 1 | BOPLA = EDE + Mass Assignment | YES |
| 2 | EDE definition | YES |
| 3 | Mass Assignment definition | YES |
| 4 | CWE-213 incompatible policies | YES |
| 5 | p4 customer Suppliers_GetAll | YES |
| 6 | `/suppliers` leaks email/phone | YES |
| 7 | Business impact marketplace bypass | YES |
| 8 | EDE prevention via response DTO | YES |
| 9 | CWE-915 mass assignment | YES |
| 10 | p6 SupplierCompanies_Update/Get | YES |
| 11 | isExemptedFromMarketplaceFee 0→1 | YES |
| 12 | PATCH body with exemption field | YES |
| 13 | Revenue impact stakeholders | YES |
| 14 | Mass assign prevention request DTO | YES |

**Pass 1: 14/14 PASS**

---

## Pass 2 — Beyond Academy + lab flags + tooling

| # | Item | Covered? |
|---|------|----------|
| 1 | p5 multi-GetAll EDE hunt | YES |
| 2 | Flags in supplier-companies + billing-addresses | YES |
| 3 | p7 NetSum mass assignment | YES |
| 4 | Create order + items flow | YES |
| 5 | Edge cases E1–E15 | YES |
| 6 | pinchtab swagger screenshot | YES |
| 7 | Conti FILL IN / DO THIS | YES |
| 8 | Evidence + redacted JWT | YES |
| 9 | Correct UpdatedSupplierCompany schema | YES |
| 10 | gori/Burp property inject note | YES |

**Pass 2: 10/10 PASS**

---

## Pass 3 — First principles operator path

| Step | Covered? |
|------|----------|
| What overshare vs over-bind means | YES |
| How to baseline roles | YES |
| How to diff UI vs JSON fields | YES (edges) |
| How to test EDE on list endpoints | YES |
| How to test mass assign on PATCH/POST | YES |
| How to prove impact (fee/price/PII) | YES |
| How to write prevention | YES |

**Pass 3: 7/7 PASS**

---

## Overall: **ALL PASS**

Flags captured for Q1 (EDE) and Q2 (Mass Assignment) skill assessment.
