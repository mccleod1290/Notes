# Q6 — How does it store data?

#### Why this matters

Storage creates bug families the UI never shows: open buckets, predictable upload paths, DB error dialects, fetchable exports, client-side secrets.

#### Checklist

- [ ] Where do image/file uploads go? (disk path, S3/GCS URL, CDN)
- [ ] Unauthenticated object read? Long-lived cache?
- [ ] What DB do errors or stack traces suggest?
- [ ] Secrets in LocalStorage / client JS?
- [ ] Exports written to a guessable URL?
- [ ] Second-order sinks: email, Slack, warehouse, search index?

#### If you learn X → test Y

| Learn | Test |
|-------|------|
| Upload returns public bucket URL | Auth on object; key enum; SVG/HTML XSS |
| Open or listable storage (in scope) | Confirm exposure carefully |
| DB errors on one param | Injection focused there |
| `/uploads/YYYY/hash` paths | Predictability, overwrite, traversal |

#### Prompt — storage

```text
Infer how this app stores data and what to test (authorized).

Evidence:
[PASTE: upload responses, asset URLs, errors, headers, JS config]

1. Hypothesize backends (DB family, object storage, filesystem, cache).
2. Map upload → storage → retrieval.
3. Tests: unauth object read, overwrite, path traversal, stored XSS in files, backup exposure.
4. What I must not claim without proof.
```

---

---

*Part of Understanding App — Big Questions for directed web app testing.*
