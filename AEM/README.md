# AEM — Operator board (good-guy Conti speed)

**Rule:** open **one batch**. Read **WHY** (30 sec). Run **DO THIS**. Follow **NEXT**.  
Stop when the timer ends. You do not need the whole board in your head.

**Only test systems you are allowed to test.**

---

## How every card is built

| Part | What it is |
|------|------------|
| **WHY** | Tiny theory so you know what you are doing |
| **DO THIS** | Dumb steps. Copy. Paste. Run. |
| **IF / THEN** | What to do when something works or fails |
| **NEXT** | The only batch you open after |

---

## Board (in order)

| # | Card | Time | Open this |
|---|------|------|-----------|
| 01 | Is it AEM? Get one page path | ~1 h | [01](./execution_batches/01-confirm-aem.md) |
| 02 | Dump folders as JSON | ~1 h | [02](./execution_batches/02-json-node-dumps.md) |
| 03 | Try the big search door (QueryBuilder) | ~1 h | [03](./execution_batches/03-querybuilder-direct.md) |
| 04 | Trick the bouncer (semicolon / fake file type) | ~1 h | [04](./execution_batches/04-bypass-semicolon.md) |
| 05 | Trick the bouncer (GraphQL path) | ~1 h | [05](./execution_batches/05-bypass-graphql.md) |
| 06 | Trick the bouncer (`form` suffix) | ~1 h | [06](./execution_batches/06-bypass-form-selector.md) |
| 07 | Search and loot with QueryBuilder | ~1–2 h | [07](./execution_batches/07-loot-querybuilder.md) |
| 08 | Steal packages + secret files | ~1–2 h | [08](./execution_batches/08-packages-content-secrets.md) |
| 09 | XSS cheat code `rawcontent` | ~1 h | [09](./execution_batches/09-xss-rawcontent.md) |
| 10 | Cheat code `listParagraphs` | ~1 h | [10](./execution_batches/10-listparagraphs.md) |
| 11 | Stack two cheat codes | ~1 h | [11](./execution_batches/11-selector-chains.md) |
| 12 | Is AEM Forms here? (look only) | ~1 h | [12](./execution_batches/12-forms-surface.md) |
| 13 | Forms old XXE tricks | ~1–2 h | [13](./execution_batches/13-forms-classic-xxe.md) |
| 14 | Forms new big bugs | ~1–2 h | [14](./execution_batches/14-forms-modern-rce.md) |
| 15 | SSRF + package XXE | ~1 h | [15](./execution_batches/15-modern-ssrf-xxe.md) |
| 16 | Write a node + leak config | ~1–2 h | [16](./execution_batches/16-modern-write-el.md) |

## Progress ticks

```text
[ ] 01  [ ] 02  [ ] 03  [ ] 04  [ ] 05  [ ] 06
[ ] 07  [ ] 08  [ ] 09  [ ] 10  [ ] 11
[ ] 12  [ ] 13  [ ] 14  [ ] 15  [ ] 16
```

Deep reading only if stuck: [reference/](./reference/) · [resources.md](./resources.md)
