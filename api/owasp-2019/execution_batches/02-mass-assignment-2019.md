# 2019 Batch 02 — API6: Mass Assignment (standalone)

> **2023 note:** Folded into [API3 BOPLA](../../execution_batches/03-bopla-ede-mass-assignment.md) (write half).

## FILL IN

```bash
BASE="https://api.example.com"
EMAIL="user@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
PATCH_PATH="/api/v1/.../resource"
```

## GOAL
Show the API **binds client JSON keys** into server models so the client can set **server-owned** properties (role, price, fee, verified).

## WHY

Auto-bind frameworks map request → model. If there is no **allowlist**, attackers add:

`isAdmin`, `role`, `balance`, `price`, `NetSum`, `isExemptedFromMarketplaceFee`, `ownerId`.

CWE-915. **Inbound** property trust failure (opposite direction of EDE).

## DO THIS

### 1) GET resource before

```bash
JWT=$( ... login ... )
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../current"
```

### 2) PATCH/POST with extra fields from OAS + guesses

```bash
curl -sk -X PATCH "$BASE$PATCH_PATH" \
  -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' \
  -d '{"UpdatedThing":{"id":"...","isExemptedFromMarketplaceFee":1,"NetSum":0,"role":"admin"}}'
```

### 3) GET after — did forbidden field stick?

### 4) Money paths

Client-set `price` / `amount` / `discount` / `NetSum` → set `0` or negative.

## EDGE CASES

| # | Test |
|---|------|
| E1 | Docs mark read-only but binder accepts |
| E2 | Form vs JSON bind difference |
| E3 | Nested wrappers required by DTO |
| E4 | Create vs update different allowlists |

## Prevention

Request DTOs allowlists; server computes prices/fees/roles; immutable fields rejected.

## WORKED EXAMPLE (lab)

p6 fee exemption; p7 order item `NetSum`. → `../../notes/inlanefreight-bopla/`.
