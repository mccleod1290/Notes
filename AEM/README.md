# AEM — Execution batches

**How to work this kit:** open **one batch**, finish it in 1–2 hours, stop or follow **next_batch**.  
Do **not** open every file at once.

**Authorized targets only.** Replace `TARGET` / paths with yours.

---

## Board (do in order unless a decision_point jumps you)

| Batch | Session focus | Time | File |
|-------|---------------|------|------|
| **01** | Confirm AEM + grab one page path | 45–90 min | [execution_batches/01-confirm-aem.md](./execution_batches/01-confirm-aem.md) |
| **02** | Sling basics + `.N.json` node dumps | 60–90 min | [execution_batches/02-json-node-dumps.md](./execution_batches/02-json-node-dumps.md) |
| **03** | QueryBuilder direct (no bypass yet) | 45–75 min | [execution_batches/03-querybuilder-direct.md](./execution_batches/03-querybuilder-direct.md) |
| **04** | Dispatcher bypass: semicolon / fake extension | 60–90 min | [execution_batches/04-bypass-semicolon.md](./execution_batches/04-bypass-semicolon.md) |
| **05** | Dispatcher bypass: GraphQL + hybrid | 45–75 min | [execution_batches/05-bypass-graphql.md](./execution_batches/05-bypass-graphql.md) |
| **06** | Dispatcher bypass: `form` selector + suffix | 45–75 min | [execution_batches/06-bypass-form-selector.md](./execution_batches/06-bypass-form-selector.md) |
| **07** | Loot with working QueryBuilder URL | 60–120 min | [execution_batches/07-loot-querybuilder.md](./execution_batches/07-loot-querybuilder.md) |
| **08** | Packages + content secret mining | 60–120 min | [execution_batches/08-packages-content-secrets.md](./execution_batches/08-packages-content-secrets.md) |
| **09** | Selector XSS: `rawcontent` / `savedsearch` | 45–75 min | [execution_batches/09-xss-rawcontent.md](./execution_batches/09-xss-rawcontent.md) |
| **10** | Selector gadget: `listParagraphs` | 60–90 min | [execution_batches/10-listparagraphs.md](./execution_batches/10-listparagraphs.md) |
| **11** | Chain selectors (`form` → `listParagraphs`) | 45–75 min | [execution_batches/11-selector-chains.md](./execution_batches/11-selector-chains.md) |
| **12** | AEM Forms: fingerprint surface only | 45–75 min | [execution_batches/12-forms-surface.md](./execution_batches/12-forms-surface.md) |
| **13** | AEM Forms: classic guide XXE/JS (Egorov) | 60–120 min | [execution_batches/13-forms-classic-xxe.md](./execution_batches/13-forms-classic-xxe.md) |
| **14** | AEM Forms: modern criticals (Shah) | 60–120 min | [execution_batches/14-forms-modern-rce.md](./execution_batches/14-forms-modern-rce.md) |
| **15** | Modern AEM: SSRF + packmgr XXE | 60–90 min | [execution_batches/15-modern-ssrf-xxe.md](./execution_batches/15-modern-ssrf-xxe.md) |
| **16** | Modern AEM: write gadget + EL leak | 60–120 min | [execution_batches/16-modern-write-el.md](./execution_batches/16-modern-write-el.md) |

---

## Progress (tick in your engagement notes)

```text
[ ] 01 confirm-aem
[ ] 02 json-node-dumps
[ ] 03 querybuilder-direct
[ ] 04 bypass-semicolon
[ ] 05 bypass-graphql
[ ] 06 bypass-form-selector
[ ] 07 loot-querybuilder
[ ] 08 packages-content-secrets
[ ] 09 xss-rawcontent
[ ] 10 listparagraphs
[ ] 11 selector-chains
[ ] 12 forms-surface        (skip if no Forms)
[ ] 13 forms-classic-xxe    (skip if no Forms / no write)
[ ] 14 forms-modern-rce     (skip if no Forms / no RCE scope)
[ ] 15 modern-ssrf-xxe
[ ] 16 modern-write-el
```

---

## Session rule

1. Read **only** the current batch.  
2. Run its **testing_workflow**.  
3. At **decision_points**, follow the arrow (next batch or skip).  
4. When the timer ends: write 3 bullets of what worked → done for the session.

Deep theory / long paste archives: [reference/](./reference/)  
Links: [resources.md](./resources.md)
