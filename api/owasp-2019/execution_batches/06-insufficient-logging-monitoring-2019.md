# 2019 Batch 06 — API10: Insufficient Logging & Monitoring

> **2023 note:** **Removed** from the API Top 10 (logging still required by other standards: SOC2, PCI, NIST). Operators must still test it.

## FILL IN

```bash
BASE="https://api.example.com"
# After actions, ask defender side OR inspect if logs exposed
LOGIN="/api/v1/authentication/.../sign-in"
```

## GOAL
Show security-relevant events are **not logged**, not **alerted**, or logs are **tamperable / incomplete** — so attacks succeed silently.

## WHY (first principles)

Authz bugs without detection = long dwell time. Logging is a **control**, not a vuln class that “returns a flag” on most labs.

| Must log | Why |
|----------|-----|
| Authn success/fail + subject | Brute force detection |
| Authz failures (403) | BOLA/BFLA hunting |
| Input validation failures | Injection attempts |
| Admin / money operations | Fraud |
| Access to sensitive exports | Exfil |

| Must detect | Example |
|-------------|---------|
| Burst failed logins | No rate limit + no alert |
| Mass 403 on object ids | BOLA scan |
| Spike SMS OTP | URC financial abuse |

## DO THIS (operator checklist)

### 1) Black-box signals (client-visible)

```bash
# Failed login — any audit id / request id?
curl -sk -D - -X POST "$BASE$LOGIN" \
  -H 'Content-Type: application/json' \
  -d '{"Email":"audit-test@example.com","Password":"wrong"}' | head -30
```

Log:

```text
Correlation / request id present?
Generic error only?
Retry-After / lockout signal?
```

### 2) Action corpus for blue team validation

Run a scripted sequence and ask: *did SIEM see it?*

1. 20 failed logins  
2. 20 OTP SMS  
3. BOLA id sweep 1–50  
4. SQLi quote on count  
5. v0 deleted data access  
6. Privilege PATCH (mass assign)  

### 3) If logs are exposed (misconfig)

Never commit secrets. Check debug endpoints, `/logs`, open Elasticsearch, overly verbose 500s.

### 4) Integrity

Can attacker delete/modify logs via API? Admin without MFA?

### 5) Operator log / report text

```text
Class: Insufficient Logging & Monitoring (API10:2019).
Security events E1..En generated during test window T.
No client-side lockout/alert; [confirm with ops: no SIEM hits].
Impact: delayed detection of brute force / BOLA / injection.
```

## EDGE CASES

| # | Test |
|---|------|
| E1 | Logs missing user id on 401 |
| E2 | Success logged, failures not |
| E3 | PII secrets in logs (opposite problem) |
| E4 | Clock skew / no UTC |
| E5 | No retention / 24h wipe |
| E6 | Alerts only email to unmonitored inbox |

## GOTCHAS

| # | Gotcha |
|---|--------|
| G1 | Claiming “no logging” without blue-team confirmation |
| G2 | Lab that never exposes logs — still document **negative client evidence** + recommended validation |
| G3 | Logging passwords / tokens (that's also misconfig) |

## Prevention

Central structured audit log; alert on auth abuse and authz anomalies; immutable storage; correlate request ids end-to-end; red-team detection tests in CI.

## WORKED EXAMPLE (lab)

Inlanefreight black-box:

- Failed login → `{"errorMessage":"Invalid Credentials"}` only; **no** `X-Request-Id` / trace headers  
- SMS OTP + login bursts → no 429 (pairs with rate-limit batch)  
- Full detection validation needs defender SIEM access (not exposed)  

Evidence: `../notes/inlanefreight-2019-suite/evidence/logging-fail-body.json`, `logging-headers.txt`.
