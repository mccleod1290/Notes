# Batch 03 — Session lifecycle

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Finish **6 checks**: Session Storage / Local Storage, Broken Session Management, Session Fixation, Session Timeout, Back and Refresh Attack, Cookies Expire Time.

## TIME
1–2 hours

## YOU NEED
- Two browser profiles or normal + private window
- DevTools → Application → Cookies / Storage

---

## WHY (30 seconds)

**Session** = how the app remembers “you are Alice.”  
If the token is stealable, fixable by attacker, never expires, or stays after logout, account takeover becomes easy.  

**localStorage / sessionStorage** = JS-readable; XSS steals them.  
**HttpOnly cookies** = JS cannot read (better for session id).  
**Fixation** = attacker sets session id **before** login; victim logs in; attacker reuses same id.  
**Timeout** = idle / absolute session lifetime.  
**Back/Refresh** = sensitive page from cache after logout.  
**Cookie Expires** = forever cookies = forever theft window.

---

## DO THIS

### A) Session Storage and Local Storage

1. Login.  
2. DevTools → Application → Local Storage / Session Storage.  
3. Note tokens: `access_token`, `jwt`, `user`, etc.  
4. If **session id / JWT in storage** → XSS impact = full ATO (mention in XSS reports).  
5. Check if sensitive PII stored (SSN, full card) → data exposure.

### B) Broken Session Management (basic)

1. Login → copy session cookie / Authorization header.  
2. Logout in UI.  
3. Replay old cookie/token to `/api/me` or account page.

```bash
curl -sk "https://TARGET/api/me" -H "Cookie: SESSION=oldvalue"
curl -sk "https://TARGET/api/me" -H "Authorization: Bearer oldjwt"
```

**Win:** still 200 with your data after logout (server did not kill session).

4. Login twice (two browsers) with same user → both valid? (sometimes OK) → can you kill other sessions?

### C) Session Fixation

1. Get session id **before** login (cookie set on landing).  
2. Note value `SESS=attackerchosen` if you can set it (or use the pre-login id).  
3. Victim (you) logs in **with that same id** still present.  
4. After login, does session id **stay the same**?

**Win:** id unchanged across login → attacker who planted id rides victim session.

### D) Session Timeout

1. Login. Note time.  
2. Idle **without requests** for claimed timeout (e.g. 15–30 min) — or shorter if docs say.  
3. Hit authenticated page.  
4. Also test **absolute** long life: leave cookie for hours/days.

**Win:** still valid far beyond policy / forever.

### E) Back and Refresh Attack

1. Login → visit sensitive page (account, transfer confirm).  
2. Logout.  
3. Browser **Back** (and Refresh).  

**Win:** sensitive content or resubmit of state-changing POST without re-auth.

### F) Cookies Expire Time

1. DevTools → Cookies → for session cookie note:

```text
Expires / Max-Age
```

2. Session cookie should be **Session** (no long Expires) or short Max-Age.  
3. “Remember me” may be long — then must be rotatable / revoke on password change.

```bash
curl -skI "https://TARGET/login" | grep -i set-cookie
```

**Win:** auth cookie `Expires` years ahead without need.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| JWT in localStorage | Pair with XSS batch 01 |
| Logout does not kill | High session mgmt issue |
| Fixation works | Auth design bug |

---

## NEXT
→ [04-authz-cookies-rate-limit.md](./04-authz-cookies-rate-limit.md)
