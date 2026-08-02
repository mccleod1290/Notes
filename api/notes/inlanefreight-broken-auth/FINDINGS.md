# Lab findings — Broken Authentication

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Starting auth:** Customer `htbpentester3@hackthebox.com`  
**Tools:** curl, ffuf, pinchtab (Swagger screenshot)

## Confirmed issues

### 1) Weak password policy (update + accept)

| Check | Result |
|-------|--------|
| PATCH short password `pass` | 400: must be at least 6 characters |
| PATCH `123456` | **200** `successStatus: true` |
| OAS update DTO | Password minLength=6, **maxLength=6** (tiny keyspace) |

### 2) No rate limit on password spray (CWE-307)

| Check | Result |
|-------|--------|
| Fail body | `{"errorMessage":"Invalid Credentials"}` |
| ffuf ~10k attempts / account | No lockout / captcha observed |
| Hit | `IsabellaRichardson@gmail.com` / `qwerasdfzxcv` |

### 3) No rate limit on password-reset OTP (CWE-307 + low entropy)

| Check | Result |
|-------|--------|
| `POST …/passwords/resets/email-otps` | Success for any listed email |
| `POST …/passwords/resets/sms-otps` | Success |
| OTP space | 4-digit brute worked |
| Hit | OTP **`7526`** for `MasonJenkins@ymail.com` |
| After reset | Login with `123456` → JWT |

### 4) Account takeover impact — payment options flag

```json
"provider": "HTB Academy",
"accountNumber": "HTB{115a6329120e9eff13c4ec6a63343ed1}"
```

Endpoint: `GET /api/v1/customers/payment-options/current-user` as Mason.

## Related (not primary)

| Endpoint | Note |
|----------|------|
| `GET /api/v1/customers` | 107 customers; emails for spray; also BOPLA candidate |
| Roles on pentester3 | UpdateByCurrentUser, Get, GetAll |

## Evidence

```text
evidence/swagger-ui.png
evidence/current-user.json
evidence/roles.json
evidence/customers-all.json
evidence/login-fail.json
evidence/patch-pass-weak.json
evidence/patch-pass-123456.json
evidence/ffuf-IsabellaRichardson.json
evidence/ffuf-mason-otp4.json
evidence/mason-payment-options.json
evidence/mason-current-user.json
evidence/target-emails.txt
evidence/mason-cred.txt
```

JWTs in login JSON files are **`[REDACTED]`**.

## Operator runbook

[../../execution_batches/02-broken-authentication.md](../../execution_batches/02-broken-authentication.md)
