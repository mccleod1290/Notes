# 1 — What is AEM? (explain like I’m 15)

**AEM** = Adobe Experience Manager.  
Big companies use it to build websites and store **all the content** (pages, images, PDFs, forms) in one system.

You do **not** need to be an AEM developer. You need three ideas.

---

## Idea 1: It’s a CMS with a giant folder tree

Everything is a **node** (like a folder or file in a tree):

```text
/
├── content/          ← the website pages people see
│   └── dam/          ← images, PDFs, uploads (“Digital Asset Management”)
├── apps/             ← customer's custom code
├── libs/             ← Adobe's built-in code (normally not for public)
├── etc/packages/     ← ZIP packages used to deploy code
├── home/             ← users
└── bin/              ← special URLs (APIs / servlets)
```

**Mental model:**  
Not “one PHP file per page.”  
More like “a big SharePoint / Dropbox tree that can *run code* when you request a path.”

---

## Idea 2: Three machines, not one

| Piece | Simple job | You usually hit? |
|-------|------------|------------------|
| **Author** | Staff edit pages here | Rarely public (if it is → jackpot) |
| **Publish** | Serves the public site | Yes |
| **Dispatcher** | Cache + bouncer in front of Publish | Always first |

```text
Editors → Author → (replicate) → Publish ← Dispatcher ← Internet (you)
```

Publish and Author are almost the **same software**.  
Only config differs. So Publish often still has dangerous APIs — the dispatcher is supposed to hide them.

---

## Idea 3: Two “flavors”

| Flavor | Simple meaning | Hunt note |
|--------|----------------|-----------|
| **AMS / on‑prem / “classic”** | Customer (or Adobe AMS) runs the servers | More misconfigs, more RCE history |
| **AEM as a Cloud Service** | Adobe SaaS | Harder RCE, still misconfig / info leak / XSS |

**AEM Forms** is a *related product* (forms / LiveCycle family).  
Can sit with AEM **or** as **standalone JBoss/J2EE**. Different bugs — see [08-aem-forms.md](./08-aem-forms.md).

---

## Why hunters love AEM

1. **Dispatcher lies** — blocked URL ≠ missing feature.  
2. **Weird URLs** (selectors) open hidden code.  
3. **One good API** (`querybuilder`) can dump huge trees.  
4. **Packages** may hold source + passwords.  
5. **Authors stash secrets** under `/content` “temporarily.”

---

## Words you’ll see (cheat sheet)

| Word | Means |
|------|--------|
| **JCR** | The content database (tree of nodes) |
| **Sling** | The web framework that maps URL → node → code |
| **Servlet** | A Java endpoint that handles a request |
| **resourceType** | Tag on a node saying “render me with this code” |
| **clientlibs** | Bundled JS/CSS (`/etc.clientlibs/...`) |
| **CRX / packmgr** | Package manager UI for installing zips |

---

Next: [02-fingerprint.md](./02-fingerprint.md)
