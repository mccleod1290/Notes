# 2019 Batch 01 — API3: Excessive Data Exposure (standalone)

> **2023 note:** Folded into [API3 BOPLA](../../execution_batches/03-bopla-ede-mass-assignment.md) (read half). This batch is the **2019-shaped** EDE-only runbook.

## FILL IN

```bash
BASE="https://api.example.com"
EMAIL="lowpriv@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
```

## GOAL
Show the API returns **more object properties** than the client/role needs (full entity dump).

## WHY (first principles)

APIs often serialize **entire domain models**. UI shows name + status; JSON still has `email`, `phone`, `ssn`, `internalCost`.

| Need-to-know | Often overshared |
|--------------|------------------|
| Public id, display name | email, phone, address |
| Order status | full card / CVV hash |
| Product title | cost, margin, supplier private notes |

**Not BOLA** unless you also access another tenant’s object.  
**Not Mass Assignment** — this is **outbound** data.

CWE-213 (sensitive info exposure) / API3:2019.

## DO THIS

### 1) Login as lowest role that can list resources

```bash
JWT=$(curl -sk -X POST "$BASE$LOGIN" -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}" \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["jwt"])')
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/roles/current-user"
```

### 2) Call every list/detail GET for that role

```bash
for p in /api/v1/users /api/v1/suppliers /api/v1/orders /api/v1/companies; do
  curl -sk -H "Authorization: Bearer $JWT" "$BASE$p" -o "ede_$(echo $p|tr / _).json"
done
```

### 3) Diff UI fields vs JSON keys

EDE if sensitive keys present for that role.

### 4) Operator log

```text
Endpoint:
Role:
Sensitive keys:
Business impact:
```

## EDGE CASES

| # | Test |
|---|------|
| E1 | GraphQL/fields= still full object |
| E2 | Nested objects overshare |
| E3 | Export CSV extra columns |
| E4 | Older API version fatter DTO |
| E5 | Debug `?include=all` |

## Prevention

Response DTOs per role; never return raw entities; schema review of OpenAPI response models.

## WORKED EXAMPLE (lab)

p4/p5 customer → `GET /api/v1/suppliers` / `supplier-companies` / billing-addresses.  
See `../../notes/inlanefreight-bopla/` and `../notes/inlanefreight-2019-suite/evidence/ede-suppliers-excerpt.json`.
