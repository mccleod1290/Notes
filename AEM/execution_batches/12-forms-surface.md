# Batch 12 — AEM Forms: surface map only

## objective

Decide if **AEM Forms / LiveCycle-style** surfaces exist and whether they look **standalone JEE** vs co-deployed. **No exploit payloads** in this batch.

## estimated_time

45–75 minutes

## prerequisites

- Forms hint from batch 01 or program scope lists Forms
- RCE may be out of scope — this batch is still safe recon

## testing_workflow

### 1) Technique A — path probe set

```bash
T="https://TARGET"

for p in \
  "/lc/libs/livecycle/core/content/login.html" \
  "/lc/" \
  "/edcws/" \
  "/adminui/" \
  "/adminui/login.do" \
  "/FormServer/" \
  "/FormServer/servlet/GetDocumentServlet" \
  "/content/forms/af/" \
  "/aem/forms/"
do
  curl -sk -o /tmp/f -w "%{http_code} %{size_download} $p\n" --max-time 10 "$T$p"
done
```

### 2) Technique B — classify deployment

```text
Standalone JEE smell: /FormServer, /adminui, JBoss-ish errors, /lc login without full Sites chrome
Co-deployed smell: /content/forms, guideContainers in QB, same host as AEM Sites
```

### 3) Technique C — guideContainer existence (if QB works)

```bash
# only if you have QB from earlier batches
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=15" | head -c 500; echo
```

### 4) Session output

```text
Forms_present: yes/no
Deployment: standalone / co-deployed / unknown
Interesting_paths:
Write_or_RCE_in_scope: yes/no
```

## decision_points

| If… | Then… |
|-----|--------|
| No Forms | Skip 13–14 → **15** |
| Co-deployed + guideContainer + write possible | **13** next |
| Standalone + RCE in scope | **14** next (criticals) |
| Standalone but no RCE in scope | Report exposure of adminui/FormServer; skip 14 exploits |

## expected_findings

- Attack surface inventory for Forms; version/login portals exposed to internet

## next_batch_to_continue_with

- Co-deployed classic path → **[13-forms-classic-xxe.md](./13-forms-classic-xxe.md)**  
- Standalone modern path → **[14-forms-modern-rce.md](./14-forms-modern-rce.md)**  
- No Forms → **[15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)**
