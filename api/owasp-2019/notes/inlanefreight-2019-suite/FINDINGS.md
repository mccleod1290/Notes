# Lab findings — OWASP API Top 10 **2019** gap suite

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Purpose:** Prove the six 2019-first-class risks that are **merged, reframed, or removed** in 2023 — same Inlanefreight API as 2023 batches.

## Screenshot evidence

| File | Content |
|------|---------|
| `evidence/swagger-ui-v1.png` | Swagger UI definition selector (v1/v0) |
| `evidence/swagger-ui-v0.png` | **v0** selected — deprecated banner text |

## A) API3:2019 Excessive Data Exposure

| Proof | Detail |
|-------|--------|
| Account | p4 customer |
| Endpoint | `GET /api/v1/suppliers` |
| Overshare | `email`, `phoneNumber` on 151 suppliers |
| Excerpt | `evidence/ede-suppliers-excerpt.json` |
| Full 2023 writeup | `../../notes/inlanefreight-bopla/` |

## B) API6:2019 Mass Assignment

| Proof | Detail |
|-------|--------|
| Fee flag | p6 PATCH `IsExemptedFromMarketplaceFee` |
| Price | p7 order items client `NetSum` |
| Full 2023 writeup | `../../notes/inlanefreight-bopla/` |

## C) API4:2019 Lack of Resources & Rate Limiting

| Proof | Detail |
|-------|--------|
| Login burst | 15 failed sign-ins → all processed, **no 429** (`rate-login-fails.txt`) |
| SMS OTP | Unauth flood still accepted (see URC flag lab) |
| Full 2023 writeup | `../../notes/inlanefreight-resource-consumption/` |

## D) API8:2019 Injection

| Proof | Detail |
|-------|--------|
| p12 | products `/{Name}/count` quote error + `OR 1=1` → full product count |
| p13 | suppliers count tautology → **151** |
| Full 2023 writeup | `../../notes/inlanefreight-security-misconfig/` |

## E) API9:2019 Improper Assets Management

| Proof | Detail |
|-------|--------|
| Asset | OpenAPI **v0** still published |
| Description | *Need to delete this version. Not maintained anymore…* |
| Unauth | `GET /api/v0/supplier-companies/deleted` → **200** |
| Flag row | Company `c250cb38-…` Email `HTB{43c2754afea99eba70fb2c8dc443c660}` |
| Worse | `GET /api/v0/suppliers/deleted` returns **PasswordHash** (125 rows) |
| Yara MacDonald hash | `006006C3167E90A7575A12E474218D86` (`yara-macdonald-deleted.json`) |

```text
HTB{43c2754afea99eba70fb2c8dc443c660}
```

## F) API10:2019 Insufficient Logging & Monitoring

| Black-box observation | Detail |
|----------------------|--------|
| Failed login body | Only `Invalid Credentials` |
| Headers | No `X-Request-Id` / trace / correlation (`logging-headers.txt`) |
| Rate signals | No 429 on auth/SMS abuse |
| Gap | Full SIEM validation not exposed to attacker; report as detection debt + recommended blue checks |

## Cross-links (do not duplicate giant evidence)

| 2019 risk | Primary engagement folder |
|-----------|---------------------------|
| EDE + Mass | `api/notes/inlanefreight-bopla/` |
| Rate limit | `api/notes/inlanefreight-resource-consumption/` |
| Injection | `api/notes/inlanefreight-security-misconfig/` |
| Assets v0 | **this folder** `evidence/` |
| Logging | **this folder** `evidence/logging-*` |

## Operator runbooks

`../execution_batches/01` … `06`
