# Batch 01 — Confirm AEM + one page path

## objective

Decide if the target is Adobe Experience Manager, and save **one real** `/content/...` (or equivalent) page path you can reuse later. No exploits yet.

## estimated_time

45–90 minutes

## prerequisites

- In-scope URL (`TARGET`)
- `curl` available
- Written permission to test

## testing_workflow

### 1) Set target

```bash
T="https://TARGET"   # no trailing slash
```

### 2) Hit AEM fingerprints (2–3 techniques only)

```bash
# Technique A — Granite login
curl -sk -D- -o /tmp/aem-login.html -w "login:%{http_code}\n" \
  "$T/libs/granite/core/content/login.html" | head -20
head -c 400 /tmp/aem-login.html; echo

# Technique B — clientlibs (modern dotted form)
curl -sk -o /dev/null -w "clientlibs_dot:%{http_code}\n" \
  "$T/etc.clientlibs/clientlibs/granite/jquery.js"

# Technique C — legacy slash clientlibs (extra signal)
curl -sk -o /dev/null -w "clientlibs_slash:%{http_code}\n" \
  "$T/etc/clientlibs/granite/jquery.js"
```

Optional extras only if A/B/C are all 404:

```bash
curl -sk -o /dev/null -w "console:%{http_code}\n" "$T/system/console"
curl -sk -o /dev/null -w "csrf:%{http_code}\n" "$T/libs/granite/csrf/token.json"
curl -sk -o /dev/null -w "packmgr:%{http_code}\n" "$T/crx/packmgr/index.jsp"
```

### 3) Grab one content path from the public site

```bash
curl -sk "$T/" -o /tmp/home.html
grep -oE '/content/[^"'\'' <>]+' /tmp/home.html | sort -u | head -40
```

Pick **one** path that looks like a real page (not only an asset). Save it:

```bash
PAGE="/content/site/us/en/home"   # replace with yours
# Verify it responds
curl -sk -o /dev/null -w "page_html:%{http_code}\n" "$T${PAGE}.html"
curl -sk -o /dev/null -w "page_bare:%{http_code}\n" "$T${PAGE}"
```

### 4) Quick Forms smell (do not deep-dive)

```bash
curl -sk -o /dev/null -w "forms_login:%{http_code}\n" \
  "$T/lc/libs/livecycle/core/content/login.html"
curl -sk -o /dev/null -w "FormServer:%{http_code}\n" "$T/FormServer/"
```

Note yes/no for Forms. Full Forms work is batch 12+.

### 5) Write session output (3 lines)

```text
AEM: yes/no/maybe
PAGE=...
Forms_hint: yes/no
```

## decision_points

| If… | Then… |
|-----|--------|
| Login or clientlibs clearly AEM | Continue to **batch 02** |
| Only weak signals (random 403s) | Re-check HTML for `etc.clientlibs`, `cq`, `sling` in source; if still no → **stop AEM track** |
| Author host found (`author.`, `aem-`) | Record it; still finish this batch on publish first |
| Forms paths 200 | Flag for batch 12 after batch 02–03 |

## expected_findings

- Confirmed AEM (login HTML, clientlibs, CRX, cookies)
- One reusable `PAGE` path
- Optional: separate author hostname; Forms presence flag

## next_batch_to_continue_with

→ **[02-json-node-dumps.md](./02-json-node-dumps.md)**

If not AEM → leave this kit; do not force later batches.
