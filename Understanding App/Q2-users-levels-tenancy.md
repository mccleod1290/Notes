# Q2 — Users: how / where, levels, and tenancy

One node for everything about **people and orgs** in the app:

1. **How / where** does it talk about users? (identifiers + proxy slots)  
2. **User levels** — roles and privilege  
3. **Tenancy** — one customer’s world vs many  

Access, authorization, logic, and disclosure all hang off this node.

> Who does the server think I am? How does it find the other person?  
> Are we in the same org/tenant? What can my role do?

---

#### Part A — How / where does the app talk about users?

Understanding how users (you and others) are referenced — and **where** those references appear — is pivotal for Access, Authorization, Logic, and Information Disclosure bugs.

##### What “where” means (first principles)

**How** is the *label* for a person: `uid=42`, `email=a@b.com`, `username=bob`, a UUID, etc.

**Where** is not a different kind of user id. It is the **place in the traffic** that label shows up — the slot you open in the proxy when you ask “does this request mention a user?”

Think of the app as constantly saying “this is *me*” or “load *that person’s* stuff.” Those sentences have to be written somewhere in the HTTP message (or in the page that produced it). “Where does the app talk about users?” = **in which part of the message does that sentence appear?**

| Where (look here) | What “talking about users” looks like | Why it matters |
|-------------------|----------------------------------------|----------------|
| **Cookies** | Session cookie that *is* you; sometimes a cookie literally named `user_id` / prefs tied to a user | Server may treat cookie as identity; prefs can still carry ids |
| **API path** | `/users/42/...`, `/u/bob/settings` | The user is in the URL itself — easy to swap |
| **API query** | `?user_id=42`, `?email=` | Named param pointing at a user |
| **API body** | JSON `{"userId":"…"}` on create/update/share | Common IDOR surface — change the id, keep your session |
| **Headers** | `Authorization: Bearer …`, sometimes `X-User-Id` | Token often *encodes* who you are; custom headers may *assert* a user |
| **Inside JWT / session** | Claims like `sub`, `user_id`, `email` after you decode the token | How the app knows “me” even when the body never says it |
| **HTML / JS / hidden fields** | Profile links, `data-user-id`, bootstrap JSON in the page | Leak of *other* users’ ids you can reuse in API calls |

**How vs where (one line):**

```text
how  = what string means "this user"     →  42 | bob | a@b.com | uuid
where = which box in the proxy holds it  →  cookie | path | query | body | header | page
```

**Concrete:** you and Alice both exist.

- *How* Alice is named might be `uid=1007`.  
- *Where* the app mentions her might be only in `GET /api/messages?from=1007` (query), while *you* are only in the session cookie (never as a number in the body).  
- For testing: you need both — the **format** to try (`1007` vs email) and the **slot** to edit (that query param, not the cookie).

**“Talk about users” also splits two voices:**

| Voice | Question | Typical where |
|-------|----------|----------------|
| **Me** | How does the app know who *I* am? | Cookie, JWT/`Authorization`, rarely a body `user_id` the client is trusted to send |
| **Them** | How does the app point at *someone else*? | Path/query/body ids when you open a profile, share, message, admin panel |

Part A is answered when you can say: *users are referenced as ____ (how), and I see those references in ____ (where), for both me and other people.*

##### Model (identifiers + locations)

```text
Users
├── How (identifier)
│   ├── UID (sequential — enumerate)
│   ├── username
│   ├── email
│   └── UUID / opaque (harder enum; still swap)
└── Where (protocol location)
    ├── Cookies
    ├── API Calls (path, query, body, headers)
    ├── JWT / session claims
    └── Hidden fields / client storage
```

##### Checklist — how / where

- [ ] How am I identified after login? (session cookie, JWT, API key, …)
- [ ] How are other users referenced? (uid, uuid, email, username, slug)
- [ ] Do other users’ IDs appear in HTML, JS, emails, exports, notifications?
- [ ] Does the client send my user id (server trusts client), or only a session?
- [ ] Same ID format everywhere, or mixed (int admin vs uuid API)?
- [ ] Indirect refs? (order_id → owner, share token → user)

##### If you learn X → test Y (users)

| Learn | Test |
|-------|------|
| Sequential UIDs | Horizontal IDOR (±1, ranges, bulk) |
| UUID leaked in JS | Collect IDs from traffic; cross-account swap |
| `user_id` in body | Change to victim under your session |
| Email as object key | Swap email on share/reset flows |
| Only `/me` endpoints | Hunt `/users/{id}`, admin APIs, exports |

---

#### Part B — User levels (roles)

Does the site have **different user levels**?

That dictates how you test **vertical** authorization (can a low role do a high role’s action?).

##### Typical ladder (adapt)

```text
Users
├── App designed for multiple customers (tenants)   ← Part C
└── App has multiple user levels
    ├── Admin (CMS / framework / superuser)
    ├── Tenant / Account Admin
    ├── Tenant / Account User
    ├── Tenant / Account Viewer
    └── Unauthenticated functionality
```

##### Checklist — roles

- [ ] What roles exist in UI/docs/invite flow?
- [ ] Who can invite, bill, delete, export, admin?
- [ ] Can a lower role call higher-role APIs if they guess the URL?
- [ ] Unauth surfaces: register, share links, public profiles, inbound webhooks?

##### If you learn X → test Y (roles)

| Learn | Test |
|-------|------|
| Rich role matrix | Low-priv session → every admin-looking route |
| Invite / seats | Token reuse; role escalation on accept |
| Capability / share links | Guessable tokens; over-broad access |

---

#### Part C — Tenancy (first principles)

##### What a tenant is

Forget cloud jargon for a moment.

A **tenant** is a **hard wall around one customer’s world**: their users, their data, their config, their billing.

| | Single-tenant (classic) | Multi-tenant (typical SaaS) |
|--|-------------------------|------------------------------|
| Who shares the app? | Often one org per deploy | Many orgs on one deploy |
| Example | Your company wiki on your server | Slack / Notion / Azure AD app used by many companies |
| Isolation | Separate install or DB | Same app; software must enforce “you only see your org” |

**Multi-tenancy** means: Alice’s company and Bob’s company both use the *same* product instance, but Alice must not read Bob’s invoices by swapping an id.

**Not the same as roles.**  
- **Tenant** = which org’s data am I inside?  
- **Role** = what am I allowed to do *inside* that org?

You can be Admin of Tenant A and still must not see Tenant B.

##### How apps “select” the tenant

The server has to know **which wall you’re inside** on every request. That decision comes from something you can often see:

| Mechanism | What it looks like | Test smell |
|-----------|--------------------|------------|
| **Subdomain** | `acme.app.com` vs `globex.app.com` | Host header / wrong subdomain with your session |
| **Path** | `/t/acme/...`, `/orgs/{orgId}/...` | Swap `orgId` |
| **Header** | `X-Tenant-Id`, `X-Organization-Id` | Forge header (if app trusts client) |
| **JWT / session claim** | `tid`, `org_id`, `extension_tenantId` | Usually safer if server only trusts the token it issued |
| **Login picker** | “Choose workspace” then cookie | Workspace id in cookie/localStorage still worth noting |

##### How to figure tenancy out (any web app)

1. **Product shape** — Does signup create an “org/workspace/team”? Invite others to *your* workspace? → almost certainly multi-tenant.  
2. **UI language** — “Workspace”, “Organization”, “Directory”, “Account”, “Team”, “Subscription”.  
3. **Proxy after login** — Search history for `tenant`, `org`, `workspace`, `tid`, `accountId`, `directory`.  
4. **Two accounts** — Same email domain vs two companies; compare JWT claims and API paths.  
5. **Object ids** — If order `999` from tenant A is reachable while logged into tenant B, isolation failed (cross-tenant IDOR).

##### Checklist — tenancy

- [ ] Single-tenant product, multi-tenant SaaS, or hybrid?
- [ ] How is tenant selected? (subdomain, path, header, JWT claim)
- [ ] Can tenant A’s user touch tenant B’s objects by swapping IDs?
- [ ] Is tenant only in a client-controlled header/body? (trust smell)

##### If you learn X → test Y (tenancy)

| Learn | Test |
|-------|------|
| Multi-tenant + global object IDs | Cross-tenant IDOR first |
| Tenant only in client header | Spoof tenant marker (in scope) |
| Subdomain per tenant | Session from A on host of B |

---

#### Figuring tenancy on apps hosted in Azure

Azure confuses people because **“Azure AD tenant”** (Microsoft Entra ID directory) is not always the same as **“app multi-tenant SaaS tenant”** — but they often line up for enterprise apps.

##### Three different “tenants” you might see

| Meaning | What it is | Why you care |
|---------|------------|--------------|
| **Entra ID (Azure AD) directory tenant** | A company’s identity directory (`contoso.onmicrosoft.com`, GUID tenant id) | Login, tokens, who can sign in |
| **App registration multi-tenant** | App accepts logins from *many* Entra directories vs one | Account/org isolation at identity layer |
| **App’s own customer/workspace** | Product concept (billing account, team) stored in the app DB | Classic cross-tenant IDOR inside the product |

Always ask: *Is isolation enforced by Microsoft identity, by the app’s own org id, or both?*

##### Signals in the browser / proxy (Azure-hosted or Azure-auth)

| Signal | Where | What it suggests |
|--------|--------|------------------|
| Login host `login.microsoftonline.com` | Redirect on sign-in | Entra ID / Azure AD auth |
| URL has `/{tenant-id}/oauth2/v2.0/authorize` | Browser address / proxy | Specific Entra tenant in the auth path |
| JWT claim **`tid`** | Decode access/id token (jwt.ms or proxy extension) | Entra directory id of the signed-in org |
| Claims **`oid`**, **`preferred_username`**, **`roles`**, **`groups`**, **`scp`** | Same token | User object id, roles/scopes from Entra |
| App id / client id (`appid`, `azp`) | Token | Which app registration issued/used the token |
| Host `*.azurewebsites.net`, `*.azurefd.net`, `*.applicationgateway...` | Request URL | App Service / Front Door / App Gateway in front |
| Host `*.blob.core.windows.net` | Upload or asset URLs | Azure Blob — often path includes account/container; check auth on blob URL |
| Header or body `x-ms-*`, WAF `x-azure-ref` | Response headers | Azure infra in path (lead, not a finding) |
| Graph calls `graph.microsoft.com` | Proxy | App using Microsoft Graph; permissions matter |

##### Practical steps on an Azure-backed app

1. **Capture login** — Note whether auth is Entra (`login.microsoftonline.com`) or local forms.  
2. **Decode the token** after login — Write down `tid`, `oid`, `roles`/`groups`, `aud`. That is often “how me is known.”  
3. **See if the product adds its own org** — After login, does the API still send `workspaceId` / `accountId` separate from `tid`? If yes, test **both** Entra isolation and app-org isolation.  
4. **Two directories (when in scope)** — Two test Entra tenants or two workspaces: swap object ids and, carefully, any client-sent tenant headers.  
5. **Blobs & static** — If files land on `*.blob.core.windows.net`, check whether the URL works logged out or from another account (SAS vs public container).  
6. **Do not confuse** “multi-tenant app registration” (many companies can *log in*) with “my bug is cross-tenant” (company A reads company B **data**). You still prove the latter with object access.

##### Minimal Azure tenancy notes (fill while testing)

```text
Auth: Entra / local / hybrid
Entra tid (if any):
App’s own org/workspace id (if any): How sent? path|header|body|token
Roles from: Entra app roles | groups | app DB
Cross-tenant test idea:
```

---

#### Combined model (users + levels + tenancy)

```text
Users
├── How referenced → UID | email | username | UUID
├── Where referenced → cookies | API calls | JWT | page/JS
├── App designed for multiple customers (tenants)
│     └── selected by → subdomain | path | header | token claim
└── App has multiple user levels
      ├── Admin (cms/framework)
      ├── Tenant/Account Admin
      ├── Tenant/Account User
      ├── Tenant/Account Viewer
      └── Unauthenticated functionality
```

---

#### Answer sheet (Q2)

```text
How (id format): 
Where (me): 
Where (them): 
Roles: 
Tenant model: single | multi | hybrid
Tenant selected by: 
Azure/Entra tid / app org id: 
AuthZ tests to run: 
```

---

#### Prompt — users + levels + tenancy

```text
Map users, roles, and tenancy for authorized authZ testing.

I will paste: login/token notes (redact secrets), API calls, UI role/workspace language.
If Azure/Entra: include hostnames, tid/oid claims if seen, blob URLs.

1. HOW users are identified; WHERE those ids appear (me vs them).
2. Role ladder observed.
3. Tenant model + how tenant is selected.
4. If Azure-related: Entra tenant vs app workspace — which isolation matters?
5. Ranked tests: horizontal, vertical, cross-tenant, unauth.

Context:
[PASTE]

Short tables + ordered test queue.
```

---

---

*Part of Understanding App — Big Questions for directed web app testing.*
