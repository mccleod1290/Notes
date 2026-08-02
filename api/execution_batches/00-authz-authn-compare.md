# Batch 00 — Compare: Broken Auth vs BOLA vs BOPLA vs BFLA

## FILL IN

```bash
BASE="https://api.target"
# Have: User A (low), User B (same role other tenant), User Admin (high) if available
```

## GOAL
Never mix these four up in reports. Know **what failed**, **how to test**, **what evidence to paste**, and **edge cases** that still count.

## TIME
30–45 min read once; reuse on every API audit

---

## WHY — one sentence each

| Bug | One sentence |
|-----|----------------|
| **Broken Authentication** | Attacker becomes **someone** without valid credentials (or weak/broken login). |
| **BOLA** (IDOR / CWE-639) | Attacker is logged in as A but reads/writes **B’s object** by changing an ID. |
| **BOPLA** | Attacker is allowed the object (or list) but sees or sets **fields they should not**. |
| **BFLA** | Attacker calls a **function/endpoint/role** reserved for higher privilege (admin API as user). |

---

## First principles diagram

```text
                    ┌─────────────────────────┐
                    │  Who are you?           │
                    │  (Authentication)       │
                    └───────────┬─────────────┘
                                │ fail → Broken Authentication
                                ▼
                    ┌─────────────────────────┐
                    │  May you call this      │
                    │  function / endpoint?   │  ← BFLA if wrong
                    │  (Function-level authz) │
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │  May you touch THIS     │
                    │  object / row / id?     │  ← BOLA if wrong
                    │  (Object-level authz)   │
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │  May you see/set THESE  │
                    │  properties/fields?     │  ← BOPLA if wrong
                    │  (Property-level authz) │
                    └─────────────────────────┘
```

**Order in your head while testing:**

1. Can I log in wrong / brute / skip auth? → **Broken Auth**  
2. Can I hit admin-only routes as user? → **BFLA**  
3. Can I change `{id}` to another tenant’s? → **BOLA**  
4. Can I see extra JSON keys or set forbidden keys? → **BOPLA**

---

## Compare & contrast table

| | **Broken Authentication** | **BOLA** | **BOPLA** | **BFLA** |
|--|---------------------------|----------|-----------|----------|
| **OWASP API** | API2:2023 | API1:2023 | API3:2023 | API5:2023 |
| **CWE (examples)** | CWE-307 (no rate limit), weak crypto/session | CWE-639 | CWE-213 (EDE), CWE-915 (mass assign) | CWE-285 / missing role check |
| **Question that fails** | “Is this really Alice?” | “Is this Alice’s invoice?” | “May Alice see `ssn` / set `isAdmin`?” | “May Alice call `DELETE /admin/users`?” |
| **Typical input** | password, OTP, token alg | path/query/body **object id** | extra/missing **JSON properties** | path/method/role (**function**) |
| **Need valid session?** | Often **no** (or weak yes) | **Yes** (as user A) | **Yes** | **Yes** (as low role) |
| **Need second account?** | Sometimes (stuffing pairs) | **Strongly yes** (A vs B) | Helpful | **Yes** (user vs admin) |
| **Lab kit** | [02-broken-authentication.md](./02-broken-authentication.md) | [01-bola-idor.md](./01-bola-idor.md) | [03-bopla-ede-mass-assignment.md](./03-bopla-ede-mass-assignment.md) | (upcoming batch 04) |

### BOPLA has two faces (do not merge in one finding)

| Face | Direction | Test |
|------|-----------|------|
| **Excessive Data Exposure (EDE)** | Response → client | Diff UI vs JSON; GetAll leaks email/phone/flags |
| **Mass Assignment** | Client → server | Add `isExempted`, `NetSum`, `role` on PATCH/POST |

---

## How they look on the same API (Inlanefreight-style)

| Scenario | Class |
|----------|--------|
| No rate limit + weak passwords / OTP brute → login as Isabella/Mason | **Broken Auth** |
| Supplier JWT + `yearly-reports/1` returns **other company** | **BOLA** |
| Customer JWT + `GET /suppliers` returns **email/phone** | **BOPLA-EDE** |
| Supplier PATCH sets **isExemptedFromMarketplaceFee=1** | **BOPLA-Mass** |
| Customer JWT + `GET /api/v1/admin/...` or role-only admin action works | **BFLA** |
| List all yearly reports **403**, but by-id **200 other tenant** | **BOLA** (not BFLA — function allowed, object check missing) |
| List customers **200** with other users’ PII, same role | **BOPLA-EDE** (and maybe BOLA if object scoped) |

### Easy confusions (fix these)

| Mix-up | Reality |
|--------|---------|
| “IDOR so it’s BFLA” | IDOR/BOLA = **object**; BFLA = **endpoint/role** |
| “I saw extra fields so BOLA” | Extra fields = **BOPLA-EDE** unless you also accessed wrong object id |
| “I changed password of other user via id” | Often **BOLA** (wrong object) + sometimes BFLA if only admin should update |
| “I logged in as admin by setting role in JWT” | **Broken Auth** / JWT misconfig — not BOLA |
| “Mass assign is BOLA” | Mass assign is **BOPLA** (property), unless you also hit wrong resource id |

---

## Audit testing checklist (per class)

### Broken Authentication — test

```text
[ ] Fail login message + status (enum?)
[ ] Rate limit / lockout after N fails
[ ] Weak password policy (register/update)
[ ] Password spray / stuffing (authorized)
[ ] OTP / security question entropy + rate limit
[ ] MFA bypass / skip step
[ ] JWT: none, weak secret, alg confusion, exp
[ ] Session fix / logout invalidation
```

### BOLA — test

```text
[ ] Login A; capture object id belonging to A
[ ] Login B (or A with B’s id); swap id in path/query/body
[ ] Sequential int walk; UUID leak from other endpoints
[ ] Horizontal (same role) and vertical (user→admin object)
[ ] Create as A, read/update/delete as B
[ ] Encode / HPP on id parameters
```

### BOPLA — test

```text
[ ] EDE: dump list/detail JSON; mark sensitive keys not in UI
[ ] EDE: role matrix (customer vs supplier vs admin responses)
[ ] Mass: PATCH/POST with extra properties from full schema / DB names
[ ] Mass: toggle booleans (isAdmin, isExempted, verified)
[ ] Mass: money fields (price, NetSum, discount, balance)
[ ] Compare request DTO in Swagger vs what server actually accepts
```

### BFLA — test

```text
[ ] Map endpoints by role from JWT/Swagger locks
[ ] As low role, call high-role paths (admin, other resource groups)
[ ] Change HTTP method (GET user may POST admin)
[ ] Hidden admin routes from OAS / JS / fuzz
[ ] Role claim tamper only if signature broken (else Broken Auth/JWT)
```

---

## Evidence: what to capture + comment to paste

Use the same structure in Burp/gori notes, tickets, and FINDINGS.md.

### Template (copy)

```text
## Finding title
[Broken Auth | BOLA | BOPLA-EDE | BOPLA-Mass | BFLA] — short impact

## Class rationale (1–2 lines)
Failed control: [authn | function authz | object authz | property authz]
Why not the others: ...

## Preconditions
Account: role=...  (A/B if needed)
Auth: Bearer JWT / cookie (redact token)

## Request (minimal)
METHOD path
Relevant headers
Body (if any)

## Response (minimal)
Status
Proof fields (id, companyID, email, isExempted, NetSum, flag, ...)

## Expected secure behavior
...

## Impact
...

## Edge cases tried
...
```

### Example comments (ready to paste)

**Broken Auth**

```text
Class: Broken Authentication (API2 / CWE-307).
Login endpoint accepts unlimited attempts; weak password policy allows 6-char passwords.
Evidence: fail body "Invalid Credentials"; ffuf hit EMAIL/PASS; no 429/lockout observed under ~N rps.
Not BOLA: we obtained a valid session as the victim, not by swapping object IDs under our own session.
```

**BOLA**

```text
Class: BOLA / IDOR (API1 / CWE-639).
Authenticated as supplier company X; GET .../yearly-reports/{id} returned companyID Y ≠ X for ids 1..N.
Evidence: current-user company Guid; report JSON companyID + revenue; mass loop output.
Not BFLA: role correctly grants GetYearlyReportByID; failure is object ownership check.
Not BOPLA: issue is wrong object, not extra fields on our own report.
```

**BOPLA — EDE**

```text
Class: BOPLA — Excessive Data Exposure (API3 / CWE-213).
Customer role may list suppliers/companies but response includes email/phone (and other sensitive properties) not required for marketplace UX.
Evidence: GET /api/v1/suppliers sample object keys; comparison to least-privilege fields (id, name only).
Not BOLA: we did not access another user's private object by id swap alone; overshare is on authorized list response.
```

**BOPLA — Mass Assignment**

```text
Class: BOPLA — Mass Assignment (API3 / CWE-915).
Authenticated supplier PATCH accepted IsExemptedFromMarketplaceFee=1 (or client NetSum on order items).
Evidence: GET before (0) → PATCH → GET after (1); or create item with NetSum=0 and server Message/flag.
Not BOLA: resource is our company/order; unauthorized *property* write.
Not Broken Auth: used legitimate JWT for that user.
```

**BFLA**

```text
Class: BFLA (API5).
Low-privilege JWT successfully invoked endpoint/function reserved for higher role (e.g. admin list/update).
Evidence: roles/current-user shows only low roles; request to privileged path returns 200 with admin data/action.
Not BOLA: we did not merely change object id within an allowed function; the function itself should be denied.
```

---

## Evidence matrix (minimum artifacts)

| Class | Minimum artifacts |
|-------|-------------------|
| Broken Auth | login fail sample; policy error; spray/OTP hit (redact secrets); rps/no lockout note |
| BOLA | identity baseline (my id); victim object response; id used; optional mass loop |
| BOPLA-EDE | full JSON object; list of sensitive keys; role that received them |
| BOPLA-Mass | before/after GET; PATCH/POST body with forbidden field; success |
| BFLA | role list; privileged request/response; denied expected |

**Screenshots (pinchtab/gori):** Swagger Authorize + response panel; optional Burp/gori repeater with id/property highlight.

---

## Quick decision tree (during audit)

```text
Did you need valid victim password/OTP/session forgery?
  YES → Broken Authentication
  NO  → continue

Did low role call a high-role / admin function that should 403?
  YES → BFLA
  NO  → continue

Did changing object id access another tenant's resource?
  YES → BOLA
  NO  → continue

Did response contain extra sensitive fields OR request set forbidden fields?
  YES → BOPLA (EDE vs Mass)
  NO  → other class / secure
```

---

## IF / THEN

| Situation | Classification tip |
|-----------|-------------------|
| 401 without token, 200 any id with token | Auth works; check **BOLA** |
| 403 on collection, 200 on `/{id}` other tenant | **BOLA** |
| 200 collection with other users’ PII same role | **BOPLA-EDE** (maybe also BOLA if scoped) |
| Can set `role=admin` in body | **Mass assign** (± Broken Auth if JWT role trusted) |
| Can call `/admin` as user | **BFLA** |

---

## NEXT

- Practice: [01-bola-idor.md](./01-bola-idor.md)  
- Practice: [02-broken-authentication.md](./02-broken-authentication.md)  
- Practice: [03-bopla-ede-mass-assignment.md](./03-bopla-ede-mass-assignment.md)  
- Later: BFLA dedicated batch when Academy section is run  

**Read this card once per engagement**, then hang evidence comments from the templates above.
