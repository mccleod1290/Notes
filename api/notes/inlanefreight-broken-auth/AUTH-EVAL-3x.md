# Broken Authentication — 3× coverage evaluation

**Scope:** Academy “Broken Authentication” + batch 02 + lab evidence  
**Target:** `154.57.164.65:31687`

---

## Pass 1 — Academy teaching points

| # | Academy point | Covered? |
|---|---------------|----------|
| 1 | Broken Authentication definition | YES — batch 02 WHY |
| 2 | CWE-307 excessive auth attempts | YES |
| 3 | Customer sign-in endpoint | YES |
| 4 | JWT after customer login | YES |
| 5 | customers/current-user | YES |
| 6 | roles: Update / Get / GetAll | YES |
| 7 | customers list → emails for spray | YES |
| 8 | BOPLA mention (upcoming) | YES — NEXT + note |
| 9 | PATCH current-user password field | YES |
| 10 | Weak policy “at least 6 characters” | YES + evidence |
| 11 | `123456` accepted | YES |
| 12 | Fail string `Invalid Credentials` | YES |
| 13 | High-value emails list | YES target-emails.txt |
| 14 | ffuf dual/password wordlist xato-10k | YES |
| 15 | Isabella / qwerasdfzxcv | YES |
| 16 | OTP / security-question brute concept | YES (OTP executed) |
| 17 | Prevention: rate-limit, strong policy, MFA | YES |

**Pass 1: 17/17 PASS**

---

## Pass 2 — Beyond Academy + lab + tooling

| # | Beyond item | Covered? |
|---|-------------|----------|
| 1 | OAS password maxLength=6 | YES (notes) |
| 2 | Correct UpdatedCustomer wrapper body | YES |
| 3 | Phone digits-only constraint | YES |
| 4 | email-otps + sms-otps endpoints | YES |
| 5 | 4-digit OTP brute (7526) | YES + ffuf json |
| 6 | Mason ATO → payment options | YES |
| 7 | Flag HTB{…} | YES FINDINGS |
| 8 | pinchtab Swagger screenshot | YES swagger-ui.png |
| 9 | gori documented | YES batch tools |
| 10 | Edge table E1–E15 | YES |
| 11 | Per-email ffuf fallback (dual-w flaky) | YES |
| 12 | JWT redacted in evidence | YES |
| 13 | Conti FILL IN / DO THIS / NEXT | YES |

**Pass 2: 13/13 PASS**

---

## Pass 3 — First-principles operator path

| Step | Covered? |
|------|----------|
| What broken auth means | YES |
| How to get JWT as customer | YES |
| How to baseline identity/roles | YES |
| How to prove weak policy | YES |
| How to spray passwords | YES |
| How to brute OTP reset | YES |
| How to show impact (payments/flag) | YES |
| How to write prevention | YES |
| Evidence location | YES |

**Pass 3: 9/9 PASS**

---

## Overall

| Pass | Outcome |
|------|---------|
| 1 Academy | **PASS** |
| 2 Beyond + lab | **PASS** |
| 3 First principles | **PASS** |

**Verdict:** Batch 02 + evidence fully cover Academy Broken Authentication and the skill-assessment path (Mason payment options).
