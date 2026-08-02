# Batch 04 — Cookies, lockout, rate limit, IDOR / privilege

## GOAL
Finish **6 checks**: Cookie Vulnerabilities, Weak Lockout, Rate Limit, Horizontal Priv Esc, Vertical Priv Esc, IDOR.

## TIME
1–2 hours

## YOU NEED
- **Two accounts** same role (A, B) for horizontal / IDOR  
- One **low** + one **high** role if testing vertical  
- Cookie jar from login

---

## WHY (30 seconds)

**Cookie flags** = browser rules (HTTPS only, no JS, CSRF-ish SameSite).  
**Lockout / rate limit** = stop password spray and OTP brute.  
**IDOR** = change `id=7` to `id=8` and see **B’s** data.  
**Horizontal** = same role, other user’s objects.  
**Vertical** = user reaches admin action.

These pay more than “missing header” noise. Use batch 00 path list + both sessions.

---

## DO THIS

### A) Cookie Vulnerabilities

For each `Set-Cookie` on login:

| Flag | Want |
|------|------|
| `Secure` | yes (HTTPS sites) |
| `HttpOnly` | yes on session id |
| `SameSite=Strict` or `Lax` | yes (None only if needed + Secure) |
| `Path` / `Domain` | not overly wide (`.company.com` risk) |
| `__Host-` prefix | best practice if used |

```bash
curl -skI "https://TARGET/login" -X POST -d '...' | grep -i set-cookie
```

Also: cookie readable from JS? (no HttpOnly) → XSS steals session.

### B) Weak Lockout Account Mechanism

1. Pick test account (not prod admin).  
2. Send **wrong password** 10–30 times fast:

```bash
for i in $(seq 1 30); do
  curl -sk -o /dev/null -w "%{http_code}\n" -X POST "https://TARGET/login" \
    -d "user=testuser&pass=WrongPass$i"
done
```

3. Then try **correct** password.

**Win:** never locks / no slowdown / lockout easy to bypass (reset counter via other IP, X-Forwarded-For).

Try:

```http
X-Forwarded-For: 1.2.3.4
```

### C) Rate Limit (login, OTP, reset, API)

Same idea on:

```text
/login  /forgot-password  /mfa/verify  /api/expensive
```

**Win:** hundreds of tries with no 429 / captcha / backoff.

### D) IDOR (object IDs)

1. As user A, capture request with object id:

```http
GET /api/invoices/1001
```

2. As user B (or A with B’s id):

```http
GET /api/invoices/1002
```

3. Also try:

```text
1001 → 1000, 999, 1, 0, -1, 1001%00, ../1002
UUID sequential? create two objects and compare
```

4. Body/JSON IDs, not only URL.

**Win:** A reads/edits B’s object.

### E) Horizontal Privilege Escalation

Same role, other user’s **functions**:

- change B’s email while logged as A  
- list B’s messages  
- share links without authz  

Use two cookies; swap only the object owner fields.

### F) Vertical Privilege Escalation

1. Map admin paths from batch 00 (`/admin`, `/api/admin`, role=admin in JWT).  
2. As normal user, call admin APIs:

```bash
curl -sk "https://TARGET/api/admin/users" -H "Cookie: session=USERSESSION"
```

3. Tamper JWT/cookie `role=user` → `role=admin` (see batch 09 for JWT).  
4. Hidden parameters: `isAdmin=true`, `role=1`.

**Win:** admin action succeeds as low user.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| IDOR on money/PII | High — solid report |
| No second account | Ask for one; cannot full-test horizontal |
| Lockout missing | Medium (account takeover assist) |

---

## NEXT
→ [05-injection-core.md](./05-injection-core.md)
