# SSRF notes — 3× coverage evaluation

**Scope:** Academy SSRF + batch 07 + lab evidence  
**Style:** AEM / IIS / API 01–06 operator batches

---

## Pass 1 — Academy teaching points

| # | Point | Covered? |
|---|-------|----------|
| 1 | SSRF definition / user-controlled fetch | YES |
| 2 | CWE-918 | YES |
| 3 | p10 roles Update + UploadCertificate | YES |
| 4 | Upload returns fileURI (file scheme) | YES (context) |
| 5 | PATCH sets CertificateOfIncorporationPDFFileURI | YES |
| 6 | Mass-assign URI should be server-only | YES |
| 7 | GET certificate base64 of file:// target | YES |
| 8 | /etc/passwd demo | YES |
| 9 | Prevention: allowlist, chroot readback, no local file URI | YES |

**Pass 1: 9/9 PASS**

---

## Pass 2 — Beyond Academy + flag + operator depth

| # | Item | Covered? |
|---|------|----------|
| 1 | p11 second sink PNGPhotoFileURI | YES |
| 2 | Flag `/etc/flag.conf` | YES |
| 3 | Correct DTO wrappers (SupplierID required) | YES |
| 4 | Blind/cloud/bypass edges | YES E1–E12 |
| 5 | Gotchas G1–G7 | YES |
| 6 | Two-phase write/read pattern | YES |
| 7 | Conti FILL IN / DO THIS | YES |
| 8 | Evidence + redacted JWT | YES |
| 9 | Mass assign + SSRF dual class | YES |
| 10 | Not CTF-only walkthrough as whole batch | YES |

**Pass 2: 10/10 PASS**

---

## Pass 3 — First principles operator path

| Step | Covered? |
|------|----------|
| What SSRF is (server fetch) | YES |
| How to find URI sinks in OAS | YES |
| How to own resource + set URI | YES |
| How to trigger readback / OOB | YES |
| How to prove impact | YES |
| Prevention | YES |
| Lab under WORKED EXAMPLE | YES |

**Pass 3: 7/7 PASS**

---

## Overall: **ALL PASS**

Flag: `HTB{3c94232c4f0b0a544ae4024833eef0b3}`
