# 2019 Batch 03 — API4: Lack of Resources & Rate Limiting

> **2023 note:** Expanded into [API4 Unrestricted Resource Consumption](../../execution_batches/04-unrestricted-resource-consumption.md).  
> **2019 focus:** missing **rate limits / quotas / execution limits** (not only disk size).

## FILL IN

```bash
BASE="https://api.example.com"
# Expensive or auth endpoints
LOGIN="/api/v1/authentication/.../sign-in"
SMS_OTP="/api/v1/.../sms-otps"
SEARCH="/api/v1/.../search"
```

## GOAL
Prove the API accepts **unbounded request volume** (or unbounded work per request) without 429 / backoff / quota.

## WHY (first principles)

| Limit type | Failure mode |
|------------|--------------|
| Requests / IP / user | Brute force, SMS $ burn, scrape |
| Payload size | Disk/CPU (also URC 2023) |
| Complexity | GraphQL depth, regex, report gen |
| Concurrency | Worker exhaustion |

2019 wording stresses **rate limiting** as the missing control; 2023 names **resource consumption** (same family, broader).

## DO THIS

### 1) Inventory expensive endpoints

Login, OTP SMS/email, search, export, upload, password reset, invite.

### 2) Burst authenticated or unauth

```bash
# Login fails — expect 429 after N (often never comes)
for i in $(seq 1 50); do
  curl -sk -o /dev/null -w "%{http_code} " -X POST "$BASE$LOGIN" \
    -H 'Content-Type: application/json' \
    -d '{"Email":"x@y.com","Password":"wrong"}'
done; echo
```

### 3) Paid side-effects

```bash
for i in $(seq 1 20); do
  curl -sk -X POST "$BASE$SMS_OTP" -H 'Content-Type: application/json' \
    -d '{"Email":"victim@example.com"}'
done
```

**Finding if:** no 429, no CAPTCHA, no cooldown; OAS admits cost per call.

### 4) Operator log

```text
Endpoint:
Burst size:
Status codes sequence:
Rate-limit headers (Retry-After)?
Business cost:
```

## EDGE CASES

| # | Test |
|---|------|
| E1 | Per-IP vs per-account limits |
| E2 | Header spoofing `X-Forwarded-For` |
| E3 | GraphQL batch aliases |
| E4 | 429 missing body but soft throttle |
| E5 | Upload size limit yes, request rate no |

## Prevention

Gateway rate limits; per-tenant quotas; CAPTCHA/step-up; cost alerts; circuit breakers.

## WORKED EXAMPLE (lab)

- SMS OTP flood → flag in URC notes  
- Login failures all `200` + error body, **no 429** (`rate-login-fails.txt`)  
→ `../../notes/inlanefreight-resource-consumption/` + `../notes/inlanefreight-2019-suite/evidence/`
