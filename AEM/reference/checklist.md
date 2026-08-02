# AEM checklist

Tick while testing. Details live in numbered guides.

**Target:** _______________  
**Date:** _______________  
**Scope notes:** _______________

---

## Recon

- [ ] Confirmed AEM ([02](./02-fingerprint.md))
- [ ] Noted AMS vs Cloud if known
- [ ] Saved ≥1 `/content/...` page path
- [ ] Author host separate? _______________
- [ ] Forms fingerprint ([08](./08-aem-forms.md))

## Dispatcher / access

- [ ] Direct QueryBuilder status ______
- [ ] Semicolon/extension bypasses tried ([04](./04-dispatcher-bypasses.md))
- [ ] GraphQL / hybrid tried
- [ ] `form` suffix tried
- [ ] Working access URL shape: _______________

## Loot

- [ ] `.1.json` / `.3.json` dumps
- [ ] QueryBuilder `/content` `/etc` `/home` `/etc/packages`
- [ ] fulltext password/secret
- [ ] Packages downloaded / grepped ([07](./07-content-packages.md))
- [ ] Sensitive files under DAM noted

## Gadgets

- [ ] rawcontent / savedsearch ([06](./06-selectors-gadgets.md))
- [ ] listParagraphs (about + XSS path)
- [ ] form → querybuilder / chain

## Forms / modern

- [ ] FormServer / adminui / edcws status
- [ ] SSRF accesstoken probe ([09](./09-modern-bugs.md))
- [ ] packmgr XXE probe (if allowed)
- [ ] hopgoblin / aem-hacker run?

## Hygiene

- [ ] No leftover writes/packages on target
- [ ] Secrets not committed to git
- [ ] Evidence saved offline

---

## Findings log (short)

| ID | Title | URL proof | Impact |
|----|-------|-----------|--------|
| 1 | | | |
| 2 | | | |
| 3 | | | |
