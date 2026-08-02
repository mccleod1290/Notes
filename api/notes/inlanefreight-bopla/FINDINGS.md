# Lab findings — BOPLA (EDE + Mass Assignment)

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Tools:** curl, OpenAPI, pinchtab screenshot  

## 1) Excessive Data Exposure (CWE-213)

### Academy demo (p4)

| Item | Detail |
|------|--------|
| Auth | Customer `htbpentester4@hackthebox.com` |
| Roles | `Suppliers_Get`, `Suppliers_GetAll` |
| Endpoint | `GET /api/v1/suppliers` |
| Leak | `email`, `phoneNumber` on every supplier (151 rows) |
| Impact | Customers bypass marketplace fee / contact suppliers off-platform |

### Flag hunt (p5)

| Auth | `htbpentester5@hackthebox.com` |
| Roles | also `SupplierCompanies_Get/GetAll` |

| Endpoint | Sensitive fields | Flag |
|----------|------------------|------|
| `GET /api/v1/supplier-companies` | full company emails, fee flags | `HTB{d759c70b5a9f6a392af78cc1eca9cdf0}` (HTB Academy email) |
| `GET /api/v1/customers/billing-addresses` | all customers’ addresses | `HTB{1e2095c564baf0d2d316080217040dae}` (street) |

## 2) Mass Assignment (CWE-915)

### Academy demo (p6)

| Item | Detail |
|------|--------|
| Auth | Supplier `htbpentester6@pentestercompany.com` |
| Roles | `SupplierCompanies_Update`, `SupplierCompanies_Get` |
| Before | `isExemptedFromMarketplaceFee: 0` |
| Exploit | `PATCH /api/v1/supplier-companies` with `IsExemptedFromMarketplaceFee: 1` |
| After | fee exemption **1** |
| Impact | Supplier avoids marketplace fees |

### Flag hunt (p7)

| Auth | Customer `htbpentester7@hackthebox.com` |
| Roles | order create + order items |
| Steps | POST order → POST items with attacker `NetSum` |
| Endpoint | `POST /api/v1/customers/orders/items` |
| Result | `SuccessStatus: true`, `Message: HTB{4d86794f82046e465ca29d91bdbe5bca}` |
| Impact | Client controls line price (should be server-side) |

## Evidence

```text
evidence/suppliers-as-customer-p4.json
evidence/ede-p5_api_v1_supplier-companies.json
evidence/ede-p5_api_v1_customers_billing-addresses.json
evidence/company-before-p6.json
evidence/mass-assign-patch-p6.json
evidence/company-after-p6.json
evidence/p7-create-order.json
evidence/p7-items-netsum-0.json
evidence/FLAGS.txt
evidence/swagger-ui.png
```

Login JWTs redacted to `[REDACTED]`.

## Operator runbook

[../../execution_batches/03-bopla-ede-mass-assignment.md](../../execution_batches/03-bopla-ede-mass-assignment.md)
