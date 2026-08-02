# Lab findings — Unrestricted Access to Sensitive Business Flows (API6)

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Auth:** Customer `htbpentester9@hackthebox.com` (zero roles)  
**Depends on:** BFLA access to privileged GetAll-style reads  

## Business flows identified

### Flow A — Pricing / discount calendar

| Item | Detail |
|------|--------|
| Endpoint | `GET /api/v1/products/discounts` |
| Access bug | BFLA (docs: `ProductDiscounts_GetAll`; empty roles still 200) |
| Sensitive artifact | All products’ `ratePercentage`, `startDate`, `endDate` |
| Academy example | Product `a923b706-0aaa-49b2-ad8d-21c97ff6fac7` → **70%** from **2023-03-15** to **2023-09-15** |
| Abuse | Time purchases for max discount; if order API lacks rate/stock guards (URC), exhaust stock and resell |

### Flow B — Customer location catalog (Q1)

| Item | Detail |
|------|--------|
| Endpoint | `GET /api/v1/customers/billing-addresses` |
| Access bug | BFLA (docs: `CustomerBillingAddresses_GetAll`) |
| Sensitive artifact | 101 rows: customerID, city, country, street, postalCode |
| Target ID | `daa8c984-ba84-4265-8d88-12d6607e511c` |

**Street address (submit as answer):**

```text
788 Sauchiehall St.
```

| Field | Value |
|-------|--------|
| city | Glasgow |
| country | UK |
| postalCode | 63103 |

**Abuse:** unrestricted **logistics / marketing / fraud** fuel — any zero-role customer can map where any customer lives (physical risk, phishing, account recovery social eng).

## How classes stack (same session)

```text
BFLA  →  call GetAll without role
  ↓
API6  →  data is a sensitive business process (pricing intel / address book)
  ↓
(+ URC on buy) → scalping story (academy narrative)
```

## Evidence

```text
evidence/roles-p9.json
evidence/discounts-business-sample.json
evidence/billing-addresses-p9.json
evidence/billing-target-excerpt.json
evidence/ANSWER-street.txt
evidence/FLAGS.txt
evidence/login-p9.json   # JWT redacted
```

## Operator runbook

[../../execution_batches/06-unrestricted-sensitive-business-flows.md](../../execution_batches/06-unrestricted-sensitive-business-flows.md)
