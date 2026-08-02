# OWASP API Security Top 10 — 2019 vs 2023

Sources: [OWASP API Security 2023](https://owasp.org/API-Security/editions/2023/en/0x11-t10/), [2019 edition](https://owasp.org/API-Security/editions/2019/en/).

## Side-by-side

| # | **2019** | **2023** | Change |
|---|----------|----------|--------|
| 1 | Broken Object Level Authorization | Broken Object Level Authorization | Same |
| 2 | Broken User Authentication | Broken Authentication | Rename |
| 3 | **Excessive Data Exposure** | Broken Object Property Level Authorization | **Merged** into BOPLA |
| 4 | **Lack of Resources & Rate Limiting** | Unrestricted Resource Consumption | **Reframed / expanded** |
| 5 | Broken Function Level Authorization | Broken Function Level Authorization | Same |
| 6 | **Mass Assignment** | Unrestricted Access to Sensitive Business Flows | **2019 Mass Assign → BOPLA**; slot reused for new risk |
| 7 | Security Misconfiguration | Server Side Request Forgery | **SSRF new**; misconfig moves |
| 8 | **Injection** | Security Misconfiguration | **Injection not first-class** in 2023 |
| 9 | Improper Assets Management | Improper Inventory Management | Rename / same idea |
| 10 | **Insufficient Logging & Monitoring** | Unsafe Consumption of APIs | **Logging dropped**; new risk |

## Six 2019 focuses that are **not first-class in 2023**

These still matter on engagements. This folder gives **standalone operator batches** (2023 board already merged some into BOPLA/URC/misconfig).

| ID | 2019 risk | Why still train it alone | Live on Inlanefreight |
|----|-----------|---------------------------|------------------------|
| **A** | API3 Excessive Data Exposure | Property *read* overshare ≠ full BOPLA drill | `GET /suppliers` email/phone (p4/p5) |
| **B** | API6 Mass Assignment | Property *write* over-bind | fee exemption PATCH; order `NetSum` |
| **C** | API4 Lack of Resources & Rate Limiting | Rate/quota framing (subset of URC) | SMS OTP flood; login no 429 |
| **D** | API8 Injection | SQLi/NoSQL/cmd as its own class | `/{Name}/count` SQLi (p12/p13) |
| **E** | API9 Improper Assets Management | Shadow/old versions, deleted data APIs | **`/api/v0/*` unauth deleted*** |
| **F** | API10 Insufficient Logging & Monitoring | **Gone from 2023 top 10** | Failures leave no client audit trail; methodology |

## New in 2023 only (already covered under `execution_batches/` 06–07 + upcoming)

- API6 Sensitive Business Flows  
- API7 SSRF  
- API10 Unsafe Consumption of APIs  

## How to use this folder

1. Run **2023** batches `00–08` (+ inventory / unsafe when needed).  
2. Run **2019** batches `01–06` here for gaps and interviews/exams that still say “API Top 10 2019.”  
3. Lab proofs: `notes/inlanefreight-2019-suite/` + cross-links to 2023 engagement folders.
