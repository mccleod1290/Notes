# URC notes — 3× coverage evaluation

**Scope:** Academy Unrestricted Resource Consumption + batch 04 + lab evidence  
**Style target:** same operator batch shape as AEM / IIS / API 01–03 (WHY + FILL IN + DO THIS + EDGE + IF/THEN + WORKED EXAMPLE appendix)

---

## Pass 1 — Academy teaching points

| # | Point | Covered? |
|---|-------|----------|
| 1 | Definition: no limits on user-initiated resource use (bandwidth/CPU/mem/storage) | YES batch WHY |
| 2 | CWE-400 Uncontrolled Resource Consumption | YES |
| 3 | Financial damage / stakeholder cost framing | YES (disk + SMS) |
| 4 | p8 roles Get + UploadCertificateOfIncorporation | YES FINDINGS |
| 5 | current-user company ID for upload | YES |
| 6 | Large PDF (dd random) accepted | YES evidence |
| 7 | No size validation → disk fill / DoS path | YES |
| 8 | Non-PDF (.exe) accepted | YES |
| 9 | wwwroot + ASP.NET Core static default | YES |
| 10 | Unauth curl download of uploaded file | YES |
| 11 | Malware distribution / enum other files impact | YES |
| 12 | Prevention: size, extension, content, ClamAV, authz, not public wwwroot | YES batch Prevention |
| 13 | Rate-limiting called out as control | YES Parts B/C + Prevention |

**Pass 1: 13/13 PASS**

---

## Pass 2 — Beyond Academy + lab flag + operator depth

| # | Item | Covered? |
|---|------|----------|
| 1 | **Another URC:** SMS OTP flood (paid side-effect) | YES flag |
| 2 | OAS cost language as recon signal | YES |
| 3 | Product photo upload parallel (p11) | YES |
| 4 | Wrong form field → 500 NRE lesson | YES edges + prior lab |
| 5 | Static paths for certs **and** ProductsPhotos | YES |
| 6 | Conti-style FILL IN / DO THIS / EDGE E1–E15 | YES |
| 7 | Classify vs Broken Auth / BOLA / BFLA | YES WHY + IF/THEN |
| 8 | Evidence + redacted JWT; no live secrets in git | YES |
| 9 | Expensive count/export class documented (even if not flag) | YES Part C |
| 10 | Memory amplify via base64 large file noted | YES E10 |

**Pass 2: 10/10 PASS**

---

## Pass 3 — First principles operator path (not CTF walkthrough)

| Step | Covered? |
|------|----------|
| What cost centers exist (disk/$/CPU) | YES |
| How to mine OAS for upload + paid + export | YES |
| How to prove size/type acceptance | YES |
| How to prove public static after upload | YES |
| How to prove third-party $ without rate limit | YES |
| How to write report text (evidence comments) | YES |
| How to prevent (table) | YES |
| Lab only under WORKED EXAMPLE / FINDINGS | YES |

**Pass 3: 8/8 PASS**

---

## Operator vs CTF check

| Anti-pattern | Status |
|--------------|--------|
| Runbook is only lab step-by-step | **Avoided** — generic DO THIS first |
| Flag as only success metric | **Avoided** — impact/cost framed |
| Missing edges / misclass vs authz | **Avoided** — edges + compare |
| Matches AEM/IIS batch rhythm | **YES** — WHY, FILL IN, DO THIS parts, edges, IF/THEN, NEXT, worked example appendix |

---

## Overall: **ALL PASS**

Flag for Q1 Unrestricted Resource Consumption: `HTB{01de742d8cd942ad682aeea9ce3c5428}`
