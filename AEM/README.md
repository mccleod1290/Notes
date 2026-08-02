# AEM — open this first

## Vibe path

1. Open **[execution_batches/01-confirm-aem.md](./execution_batches/01-confirm-aem.md)**  
2. Set `T="https://..."` at the top of the file  
3. Copy-paste commands  
4. Follow **NEXT** only  
5. If QueryBuilder opens early → jump to **07** when the card says so  

**Only test systems you are allowed to test.**

---

## Board

| # | Card | Time | File |
|---|------|------|------|
| 01 | Is it AEM? Save one PAGE | ~1 h | [01](./execution_batches/01-confirm-aem.md) |
| 02 | Dump `.1.json` folders | ~1 h | [02](./execution_batches/02-json-node-dumps.md) |
| 03 | QueryBuilder plain | ~1 h | [03](./execution_batches/03-querybuilder-direct.md) |
| 04 | Bypass `;` + fake css | ~1 h | [04](./execution_batches/04-bypass-semicolon.md) |
| 05 | Bypass GraphQL path | ~1 h | [05](./execution_batches/05-bypass-graphql.md) |
| 06 | Bypass `form` suffix | ~1 h | [06](./execution_batches/06-bypass-form-selector.md) |
| 07 | Loot with QueryBuilder | ~1–2 h | [07](./execution_batches/07-loot-querybuilder.md) |
| 08 | Packages + secrets | ~1–2 h | [08](./execution_batches/08-packages-content-secrets.md) |
| 09 | XSS `rawcontent` | ~1 h | [09](./execution_batches/09-xss-rawcontent.md) |
| 10 | `listParagraphs` | ~1 h | [10](./execution_batches/10-listparagraphs.md) |
| 11 | Stack form + listParagraphs | ~1 h | [11](./execution_batches/11-selector-chains.md) |
| 12 | Forms? look only | ~1 h | [12](./execution_batches/12-forms-surface.md) |
| 13 | Forms classic XXE | ~1–2 h | [13](./execution_batches/13-forms-classic-xxe.md) |
| 14 | Forms modern RCE doors | ~1–2 h | [14](./execution_batches/14-forms-modern-rce.md) |
| 15 | SSRF + packmgr XXE | ~1 h | [15](./execution_batches/15-modern-ssrf-xxe.md) |
| 16 | Write node + EL leak | ~1–2 h | [16](./execution_batches/16-modern-write-el.md) |

```text
[ ] 01-06 map/bypass   [ ] 07-08 loot   [ ] 09-11 selectors
[ ] 12-14 forms        [ ] 15-16 modern
```

Links: [resources.md](./resources.md)

## Source coverage

| Theme | Batches |
|-------|---------|
| Fingerprint / JSON | 01–02 |
| QueryBuilder + dispatcher tricks | 03–06 |
| Loot | 07–08 |
| Selectors (Jim Green) | 09–11 |
| Forms (Egorov + Shah) | 12–14 |
| Modern Assetnote chain | 15–16 |
