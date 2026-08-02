# Batch 03 — BOPLA: EDE + Mass Assignment (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
# Account A: role that can list "public" or peer resources
EMAIL_A="user@example.com"; PASS_A="..."
LOGIN_A="/api/v1/authentication/.../sign-in"
# Account B: role that can update self/org
EMAIL_B="staff@example.com"; PASS_B="..."
LOGIN_B="/api/v1/authentication/.../sign-in"
```

## GOAL
Find **property-level** failures:

1. **EDE** — response contains fields the role must not see  
2. **Mass assignment** — request accepts fields the role must not set  

## TIME
1–2 hours

## YOU NEED
- At least one authenticated role (two roles better)  
- OpenAPI + traffic  
- curl / gori  

---

## WHY (first principles)

| | BOLA | BOPLA |
|--|------|--------|
| Wrong thing | **object/id** | **fields/properties** |
| EDE | — | overshare **out** |
| Mass assign | — | over-trust **in** |

| Subclass | CWE | Idea |
|----------|-----|------|
| Excessive Data Exposure | CWE-213 | Full entity serialized; role only needs public subset |
| Mass Assignment | CWE-915 | Binder maps every JSON key into model |

Fix: **response DTO** + **request DTO allowlists**; server-owned prices/fees/roles.

Not BOLA unless you also hit another tenant’s object by id.  
See [00-authz-authn-compare.md](./00-authz-authn-compare.md).

---

## DO THIS — Part A: Excessive Data Exposure (generic)

### A1) Login as low/peer role

```bash
JWT=$(curl -sk -X POST "$BASE$LOGIN_A" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL_A\",\"Password\":\"$PASS_A\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../roles/current-user"
```

### A2) Call every list/detail GET for that role

```bash
# From OAS: GET collections and /{id}
for path in /api/v1/users /api/v1/suppliers /api/v1/orders /api/v1/companies; do
  curl -sk -H "Authorization: Bearer $JWT" "$BASE$path" -o "out$(echo $path|tr / _).json"
done
```

### A3) Diff “need to know” vs JSON keys

| Usually OK for peers | Often sensitive (EDE if present) |
|----------------------|----------------------------------|
| public id, display name | email, phone, address, DOB |
| product title, public price | cost, margin, internal notes |
| order status | full card, CVV hash, SSN |

**EDE if:** role is customer/public/peer but JSON includes contact/PII/internal finance fields.

### A4) Operator log

```text
EDE endpoints:
Sensitive keys:
Role that received them:
```

---

## DO THIS — Part B: Mass Assignment (generic)

### B1) Login as role that can update something

```bash
JWT2=$( ... login B ... )
# GET resource before
curl -sk -H "Authorization: Bearer $JWT2" "$BASE/api/v1/.../current-user-or-org"
```

### B2) Build PATCH/POST from OAS — then add forbidden fields

```text
From schema: required fields
Add candidates: isAdmin, role, verified, balance, price, NetSum,
  isExempted*, discount, ownerId, status
```

```bash
curl -sk -X PATCH "$BASE/api/v1/..." \
  -H "Authorization: Bearer $JWT2" -H 'Content-Type: application/json' \
  -d '{"...wrapper...":{"id":"...","isExemptedFromMarketplaceFee":1,"NetSum":0,"role":"admin"}}'
```

### B3) Re-GET and compare

**Mass assign if:** forbidden field stuck (fee off, price 0, role elevated).

### B4) Money/order paths

Anywhere client sends `price`, `amount`, `NetSum`, `discount` — set to `0` / negative / other user’s price.

### B5) Operator log

```text
Mass-assign endpoint:
Field:
Before → after:
Impact:
```

---

## EDGE CASES (always)

| # | Test | Class |
|---|------|--------|
| E1 | UI fields vs full JSON | EDE |
| E2 | GraphQL/`fields=` still returns full object | EDE |
| E3 | Nested overshare | EDE |
| E4 | Extra JSON properties on PATCH | Mass |
| E5 | Booleans: isAdmin, verified, exempt | Mass |
| E6 | Money fields client-set | Mass |
| E7 | Read-only in docs but writable | Mass |
| E8 | Content-Type form vs JSON bind difference | Mass |
| E9 | Older `/v0` fatter DTO | EDE |
| E10 | Export CSV extra columns | EDE |
| E11 | gori: inject properties not in UI | Mass |

---

## Evidence comments (paste)

**EDE**

```text
Class: BOPLA — Excessive Data Exposure (API3 / CWE-213).
Role R authorized to list resource type T but response includes fields F not required for that role.
Evidence: sample JSON keys; role list; least-privilege field set expected.
Not BOLA: authorized function/list; failure is property visibility.
```

**Mass assignment**

```text
Class: BOPLA — Mass Assignment (API3 / CWE-915).
Authenticated principal set property P which should be server-controlled.
Evidence: GET before; request body; GET after / success message.
Not BOLA: same tenant/object; unauthorized property write.
Not Broken Auth: legitimate session for that user.
```

## Prevention

Response DTOs per role; request allowlists; never trust client prices/fees/roles.

## IF / THEN

| See | Do |
|-----|-----|
| Extra sensitive keys | EDE finding |
| Forbidden field sticks | Mass assign finding |
| Also wrong tenant id | File **BOLA** separately |

## NEXT
→ BFLA / resource consumption (later)  
→ Re-read [00-authz-authn-compare.md](./00-authz-authn-compare.md) when writing reports  

---

## WORKED EXAMPLE (lab only — not the runbook)

Inlanefreight academy. Full proof: `../notes/inlanefreight-bopla/`.

| Class | Example |
|-------|---------|
| EDE | Customer `GET /suppliers` → email/phone |
| EDE hunt | `GET /supplier-companies`, `GET /customers/billing-addresses` |
| Mass | Supplier PATCH `IsExemptedFromMarketplaceFee=1` |
| Mass | Customer order items client `NetSum` |
| Evidence | `notes/inlanefreight-bopla/evidence/` |
