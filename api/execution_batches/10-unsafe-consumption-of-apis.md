# Batch 10 — Unsafe Consumption of APIs (API10:2023)

## FILL IN

```bash
BASE="https://api.example.com"
# Any path where *this* API trusts *another* API’s data without re-validation
```

## GOAL
Show trust in **third-party or sibling APIs** (including your own deprecated v0) without validation → inherited vulns, injected data, credential leak.

## WHY

```text
API v1  --trusts-->  API v0 / partner / webhook source
              |
              +--> no schema check, no auth, HTTP not HTTPS, no rate limit
```

| Risk | Example |
|------|---------|
| Insecure transport | HTTP between services |
| No validation | Import partner JSON as-is → XSS/SQLi downstream |
| Weak auth | Static key / none |
| No rate limit | Partner DoS you |
| Legacy trust | v1 “syncs” from unauth v0 deleted users |

## DO THIS

### 1) Map outbound dependencies

Webhooks, import-by-URL (also SSRF), “sync from legacy”, payment/KYC providers.

### 2) On this lab: treat v0 as untrusted source

```bash
# Unauth deleted suppliers include PasswordHash
curl -sk "$BASE/api/v0/suppliers/deleted" | head -c 500
```

If v1 ever **ingested** those hashes/emails without re-hashing/validation, compromise transfers.

### 3) Operator question (Academy-style)

“If v1 unsafely accepted data from `/api/v0/suppliers/deleted`, what would user X’s password hash be?”  
→ Read from v0 (lab answer for Yara MacDonald):

```text
006006C3167E90A7575A12E474218D86
```

Evidence: `../owasp-2019/notes/inlanefreight-2019-suite/evidence/yara-macdonald-deleted.json`

## Prevention

mTLS; validate/sanitize all consumed data; never trust internal APIs blindly; inventory dependencies; circuit breakers.

## NEXT

Skills assessment / full Top 10 retest checklist.
