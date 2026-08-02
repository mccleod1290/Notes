# Batch 05 — BFLA: Broken Function Level Authorization (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
# Prefer a **low / zero-role** principal (or second account with fewer claims)
EMAIL="low@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
ROLES_PATH="/api/v1/roles/current-user"   # or decode JWT roles claim
OAS="$BASE/swagger/v1/swagger.json"
```

## GOAL
Show a principal can **invoke a function / endpoint they are not authorized to use** — not just another object id on an allowed function.

## TIME
1–2 hours

## YOU NEED
- OpenAPI with declared roles (or traffic + admin docs)  
- At least one low-priv or empty-role account  
- curl; optional matrix spreadsheet  

---

## WHY (first principles)

| | BOLA (API1) | BFLA (API5) |
|--|-------------|-------------|
| Question | *Which object* may I touch? | *Which function* may I call? |
| User is… | Authorized for the **endpoint type** | **Not** authorized for that endpoint |
| Classic fail | Missing owner check on `GET /orders/{id}` | Missing role check on `GET /admin/orders` |
| CWE | CWE-639 (often) | CWE-285 / CWE-200 (sensitive data via wrong function) |

**BFLA** = broken **function-level** authz (RBAC/ABAC on the *operation*).  
Swagger saying `Role(s) required: Foo_GetAll` is **not** enforcement — only server code is.

Common shapes:

1. Docs / gateway list role A; middleware only checks “JWT present”  
2. Admin routes reachable if you know the path  
3. HTTP method swap: `GET` allowed, `DELETE` not checked  
4. “Hidden” `/internal`, `/v0`, `/debug` without role gates  

Not BOLA unless you also swap object ids under an *allowed* function.  
See [00-authz-authn-compare.md](./00-authz-authn-compare.md).

---

## DO THIS (generic)

### 1) Login as low / zero role and inventory claims

```bash
JWT=$(curl -sk -X POST "$BASE$LOGIN" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')

curl -sk -H "Authorization: Bearer $JWT" "$BASE$ROLES_PATH"
# Also decode JWT payload roles claim if present
python3 - <<'PY'
import os,json,base64
j=os.environ.get("JWT") or open("/dev/stdin").read().strip()
# pass JWT via env in real shell
PY
```

Operator log:

```text
Principal:
Roles (server):
Roles (JWT claim):
```

### 2) Build the function matrix from OAS

```bash
curl -sk -o openapi.json "$OAS"
# For each path+method: required security roles, summary, whether path params needed
```

| Priority | Why |
|----------|-----|
| `*GetAll`, admin, export, delete, create | High impact functions |
| Role in **description** but empty `security: []` | Likely “docs only” RBAC |
| Endpoints your role list does **not** include | Primary BFLA targets |
| Skip pure `current-user` self paths first | Often intentionally allowed |

### 3) Call functions you should not have

```bash
# Authenticated, low role — no path params first
for path in \
  /api/v1/admin/users \
  /api/v1/products/discounts \
  /api/v1/customers/billing-addresses \
  /api/v1/.../export
do
  code=$(curl -sk -o /tmp/b -w "%{http_code}" -H "Authorization: Bearer $JWT" "$BASE$path")
  echo "$code $(wc -c </tmp/b) $path"
done
```

**BFLA if:** `200` + useful body **and** OAS/role inventory says you lack that role.  
**Expected secure:** `403` (or `401` if completely unauth).

### 4) Separate “needs auth” vs “needs role”

```bash
# No Authorization
curl -sk -o /dev/null -w "noauth:%{http_code}\n" "$BASE/api/v1/.../privileged"
# Any valid JWT, wrong role
curl -sk -o /dev/null -w "lowrole:%{http_code}\n" -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../privileged"
```

| noauth | low-role | Meaning |
|--------|----------|---------|
| 401 | 403 | Role check OK |
| 401 | 200 | **BFLA** (authn only) |
| 200 | 200 | Unauth function — worse BFLA / misconfig |

### 5) Methods and “admin by verb”

```bash
# Same path, different methods
for m in GET POST PUT PATCH DELETE; do
  curl -sk -X $m -o /dev/null -w "$m %{http_code}\n" -H "Authorization: Bearer $JWT" "$BASE/api/v1/resource"
done
```

### 6) Path-param endpoints (careful)

Only after you have **legitimate** ids from allowed sources, or synthetic ids:

```bash
# Still BFLA if function is forbidden even for “your” id
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/admin/orders/$ID"
```

If function is allowed but **other user’s** id works → file **BOLA**, not BFLA.

### 7) Operator log

```text
Endpoint + method:
Documented role:
Actual roles of principal:
HTTP status + data class (PII, discounts, admin):
Impact:
```

---

## EDGE CASES (always)

| # | Test | Class |
|---|------|--------|
| E1 | OAS description role ≠ `security` array | Docs-only RBAC |
| E2 | Empty role list / “User does not have any roles” still 200 | Classic BFLA |
| E3 | `current-user` OK; sibling `GetAll` open | Scope fail |
| E4 | GraphQL mutation without field-level authz | BFLA |
| E5 | `X-Original-URL` / path normalization to admin | Gateway BFLA |
| E6 | Method override (`X-HTTP-Method-Override`) | Verb BFLA |
| E7 | Older `/v0` admin without roles | Inventory + BFLA |
| E8 | 403 on GET, 200 on POST (or reverse) | Method matrix |
| E9 | Role in JWT but server ignores; role not in JWT but server allows | Claim vs enforce |
| E10 | Horizontal: customer hits supplier-only function | BFLA |
| E11 | Vertical: user hits admin function | BFLA |
| E12 | Batch/export endpoints “for support” left open | BFLA |
| E13 | Same data via BFLA list vs BOLA by id — file both if both true | Dual class |
| E14 | Unauth 401 but any JWT works — report as authz fail | BFLA |
| E15 | UI hides button; API still open | Never trust UI |

---

## Evidence comments (paste)

```text
Class: Broken Function Level Authorization (API5 / CWE-285 or CWE-200).
Principal P has roles R (empty or missing role X).
Endpoint E documents required role X / is an admin or GetAll function.
Request with P’s session returns 200 and sensitive data/operation result.
Not BOLA: failure is invoking the function at all, not only wrong object id.
Not Broken Auth: authentication succeeded; authorization on the function failed.
```

## Prevention

| Control | What |
|---------|------|
| Deny by default | Every route declares required permission |
| Enforce in code/middleware | Not only Swagger text |
| Central authz | Policy engine / attributes, not copy-paste checks |
| Tests | Negative tests: zero-role user → 403 on every privileged route |
| Least privilege JWTs | No “authenticated = full API” |
| Review GetAll / export / admin | Highest BFLA ROI |

## IF / THEN

| See | Do |
|-----|-----|
| 200 on role-gated GetAll with empty roles | **BFLA** finding |
| 200 on admin with user JWT | **BFLA** |
| Allowed list endpoint + change id → other tenant | **BOLA** |
| Extra fields on allowed response | **BOPLA EDE** |
| Login/OTP unlimited | **Broken Auth** / URC |

## NEXT
→ Unrestricted Access to Sensitive Business Flows  
→ Re-read [00-authz-authn-compare.md](./00-authz-authn-compare.md)  

---

## WORKED EXAMPLE (lab only — not the runbook)

Inlanefreight academy. Full proof: `../notes/inlanefreight-bfla/`.

| Class | Example |
|-------|---------|
| Demo BFLA | p9 zero roles → `GET /api/v1/products/discounts` (docs: `ProductDiscounts_GetAll`) |
| Flag BFLA | p9 → `GET /api/v1/customers/billing-addresses` (docs: `CustomerBillingAddresses_GetAll`) |
| Pattern | OAS `description` requires role; `security: JWTBearerAuth: []` = authn only |
| Secure contrast | `GET /api/v1/customers` with `Customers_GetAll` in security → **403** for p9 |
| Evidence | `notes/inlanefreight-bfla/evidence/` |
