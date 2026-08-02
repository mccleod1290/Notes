# Batch 04 — Unrestricted Resource Consumption (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
# Any principal that can upload / trigger paid side-effects / run expensive queries
EMAIL="staff@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
# From OAS: multipart uploads, export/report, OTP SMS/email, search/count, webhook fan-out
UPLOAD="/api/v1/.../upload"
SMS_OTP="/api/v1/.../sms-otps"          # or any paid third-party call
EXPENSIVE="/api/v1/.../search?q="       # export, report, count, reindex
STATIC_HINT="/uploads/"                 # or whatever path OAS/fileURI leaks
```

## GOAL
Prove the API lets a client **consume unbounded cost** — disk, CPU, memory, bandwidth, **or third-party spend** — without effective limits.

## TIME
1–2 hours

## YOU NEED
- OpenAPI + one auth role that can hit upload/export/OTP/search  
- curl; optional ffuf for volume  
- Disk/network awareness (don’t DoS production)

---

## WHY (first principles)

**Unrestricted Resource Consumption** (OWASP API4 / CWE-400) is not “hack the object id” and not “become the user.”  
It is: **one request (or a loop of cheap requests) → expensive server-side work or paid external work, with no hard ceiling.**

| Cost center | Typical failure |
|-------------|-----------------|
| **Disk / object store** | Unlimited upload size; no retention; store forever |
| **CPU / memory** | Huge JSON, zip bombs, image resize, base64 of multi-MB blobs |
| **Bandwidth** | Unauth download of large static files; bulk export |
| **Third-party $** | SMS/email/OTP, cloud AI, SMS gateways, fax, shipping labels |
| **DB / workers** | Unbounded search, report gen, N+1 fan-out without rate limit |

**vs Broken Auth:** Broken auth is *identity* takeover. URC is *cost* abuse (sometimes unauthenticated).  
**vs BOLA:** You may be fully authorized on the function; the bug is missing *quotas*.  
**vs BFLA:** BFLA is “I should not call this function.” URC is “I can call it *too much / too big*.”

Fix: **size limits, type/content validation, rate limits, quotas, authz on expensive ops, non-public storage.**

---

## DO THIS — Part A: Upload / storage (generic)

### A1) Map every multipart / file / “URI” field

```bash
curl -sk -o openapi.json "$BASE/swagger/v1/swagger.json"
# Grep: upload, FormFile, multipart, photo, certificate, attachment, export
```

### A2) Baseline allowed shape

```bash
JWT=$(curl -sk -X POST "$BASE$LOGIN" -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}" \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["jwt"])')
# Create tiny valid sample first (correct extension + field names from OAS)
```

### A3) Size abuse

```bash
dd if=/dev/urandom of=/tmp/big.bin bs=1M count=30
# multipart with real form field names from schema (wrong name → 500 NRE, not a vuln)
curl -sk -X POST "$BASE$UPLOAD" -H "Authorization: Bearer $JWT" \
  -F "TheFormFile=@/tmp/big.bin;filename=big.pdf;type=application/pdf" \
  -F "OwnerID=..."
```

**URC if:** multi‑MB (or multi‑GB) accepted; response returns `fileSize` / path; no 413.

### A4) Type / content abuse

```bash
# Same endpoint: .exe, .php, .sh, double extension, polyglot
curl -sk -X POST "$BASE$UPLOAD" -H "Authorization: Bearer $JWT" \
  -F "TheFormFile=@/tmp/payload.exe;filename=payload.exe" -F "OwnerID=..."
```

**Finding if:** non-allowed types stored. (Also file-upload RCE chain if executed; still *log* as URC + upload control failure.)

### A5) Public static / default framework behavior

```text
ASP.NET Core: fileURI under wwwroot → often UseStaticFiles() public
S3: ACL public-read
Nginx: alias /uploads
```

```bash
# From response fileURI path after wwwroot or bucket URL
curl -sk -O "$BASE/SupplierCompaniesCertificatesOfIncorporations/payload.exe"
curl -sk -o /dev/null -w "%{http_code} %{size_download}\n" "$BASE/ProductsPhotos/big.png"
```

**Impact:** free CDN for malware; customer data download without auth; bandwidth bill.

### A6) Operator log

```text
Upload endpoint:
Max size accepted:
Extensions accepted:
Storage path public? Y/N
Rate limit on upload? Y/N
```

---

## DO THIS — Part B: Paid / external side-effects (generic)

### B1) Find “costs money every call” endpoints

Swagger description text is gold:

```text
"charges us", "SMS provider", "email provider", "third-party", "webhook"
```

Also: password-reset SMS/email OTP, invite SMS, fax, shipping, AI inference.

### B2) Auth requirements

```bash
# Role: None + no auth often worst case
curl -sk -X POST "$BASE$SMS_OTP" -H 'Content-Type: application/json' \
  -d '{"Email":"victim@example.com"}'
```

### B3) Flood with measurement (lab / authorized only)

```bash
for i in $(seq 1 50); do
  curl -sk -X POST "$BASE$SMS_OTP" -H 'Content-Type: application/json' \
    -d '{"Email":"target@example.com"}'
  echo " i=$i"
done
```

**URC if:** every call succeeds (or fails “user not found” but still queues SMS); no 429; no CAPTCHA; no cooldown.

### B4) Operator log

```text
Endpoint:
Auth required? 
Per-IP / per-account limit observed?
External cost (SMS/email/API $):
```

---

## DO THIS — Part C: Expensive compute / query (generic)

### C1) Search, count, export, report, PDF render

```bash
# Wildcard / empty / long string / high limit
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../count/%25"
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../export?limit=999999"
```

### C2) Watch latency + status under parallel load

```bash
# Authorized lab only — short burst
seq 1 30 | xargs -P10 -I{} curl -sk -o /dev/null -w "%{http_code} %{time_total}\n" \
  -H "Authorization: Bearer $JWT" "$BASE$EXPENSIVE"
```

**URC if:** no 429, latency climbs, workers saturate, export multi‑GB.

---

## EDGE CASES (always)

| # | Test | Class |
|---|------|--------|
| E1 | Upload at limit−1 vs limit+1 vs no limit | Size URC |
| E2 | Content-Type image/png but body is ELF | Type URC |
| E3 | Extension `.pdf.exe` / null byte / path traversal in filename | Upload |
| E4 | Multipart field name wrong → 500 vs rejection | Recon |
| E5 | fileURI under `wwwroot` / public bucket | Static abuse |
| E6 | Unauth GET of large file after auth upload | Bandwidth |
| E7 | SMS/email OTP with no auth + no rate limit | $ URC |
| E8 | Email OTP vs SMS — different cost profiles | $ URC |
| E9 | Export/report without pagination | CPU/DB |
| E10 | Base64 download of multi‑MB blob (memory amplify) | Memory |
| E11 | GraphQL depth/alias batching | CPU |
| E12 | Zip bomb / nested archive if server unpacks | CPU/disk |
| E13 | Image resize/thumbnail on upload (CPU) | CPU |
| E14 | Concurrent uploads same account | Quota |
| E15 | Retention: files never deleted | Storage cost |

---

## Evidence comments (paste)

**Upload / storage**

```text
Class: Unrestricted Resource Consumption (API4 / CWE-400) — storage.
Authenticated principal uploaded file of size S (bytes) of type T to endpoint E.
Server accepted (2xx) with no max-size / type enforcement; optional public static path P.
Impact: disk fill, malware hosting, bandwidth on download.
Not Broken Auth: valid session for allowed role.
Not BOLA unless also reading another tenant’s private object by id.
```

**Paid side-effect**

```text
Class: Unrestricted Resource Consumption (API4 / CWE-400) — third-party cost.
Endpoint E triggers SMS/email/paid API with no rate limit / CAPTCHA / authz.
Evidence: N sequential calls all processed; OAS notes cost per message; no 429.
Impact: financial DoS against stakeholder SMS budget.
```

## Prevention

| Control | What |
|---------|------|
| Max request / file size | Gateway + app (413) |
| Allowlist extensions + magic bytes | Server-side, not UI only |
| Antivirus (e.g. ClamAV) | Before durable store |
| Rate limits + quotas | Per IP, user, tenant, endpoint class |
| AuthN/Z on expensive ops | OTP SMS should not be free firehose |
| Storage outside public root | Signed URLs, private bucket |
| Pagination / timeouts | Exports and search |
| Cost alerts | SMS/email spend anomalies |

## IF / THEN

| See | Do |
|-----|-----|
| Huge file accepted | Storage URC finding |
| .exe in “PDF only” endpoint | Upload control + URC |
| Public GET of upload | Misconfig + impact amplifier |
| SMS/email flood no 429 | Financial URC finding |
| Also wrong tenant file by id | Separate **BOLA** |
| Also unauth function that should be role-gated | Separate **BFLA** |

## NEXT
→ BFLA (function without role)  
→ Re-read [00-authz-authn-compare.md](./00-authz-authn-compare.md) when classifying reports  

---

## WORKED EXAMPLE (lab only — not the runbook)

Inlanefreight academy. Full proof: `../notes/inlanefreight-resource-consumption/`.

| Class | Example |
|-------|---------|
| Storage URC | `POST .../certificates-of-incorporation` accepts 30–40 MB “PDF”, `.exe` |
| Storage URC | `POST .../products/photo` accepts huge / non-PNG; path `wwwroot/ProductsPhotos/` |
| Static | Unauth `GET /SupplierCompaniesCertificatesOfIncorporations/*` and `/ProductsPhotos/*` |
| **$ URC (flag)** | Unauth flood `POST .../passwords/resets/sms-otps` → flag after ~10+ calls |
| OAS hint | SMS endpoint description: provider *charges significant amount per message* |
| Evidence | `notes/inlanefreight-resource-consumption/evidence/` |
