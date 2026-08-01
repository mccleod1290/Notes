# Heat Mapping

After the Big Questions, you know **how the app works**. Heat mapping answers: **where do I spend time first?**

Hot areas = harder to secure, new/changed, or gated (admin/paid). Test those endpoints before random parameter spray.

---

## Priority lenses (always on)

| Lens | What it means | Hunt first |
|------|----------------|------------|
| **Harder to secure** | Feature *must* accept dangerous shapes | Headers, **file handling**, **URL/path handling** |
| **New** | Less battle-tested code | New feature, redesign → **regression** on old paths |
| **Gated** | Fewer eyes, higher impact | Paid features, **admin** functions |

**Side note — do not miss**

- Changelog / “what’s new” / mobile-only APIs often = **New** without marketing noise.
- Admin on a different host or path prefix is still in play if in scope.
- “Harder to secure” is about **feature type**, not how modern the stack looks.

---

## 1. Uploads

Common enterprise surface: any upload of images or documents.

```text
Upload functions
├── Integrations (3rd party)
├── Self uploads → XSS
├── XML-based (doc / PDF) → SSRF, XSS, XXE
├── Image → XSS polyglot / shell-in-image, name, binary header, metadata
└── Where is data stored? → e.g. S3 / blob perms
```

Documents are often **XML under the hood** → XXE is in play even when the UI says “PDF/DOCX”.

**Side note — observe**

| Look | Why |
|------|-----|
| Response URL after upload | Public? Guessable? Auth on GET? |
| Filename reflected | XSS / path issues |
| Content-Type client vs server | Type confusion |
| Image re-processed or stored raw | Polyglot / metadata survival |
| 3rd-party scanner / antivirus / “preview” service | Extra SSRF / parse chain |
| Same upload API for avatar vs docs | Different validation paths |

---

## 2. Content-Types (proxy alert)

Not a “place in the app” — a **filter on traffic**. When you see these, slow down.

| See in proxy | Interest |
|--------------|----------|
| `multipart/form-data` | Uploads, shells, injections on parts + filename |
| `Content-Type: …xml` (req or res) | XXE, parser diffs |
| `Content-Type: …json` (req or res) | API authZ, mass assignment, inject in values |

**Side note — observe**

- Mismatch: UI sends JSON, alternate client sends XML (or `Content-Type` lie).
- `multipart` part headers (`Content-Type` per part, filename) ≠ body only.
- JSON arrays of objects → batch IDOR / mass assignment.

---

## 3. APIs

Many apps are a thin UI over APIs (REST, and often **GraphQL**). Heat from other sections often lands here.

```text
APIs
├── Hidden methods (OPTIONS / allow, or verb swap)
└── Lack of auth (unauthenticated access to sensitive data)
```

Today’s API bugs skew **auth / authZ** (who can pull data), less classic injection — still check both.

**Side note — observe**

| Look | Why |
|------|-----|
| Endpoints in JS not linked in UI | Hidden surface |
| Same route, different method | Hidden methods |
| `/api` vs `/graphql` without session | Lack of auth |
| Mobile / BFF host vs www | Weaker middleware |
| 200 + empty vs 403 vs 401 | Auth oracle |
| GraphQL introspection / field suggestions | Schema map |

---

## 4. Account section

Authenticated **profile / settings** is where personal data and integrations live.

```text
Account section
├── Profile → stored XSS (incl. blind XSS)
├── App custom fields → stored XSS, SSTI
└── Integrations → SSRF, XSS
```

Stored/blind XSS in profile fields is easy to under-test; integrations are URL-shaped by design.

**Side note — observe**

- Every field that **saves and re-renders** (name, bio, links, locale, markdown).
- Custom fields / “//metadata” / admin-defined attributes.
- Webhook URL, Slack/Teams, import-from-URL, avatar-from-URL.
- Where profile HTML is shown to **other users** or **staff** (blind XSS).

---

## 5. Errors (trigger, not a page)

Proxy **errors** tell you what the server parsed and disliked.

If a meta character or probe caused the error → that request is a candidate for deeper inject / **app-level DoS** (not just network flood).

```text
Errors
├── Exotic injection (weird parse / nested decode)
└── App DoS (expensive error / crash path)
```

**Side note — observe**

- Stack traces, SQL/template fragments, internal paths.
- 500 vs 400 vs WAF block — different layers.
- Same probe: one endpoint errors, sibling silently filters → weaker sibling.
- Logger in Burp/Caido: filter 5xx while browsing; don’t only hunt 200s.

---

## 6. Paths / URLs as values

Any param or route value that is a **path or URL** must be parsed → classic **SSRF** and **open redirect** territory.

```text
Paths or URLs passed as values
├── SSRF
└── Redirects (open redirect)
```

**Side note — observe**

| Names often hot | `url`, `uri`, `path`, `file`, `next`, `return`, `redirect`, `callback`, `webhook`, `target`, `dest`, `feed`, `src`, `link` |
| Path in route | `/preview?path=`, `/files/...`, proxy-image endpoints |
| Partial URLs | `//evil`, `@`, backslash, encoded dots — parser quirks |
| Server fetch vs browser redirect | SSRF vs open redirect (both heat) |

---

## How to run a heat map (short)

1. Finish Big Questions enough to know data slots, users, crown jewels, shields.  
2. Browse + proxy; **tag** requests that hit sections 1–6.  
3. Rank: **gated + harder-to-secure + new** first.  
4. For each hot request: one hypothesis → minimal test → note result.  
5. Demote cool surface (static marketing, well-locked read-only public pages).

### Heat log (copy per target)

| Rank | Area (upload/API/account/…) | Endpoint / feature | Lens (hard/new/gated) | First test | Result |
|------|----------------------------|--------------------|------------------------|------------|--------|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |

---

## Cheat card

| Heat | Bug gravity |
|------|-------------|
| Upload | XSS, XXE, SSRF, storage perms |
| multipart / XML / JSON in proxy | Inject, XXE, API authZ |
| API | Missing auth, hidden methods, GraphQL authZ |
| Account / integrations | Stored/blind XSS, SSTI, SSRF |
| Errors | Inject foothold, app DoS |
| URL/path params | SSRF, open redirect |

**Understand:** heat mapping is **prioritization**, not a new vuln class. It spends attention where the app is forced to be weak or where fewer people test.

---

*After Understanding App (Big Questions). Heat = where to test first.*
