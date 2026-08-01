# Bug-class session questions

One class per focused block (30–90 min). Answer questions **before** and **during** testing. If you can’t answer the “before” set, do recon first — don’t spray payloads.

Authorized only.

---

## How to use

```text
1. Pick class
2. Answer "Before" (5 min)
3. Run "During" checklist
4. Write "Exit" 3 lines in Notes
```

---

## IDOR / BOLA / broken object authZ

### Before
1. What **objects** exist (order, file, message, invoice)?  
2. How is each **identified** (int, uuid, email, slug)?  
3. Where does the id appear (path / query / body / header)?  
4. Do I have **two users** (and two tenants if SaaS)?  
5. What is the **impact** of reading vs writing vs deleting that object?  

### During
- [ ] A’s id with A’s session (baseline)  
- [ ] B’s id with A’s session (horizontal)  
- [ ] Admin-only object with user session (vertical)  
- [ ] Other tenant’s id (cross-tenant)  
- [ ] Create → guess neighbor ids / list leak → access  
- [ ] Encoded id tamper (b64, hex)  
- [ ] Change id **and** method (GET detail vs DELETE)  
- [ ] Nested ids in arrays  

### Exit
```text
Objects tested:
Worked?: 
Evidence req id:
```

---

## XSS (reflected / stored / DOM)

### Before
1. Where does user input **return** in HTML/JS?  
2. Encoding / CSP / sanitizer present?  
3. Who **views** stored fields (self, others, admin)?  
4. Any rich text / markdown / file name reflection?  

### During
- [ ] Reflected: every param/body field once with simple probe  
- [ ] Context: HTML body, attribute, JS string, URL  
- [ ] Stored: profile, comments, tickets, filenames  
- [ ] DOM: hash/query → JS sink (read JS, don’t only black-box)  
- [ ] Blind: admin-only views, email HTML, PDF  
- [ ] CSP bypass only if CSP blocks a real sink  

### Exit
```text
Sink:
Context:
Stored viewers:
Blocked by:
```

---

## SSRF

### Before
1. Which features take a **URL** or host?  
2. Does server **fetch** or only redirect browser?  
3. Canary domain ready?  
4. Cloud metadata relevant to host?  

### During
- [ ] Basic external canary hit  
- [ ] Redirect follow  
- [ ] IP literals, decimal/ipv6 tricks (if filter)  
- [ ] `file://` / internal hosts only if in scope  
- [ ] DNS rebinding class only with care  
- [ ] Attach to webhook, preview, import, PDF, OOXML  

### Exit
```text
Feature:
Out-of-band hit?:
Internal proof?:
```

---

## SQLi / NoSQLi

### Before
1. Which params hit **list/filter/search/sort**?  
2. Error-based oracles exist?  
3. ORM likely vs raw SQL feature?  

### During
- [ ] Quote / boolean baseline  
- [ ] Time-based only if needed (gentle)  
- [ ] JSON/NoSQL operators if Mongo-like  
- [ ] Second-order (store then trigger)  
- [ ] Order-by / limit inject  

### Exit
```text
Param:
DB guess:
Data extractable?:
```

---

## Authn / session

### Before
1. How is session established (cookie, JWT, API key)?  
2. Reset / register / OAuth flows in scope?  
3. MFA?  

### During
- [ ] Enumerate usernames carefully  
- [ ] Token entropy / predictability  
- [ ] Logout invalidation  
- [ ] Cookie flags  
- [ ] JWT classic checks  
- [ ] OAuth redirect_uri / state  

### Exit
```text
Weakest auth link:
Account impact:
```

---

## CSRF

### Before
1. Cookie session or Bearer-only?  
2. State-changing requests from browser?  
3. Token / SameSite evidence?  

### During
- [ ] Replay without CSRF token  
- [ ] Token reuse / swap  
- [ ] Content-Type tricks  
- [ ] SameSite=None cases  

### Exit
```text
Endpoint:
Browser-exploitable?:
```

---

## File upload

### Before
1. What types allowed? Client vs server check?  
2. Where stored (URL pattern)?  
3. Executed or only downloaded?  

### During
- [ ] Extension / MIME / magic bytes  
- [ ] Path / filename inject  
- [ ] XSS in SVG/HTML  
- [ ] XXE in office/XML  
- [ ] Overwrite / unauth read of URL  

### Exit
```text
Stored URL:
Dangerous type in?:
```

---

## XXE

### Before
1. Any XML body, SOAP, office, SAML, RSS?  
2. External entities blocked?  

### During
- [ ] Classic entity file read (lab-safe paths)  
- [ ] OOB if blind  
- [ ] Billion laughs only if DoS allowed  

### Exit
```text
Parser entry:
File/OOB proof:
```

---

## Open redirect

### Before
1. Redirect params on login/oauth/logout?  
2. Token in URL after redirect?  

### During
- [ ] External domain  
- [ ] `//evil`, encoded, backslash  
- [ ] Chain to OAuth token theft if applicable  

### Exit
```text
Param:
Allows external?:
```

---

## SSTI

### Before
1. Input rendered into **templates** (mail, PDF, profile)?  
2. Engine guess (Jinja, Twig, FreeMarker…)?  

### During
- [ ] Math probe `{{7*7}}` / `${7*7}` etc.  
- [ ] Blind via time/error  
- [ ] Stop at proof unless RCE in scope  

### Exit
```text
Sink:
Engine:
```

---

## Business logic / race

### Before
1. Multi-step money or entitlement flows?  
2. What must never happen twice?  

### During
- [ ] Skip step via API  
- [ ] Replay  
- [ ] Parallel requests (2–5 threads)  
- [ ] Parameter tamper price/role/qty  

### Exit
```text
Flow:
Broken invariant:
```

---

## Mass assignment / BOPLA

### Before
1. JSON update endpoints?  
2. Hidden fields in models (role, balance)?  

### During
- [ ] Add `role`, `admin`, `verified`, `balance`  
- [ ] Compare response/GET after PATCH  
- [ ] GraphQL mutations extra fields  

### Exit
```text
Field accepted?:
Impact:
```

---

## GraphQL (if present)

### Before
1. Introspection on?  
2. Auth on queries vs mutations?  

### During
- [ ] Introspection map  
- [ ] IDOR on node ids  
- [ ] Nested query cost  
- [ ] Batch / alias abuse  
- [ ] Field suggestions as oracle  

### Exit
```text
Schema leak?:
AuthZ gap:
```

---

## AI / LLM feature (if present)

### Before
1. Tools/MCP? RAG sources?  
2. What must not leave the system prompt?  

### During
- [ ] Prompt leak class (see [[ai-pentest-resources]])  
- [ ] Indirect injection via retrieved content  
- [ ] Tool call without confirm  

### Exit
```text
Leak confidence:
Tool abuse:
```

---

## Universal exit (every session)

```text
Class:
Time spent:
Requests that matter (ids):
Finding? y/n → F-id:
Dead end lesson:
Next class or retry:
```
