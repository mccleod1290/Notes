# 2 — Fingerprint: is this AEM?

**Goal:** Decide yes/no in under 5 minutes.  
**Signal of win:** AEM login page, clientlibs, or Sling-style JSON.

Replace `TARGET` with `https://example.com` (no trailing slash).

---

## Signal

You might already suspect AEM if you see:

- Paths like `/content/.../jcr:content`
- `/etc.clientlibs/` or `/etc/clientlibs/` in HTML
- Login at granite/core
- Headers or cookies mentioning `cq`, `sling`, `adobe`

---

## Why

AEM always ships the same **Adobe scaffolding**.  
Even custom sites leave fingerprints.  
If it’s AEM, you switch to AEM playbooks — not generic CMS fuzzing.

---

## Paste kit — confirm AEM

```bash
T="https://TARGET"

# 1) Login page (very common)
curl -sk -o /dev/null -w "%{http_code} %{url_effective}\n" \
  "$T/libs/granite/core/content/login.html"

# 2) Clientlibs proxy (modern)
curl -sk -o /dev/null -w "%{http_code}\n" \
  "$T/etc.clientlibs/clientlibs/granite/jquery.js"

# 3) Legacy clientlibs slash form (if this works, /etc may be readable more broadly)
curl -sk -o /dev/null -w "%{http_code}\n" \
  "$T/etc/clientlibs/granite/jquery.js"

# 4) Classic system console (often blocked; still a signal if 401/403 vs 404)
curl -sk -o /dev/null -w "%{http_code}\n" \
  "$T/system/console"

# 5) CSRF token endpoint
curl -sk -o /dev/null -w "%{http_code}\n" \
  "$T/libs/granite/csrf/token.json"

# 6) CRX / package manager
curl -sk -o /dev/null -w "%{http_code}\n" \
  "$T/crx/packmgr/index.jsp"
```

**How to read codes**

| Code | Meaning |
|------|---------|
| 200 + Adobe login HTML | Strong AEM |
| 401 / 403 on `/system/console` | Often AEM, locked down |
| 404 everywhere | Maybe not AEM, or hard fronting |

---

## Paste kit — grab any public page path

You need **one real page** for selector tests later.

```bash
T="https://TARGET"

# From homepage links / HTML
curl -sk "$T/" | grep -oE 'href="[^"]+"' | head -50

# Look for /content/... paths
curl -sk "$T/" | grep -oE '/content/[^"'\'' ]+' | sort -u | head -40
```

Save one working page, e.g.:

```text
PAGE=/content/site/us/en/home
# or full: PAGE=/content/we-retail/us/en
```

---

## Paste kit — version / about (if listParagraphs still works)

Some instances still expose version via selector gadget (older / misconfigured):

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"   # any cq:Page path that 200s as .html

curl -sk "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/granite/ui/components/shell/help/about/about.jsp&limit=1"
```

If you get version/build info → AEM confirmed + useful version note.

---

## AEM Forms fingerprint (separate product)

```bash
T="https://TARGET"

curl -sk -o /dev/null -w "%{http_code}\n" "$T/lc/libs/livecycle/core/content/login.html"
curl -sk -o /dev/null -w "%{http_code}\n" "$T/edcws/"
curl -sk -o /dev/null -w "%{http_code}\n" "$T/adminui/"
curl -sk -o /dev/null -w "%{http_code}\n" "$T/FormServer/"
```

If those hit → open [08-aem-forms.md](./08-aem-forms.md).

---

## Variations (time-box)

| Time | Do |
|------|----|
| 2 min | login.html + clientlibs + homepage `/content` grep |
| 10 min | Full path list above + Forms paths |
| Stuck | Google `site:TARGET "etc.clientlibs"` / check HTTP history |

---

## Done when

- [ ] Yes/No: AEM publish (or Forms)  
- [ ] Saved at least one `/content/...` page path  
- [ ] Noted author host if separate subdomain (`author.`, `aem-author.`, etc.)

**Next:** [03-sling-urls.md](./03-sling-urls.md) then [04-dispatcher-bypasses.md](./04-dispatcher-bypasses.md)
