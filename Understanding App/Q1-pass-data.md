# Q1 — How does the app pass data?

The first question when looking at an application: **how does this app pass data?**

Bugs will be there — but if you do not know **where to put payloads**, you fail. This question is only about that: *what data moves between client and server, and where does it sit in the request?*

---

#### Two common shapes

**Resource + parameters**

```text
https://app.com/resource?parameter=value&param2=value
```

**RESTful path**

```text
https://app.com/route/resource/sub-resource/...
```

Most real apps are a mix: path IDs *and* query filters *and* a JSON body. You do not need a perfect label — you need to see **where each value lives**.

---

#### What “data” means here

Anything the client sends that influences the server’s decision or output:

| Kind | Examples |
|------|----------|
| Object / resource ids | user id, order id, doc id |
| Form / business fields | email, amount, search string, bio |
| Flow control | `next`, `redirect`, `callback`, `format` |
| Files | upload bytes + filename |
| Auth noise you’ll see constantly | cookies, `Authorization`, CSRF tokens |

You are not cataloging every header forever. You are noticing **what the feature actually depends on**.

---

#### Where to look in the proxy

Click any interesting action in the UI (search, save, share, upload). Open that request.

| Look here | What you’re asking |
|-----------|-------------------|
| **Method + path** | REST-style ids in the path? (`/users/42/orders/7`) |
| **Query string** | Named parameters after `?` |
| **Request body** | Form fields or JSON keys (most write actions live here) |
| **Content-Type** | form vs `application/json` vs multipart (upload) |
| **Cookies** | Session always; sometimes prefs / extra ids |
| **Headers** | `Authorization`, CSRF, sometimes `X-User-Id` / tenant headers |
| **Response** | New ids, URLs, tokens the *next* request will reuse |

**Nudge:** the address bar only shows path + query. The body is where SPAs hide most of the data — always open the request in Burp/Caido/gori, not just the browser URL.

**Nudge:** do 3–5 real features (login, view object, edit, search, upload if any). Patterns repeat fast; you do not need the whole site mapped first.

**Nudge:** if the same id shows up in the path *and* the JSON body, note both — the server might trust one you can edit.

---

#### Quick path to the answer

1. Use the app for a few minutes with the proxy on.  
2. For each feature you care about, write one line:

```text
[action] → [style: query / path / body / mix] → [important params]
```

Example:

```text
Search users  → query     → q, page, sort
View order    → path      → /orders/{id}
Update profile→ JSON body → name, bio, website
Invite member → JSON body → email, role_id
```

3. Circle values that look like **ids**, **URLs**, **free text**, or **filenames** — those are your first payload homes.  
4. Done with this node. Move to Q2 (users) once you can point at *where* ids and fields usually travel.

---

#### Connection: data passage → testing

| You see… | So you… |
|----------|---------|
| Params in query | Inject / tamper on those names |
| Ids only in the path | Swap path segments (IDOR starting point) |
| JSON body with many keys | Tamper keys; try extra keys the UI never sends |
| URL field (`callback`, `webhook`, `next`) | Open redirect / SSRF candidate |
| File upload multipart | Filename + body as separate inputs |

No deep theory required: **find the slot → change the value → observe**.

---

#### Answer sheet (Q1 only)

```text
Style(s):  query / REST path / JSON body / hybrid
Where ids live:  path | query | body | header
Where user input lives:  ...
First slots to tamper:  ...
```

---

#### Prompt (optional)

```text
From these proxy requests, answer only:
1) How does this app pass data? (query vs path vs body — be concrete)
2) Table: action | where data lives | param names
3) Top places I should put a payload first

[PASTE a few requests]
Keep it short. Authorized testing.
```

---

---

*Part of Understanding App — Big Questions for directed web app testing.*
