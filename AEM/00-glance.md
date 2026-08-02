# 0 — Glance card (whole AEM fight in one screen)

Replace `TARGET` with the site. Authorized only.

---

## Picture in your head

```text
  YOU (internet)
       │
       ▼
  ┌─────────────┐
  │  WAF (maybe)│   ← optional extra wall
  └──────┬──────┘
         ▼
  ┌─────────────┐
  │ DISPATCHER  │   ← Apache/IIS reverse proxy
  │ (bouncer)   │     "you can't go to /bin/..."
  └──────┬──────┘
         ▼
  ┌─────────────┐
  │ AEM PUBLISH │   ← real app + big database of "nodes"
  │  (Sling)    │
  └─────────────┘

Also exists (often NOT public):
  AEM AUTHOR  ← where employees edit pages (goldmine if reachable)
```

**Dispatcher is a bouncer, not a vault.**  
It looks at the URL *path line* only. It often **misunderstands** weird Sling URLs.  
If the bouncer is confused, the **real app still answers**.

---

## What you want

| Gold | Why |
|------|-----|
| `/bin/querybuilder.json` | Search the whole content DB |
| `/*.infinity.json` or `/*.3.json` | Dump node trees as JSON |
| `/etc/packages` | Customer code + secrets in zips |
| `/content/...` confidential docs | PII, drafts, internal files |
| Login / OSGi console | Sometimes default or leaked creds |

---

## 60-second kill chain

```text
1. Is it AEM?          → 02-fingerprint.md
2. Open a real page path under /content/...
3. Try dispatcher bypasses on querybuilder → 04
4. If querybuilder works → loot → 05 + 07
5. Try selector gadgets → 06
6. Check AEM Forms paths → 08
7. Modern checks / hopgoblin → 09
```

---

## Super short “why AEM is weird”

Normal website:

```text
/about/team.html  →  one file, one handler
```

AEM (Sling):

```text
/about/team.listParagraphs.html?foo=1/extra/path

path      = /about/team
selector  = listParagraphs     ← extra switch
extension = html
suffix    = /extra/path          ← extra path after extension
```

Selectors and suffixes are **attack surface most hunters never touch**.

---

## Permissions footgun

- Unauthenticated visitor = user named **`anonymous`**
- `anonymous` is in group **`everyone`**
- Anything granted to “everyone” is also free to the internet  
→ bad ACLs = free secrets

---

## Tools (optional, not required)

| Tool | Role |
|------|------|
| `curl` | Everything below works with curl |
| [aem-hacker](https://github.com/0ang3el/aem-hacker) | Classic enum (0ang3el) |
| hopgoblin (Assetnote/Searchlight) | Modern checks + mutations |
| ffuf / nuclei | Mass path / selector probes |

---

Next: [01-what-is-aem.md](./01-what-is-aem.md)
