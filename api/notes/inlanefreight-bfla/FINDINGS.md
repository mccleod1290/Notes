# Lab findings — BFLA (Broken Function Level Authorization)

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Auth:** Customer `htbpentester9@hackthebox.com`  
**Tools:** curl, OpenAPI matrix  

## Roles

```json
{"errorMessage":"User does not have any roles assigned"}
```

JWT authenticates; **authorization surface is empty**.

## 1) Academy demo — product discounts

| Item | Detail |
|------|--------|
| Endpoint | `GET /api/v1/products/discounts` |
| Documented role | `ProductDiscounts_GetAll` (description) |
| OAS `security` | `JWTBearerAuth: []` (any JWT) |
| Result | **200**, 720 discount rows |
| Unauth | **401** |

**BFLA:** authenticated principal without the documented role receives full discount catalog (business-sensitive rates).

## 2) Flag hunt — all customers’ billing addresses

| Item | Detail |
|------|--------|
| Endpoint | `GET /api/v1/customers/billing-addresses` |
| Documented role | `CustomerBillingAddresses_GetAll` |
| OAS `security` | `JWTBearerAuth: []` |
| Result | **200**, 101 addresses (city/country/street/postal) |
| Flag | street field on customer `9076351f-…` |

```text
HTB{1e2095c564baf0d2d316080217040dae}
```

**Impact:** CWE-200 — exposure of customer PII to a user with **no** roles. Same endpoint can be framed as BOPLA/EDE when a role *is* assigned but fields overshare; here the primary class is **function** not allowed at all.

## 3) Negative control (enforcement works elsewhere)

| Endpoint | Documented role | p9 result |
|----------|-----------------|-----------|
| `GET /api/v1/customers` | `Customers_GetAll` (in `security`) | **403** |
| `GET /api/v1/customers/orders` | `CustomerOrders_GetAll` | **403** |
| `GET /api/v1/customers/payment-options` | `CustomerPaymentOptions_GetAll` | **403** |
| `GET /api/v1/suppliers` | `Suppliers_GetAll` | **403** |
| `POST /api/v1/customers/orders` | (create) | **403** |

Pattern: roles listed only in **HTML description** + empty security array → BFLA. Roles present in **security** array → 403.

## Evidence

```text
evidence/roles-p9.json
evidence/discounts-sample.json
evidence/billing-addresses-p9.json
evidence/billing-flag-excerpt.json
evidence/FLAGS.txt
evidence/swagger.json
```

JWTs redacted.

## Operator runbook

[../../execution_batches/05-bfla-broken-function-level-authz.md](../../execution_batches/05-bfla-broken-function-level-authz.md)
