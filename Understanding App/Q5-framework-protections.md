# Q5 — Framework / app protections (and where they fail)

When you look at an app, ask:

> How does this web application **framework** (and the app’s own middleware) protect against common vuln classes — and have there been **bypasses**?

Classic controls people mean here:

| Control | Job (plain language) |
|---------|----------------------|
| **Output encoding / escaping** | Dangerous characters become safe when printed as HTML |
| **Input validation** | Reject or limit bad shapes before use |
| **CSRF tokens / SameSite** | Browser must prove the action came with the real session |
| **XSS defenses** | Encoding + CSP + sanitizers for any HTML you allow |
| *(also)* ORM/parameterized queries, authZ middleware, etc. | Same idea: default shield for a class |

#### Step 1 — What shield is *supposed* to be on?

Fingerprint the stack, then search how it protects by default (same spirit as Q4):

```text
[framework] xss protection
[framework] csrf
[framework] output encoding
[framework] xss bypass
```

In the **proxy**, evidence the shield exists:

| Look at | Possible sign of protection |
|---------|-----------------------------|
| Cookies | `HttpOnly`, `Secure`, `SameSite` |
| Forms / headers | CSRF token name + matching header/body |
| Response headers | `Content-Security-Policy`, `X-Frame-Options`, HSTS |
| HTML source | Encoded output (`&lt;` instead of raw `<`) |
| Stack docs / defaults | e.g. auto-CSRF on cookie sessions |

**Missing header ≠ free finding.** **Present control ≠ safe.** You still ask the two questions below.

#### Step 2 — Where CAN’T these protections work?

Some features **must** accept dangerous-shaped input. The default shield cannot fully apply without breaking the feature.

| Feature (from real apps) | Why the normal shield struggles | What you hunt |
|--------------------------|--------------------------------|---------------|
| **Webhook URL** form | Must accept a URL the server will call | SSRF, open redirect chains |
| **Rich text / “Submit article”** editor | Must allow some HTML or markdown | Stored XSS, sanitizer bypass |
| File upload | Must store raw bytes | Malicious file, path, stored XSS |
| OAuth `redirect_uri` / login `next=` | Must redirect somewhere | Open redirect → token theft |
| Export / report / search DSL | Must take flexible filters | Injection if not parameterized |
| “Preview as HTML” / PDF renderers | Must interpret markup or URLs | XSS, SSRF |

**Nudge:** when the UI *requires* a URL or rich HTML, do not assume “framework XSS protection” covers it. That feature is a **designed gap**.

#### Step 3 — Where might protections have been *skipped*?

Even when the shield *could* apply, teams leave it off on some paths:

| Often weaker | Why |
|--------------|-----|
| JSON **API** / mobile clients | CSRF model differs from browser forms; authZ bugs too |
| **Webhooks** / inbound callbacks | Separate auth, no session CSRF |
| **Admin** or legacy v1 routes | Old code, “internal only” |
| Error pages, file download, exports | Different middleware pipeline |
| Third-party widgets / payment iframes | Other origin’s rules (still chainable) |

**Nudge:** protection on the main HTML app does not mean the same for `/api/v1/...` or an old subdomain.

#### Quick path (answer this node in 20 minutes)

1. Name the stack (or “unknown SPA + API”).  
2. List shields you **see** evidence for (CSRF cookie, CSP, encoding).  
3. List features that **can’t** use full shields (webhook, editor, upload, redirect).  
4. List routes that might **skip** middleware (API, admin, webhooks).  
5. Hunt queue = (gaps ∪ skips ∪ known bypasses from Q4).

#### Answer sheet (Q5)

```text
Stack:
Shields present (evidence):
Can't fully protect (features):
Likely skipped (routes):
Bypass / hunt ideas:
```

#### If you learn X → test Y

| Learn | Test |
|-------|------|
| Strong CSP + sanitizer on main UI | API JSON, PDF, mobile, error pages |
| CSRF on forms only | Bearer API state-changing routes |
| Webhook URL field | SSRF |
| Rich text / article editor | Stored XSS, mXSS, markdown |
| ORM on CRUD, raw SQL on search | Injection on search/export |
| “We use Laravel/Rails so we’re safe” | Feature gaps + known bypass writeups (Q4) |

#### Prompt — protections

```text
Authorized testing. Stack/recon:
[PASTE headers, cookies, CSP, forms, framework clues]

Features: [webhooks, rich text, upload, OAuth, …]

Answer only:
1) What protections appear present (with evidence)?
2) Where CAN'T they work on this app?
3) Where might they be skipped?
4) Short hunt list (field/route + bug class).

No generic OWASP essay.
```

---

---

*Part of Understanding App — Big Questions for directed web app testing.*
