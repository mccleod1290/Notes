# Batch 09 — JWT + OAuth

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Finish **4 checks**: JWT None Algorithm, JWT Embedded JWK / signature validation, JWT Config, OAuth Checks.

## TIME
1–2 hours

## YOU NEED
- JWT from login (cookie or `Authorization: Bearer`)  
- [jwt.io](https://jwt.io) or `jwt_tool` / `jose`  
- OAuth/OIDC login if present  

---

## WHY (30 seconds)

**JWT** = three base64 parts: `header.payload.signature`.  
Server must **verify signature** with a trusted key.  

| Bug | Meaning |
|-----|---------|
| **alg:none** | Attacker removes crypto; server accepts |
| **Embedded JWK** | Attacker puts **their** key in header; server trusts it |
| **Bad config** | Weak secret, long life, sensitive data in payload, no `aud`/`iss` check |
| **OAuth mistakes** | Steal `code` / token via redirect, skip `state`, account link hijack |

---

## DO THIS

### 0) Capture token

```bash
# from proxy after login
# header looks like: eyJhbGciOi...
```

Decode payload (jwt.io). Note claims: `sub`, `role`, `exp`, `iss`, `aud`.

---

### A) None Algorithm

1. Set header to:

```json
{"alg":"none","typ":"JWT"}
```

2. Keep or edit payload (`"role":"admin"`).  
3. Signature = **empty** (token ends with `.` only):

```text
base64url(header).base64url(payload).
```

4. Send as Cookie / Bearer.

**Win:** server accepts and elevated claims work.

Also try: `None`, `NONE`, `nOnE`.

---

### B) JWT Signature Validation / Embedded JWK

**Embedded JWK idea:** header points to attacker key material.

```json
{
  "alg": "RS256",
  "jwk": {
    "kty": "RSA",
    "kid": "attacker",
    "use": "sig",
    "n": "...",
    "e": "AQAB"
  }
}
```

Sign payload with **your** private key matching that JWK.  
If server uses header JWK to verify → ATO/admin.

Also test:

| Attack | Do |
|--------|-----|
| **alg confusion** RS256→HS256 | Sign with public key as HMAC secret |
| **kid injection** | `kid`: `../../dev/null` or SQLi in kid |
| **jku / x5u** | URL to attacker JWKS if followed |

Tools: `jwt_tool` common flags for these.

**Win:** forged token accepted.

---

### C) JWT Config (misconfiguration checklist)

Go through:

```text
[ ] Secret weak / empty (crack with hashcat/jwt cracker if HS*)
[ ] exp missing or far future
[ ] role/admin in payload trusted without server check
[ ] no iss/aud validation (reuse token on other API)
[ ] sensitive PII in payload (never secret, but privacy)
[ ] refresh token never rotates
```

```bash
# if HS256 and you suspect weak secret
# jwt_tool TOKEN -C -d wordlist.txt
```

---

### D) OAuth Checks

If “Login with Google/GitHub/…” or custom OAuth:

| Check | How |
|-------|-----|
| **redirect_uri** loose | Change to `https://evil.com` or subdomain tricks |
| **state** missing | CSRF login link other user |
| **state** not bound | Replay |
| **code** leak | code in Referer / open redirect chain |
| **token in URL fragment** | XSS steals; history leak |
| **account linking** | Link attacker IdP to victim without re-auth |
| **PKCE** missing on public clients | Note for mobile/SPA |

**Minimal probes:**

1. Start OAuth → capture authorize URL.  
2. Mutate `redirect_uri`, drop `state`, replay `code` twice.  
3. Complete flow with evil redirect if allowed.

**Win:** code/token to attacker, force-link, login CSRF.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| alg none works | Critical |
| Only weak secret | Crack offline; do not DDoS |
| No JWT / no OAuth | Mark N/A — **board complete** |

---

## NEXT
**Board complete** for generic web app testing.  
If target is AEM/IIS-specific, switch to those folders’ batch boards.

---

## Progress close-out template

```text
Target:
Batches done: 00-09
Findings count:
Retest notes:
```
