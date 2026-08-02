# Batch 02 — CSRF, CORS, methods, caching, headers, TLS

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Finish **6 checks**: CSRF, CORS, HTTP Methods, Form Caching, HTTP Headers, TLS ≥ 1.2.

## TIME
1–2 hours

## YOU NEED
- Batch 00 (Match & Replace CORS recipe + verb matrix)
- Session cookie / logged-in browser

---

## WHY (30 seconds)

**CSRF** = site trusts browser cookies; attacker site triggers state change.  
**CORS** = browser rule for cross-origin JS reads; misconfig lets evil.com read your API **with cookies**.  
**HTTP methods** = extra verbs can bypass filters or enable overwrite.  
**Form caching** = browser stores passwords/PII in cache/back.  
**Headers** = free hardening (or missing = attack surface).  
**TLS** = old SSL/TLS = downgrade / known breaks.

---

## DO THIS

### A) CORS (use batch 00 workflow — full depth)

1. Enable Match & Replace: `Origin: https://evil-attacker.com`.  
2. Browse all authenticated pages + APIs.  
3. Filter history for `Access-Control-Allow-Origin`.  
4. For each hit, check:

| Response | Risk |
|----------|------|
| ACAO = `https://evil-attacker.com` + `Allow-Credentials: true` | **High** (steal data with cookies) |
| ACAO reflects any Origin + credentials | **High** |
| ACAO = `*` only, no credentials | Often low; note if sensitive no-auth data |
| ACAO = `null` trusted | Sandbox/PDF attack path |

5. Confirm with fetch PoC from attacker origin (browser console on evil page):

```javascript
fetch("https://TARGET/api/me", { credentials: "include" })
  .then(r => r.text()).then(console.log)
```

6. OPTIONS preflight on APIs that use PUT/JSON (see batch 00).  
7. **Disable** Match & Replace when finished.

### B) CSRF (state-changing requests only)

From history, list POST/PUT/PATCH/DELETE that change data.

For each:

1. Is there CSRF token? random header? SameSite cookie?  
2. Replay **without** token / with empty token / with other user’s token.  
3. If still succeeds → PoC HTML:

```html
<form action="https://TARGET/api/change-email" method="POST">
  <input name="email" value="attacker@evil.com" />
</form>
<script>document.forms[0].submit()</script>
```

4. JSON APIs: try `Content-Type: text/plain` or form-encoded body if server is loose.  
5. Check `SameSite=None` cookies + missing CSRF.

### C) HTTP Methods (plus verb×path from 00)

1. On sensitive paths:

```bash
for m in OPTIONS TRACE PUT DELETE PATCH; do
  curl -sk -X "$m" -o /dev/null -w "%{http_code} $m\n" "https://TARGET/api/users/1"
done
```

2. **TRACE** enabled → XST risk (note).  
3. **PUT/DELETE** without authz → batch 04.  
4. Finish verb×path matrix from 00 if incomplete.

### D) Form Caching

1. Login + profile forms → check:

```html
autocomplete="off"   <!-- on password fields? -->
```

2. Headers:

```bash
curl -skI "https://TARGET/account" | grep -iE 'cache-control|pragma'
```

Want on sensitive pages: `Cache-Control: no-store` (or no-cache + pragmas).  
3. Login → enter password → logout → browser **Back**. Password still filled? → finding.  
4. Check bfcache / “Store password?” prompts only as notes.

### E) HTTP Headers (security suite)

```bash
curl -skI "https://TARGET/" | tee headers.txt
```

Check presence/quality of:

```text
Strict-Transport-Security
Content-Security-Policy
X-Content-Type-Options: nosniff
X-Frame-Options / CSP frame-ancestors
Referrer-Policy
Permissions-Policy
```

Also note info leaks: `Server`, `X-Powered-By`, `X-AspNet-Version`.  
Missing headers = **leads** (often medium/info unless chained).

### F) TLS 1.2 or more

```bash
# needs nmap or sslscan / testssl.sh
nmap --script ssl-enum-ciphers -p 443 TARGET
# or
testssl.sh https://TARGET
```

**Fail if:** SSLv3, TLS 1.0, TLS 1.1 still offered, or weak ciphers (RC4, 3DES, export).  
**Pass:** only TLS 1.2+ (ideally 1.3).

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| CORS + credentials | Prioritize in report |
| CSRF on money/email | High |
| TRACE on | Note + disable recommendation |
| Only missing headers | Info/low unless XSS needs CSP gap |

---

## NEXT
→ [03-session-lifecycle.md](./03-session-lifecycle.md)
