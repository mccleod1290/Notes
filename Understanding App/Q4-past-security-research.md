# Q4 — Past security research & vulns?

**Has there been past security research & vulns?**

You are rarely first. Public writeups and disclosed bounty reports show **which assumptions already failed** on this product, vendor, or stack. Steal the *thinking* (bug class + root cause), then re-test on *your* in-scope target — do not copy private or out-of-scope work.

#### What to look up (quick)

| Source | Example of what you want |
|--------|---------------------------|
| Bounty disclosed / Hacktivity | Same vendor: XSS, IDOR, smuggling, … |
| Researcher blogs / writeups | “We found DOM XSS on …” — pattern, not PoC copy-paste |
| CVE / advisories | Version you fingerprinted |
| Stack searches | `laravel xss`, `rails csrf bypass`, `nextjs ssrf` |

#### Search starters

```text
"[product]" (XSS OR IDOR OR SSRF OR "account takeover")
"[framework]" (xss OR csrf OR bypass OR sanitiz)
site:hackerone.com [vendor]
site:github.com/advisories [component]
```

#### How this steers hunting

1. Fingerprint stack (headers, cookies, error pages, JS paths, `/wp-json`, etc.).  
2. Search product **and** framework for that vuln class.  
3. Note **root cause** (e.g. reflected in payment page, weak sanitizer, missing CSRF on API).  
4. Ask: does *this* app have the same feature shape? If yes → put it on the queue.

Read for patterns, not only PoC URLs.

#### Checklist

- [ ] Disclosed reports / CVEs for this vendor or product?
- [ ] Framework writeups for XSS, CSRF, validation, encoding bypasses?
- [ ] Same bug **class** on another asset of the same org?
- [ ] Themes turned into 3–5 concrete tests on my target?

#### Prompt — prior art

```text
Authorized testing on: [product/vendor], stack: [...], versions: [...]

1. Public historical vuln themes only (no private data).
2. Group by bug class + root cause.
3. Turn each theme into tests on MY instance.
4. Known framework protection bypasses worth trying.

Keep short. Methodology, not exploit spam.
```

---

---

*Part of Understanding App — Big Questions for directed web app testing.*
