# IIS — Execution batches

**How to work:** open **one batch**, finish it in 1–2 hours, follow **next_batch**.  
Do not open the long reference doc mid-session unless stuck.

**Authorized targets only.**

---

## Board (order)

| Batch | Session focus | Time | File |
|-------|---------------|------|------|
| **01** | Fingerprint IIS + HTTPAPI host rescue | 60–90 min | [execution_batches/01-fingerprint-httpapi.md](./execution_batches/01-fingerprint-httpapi.md) |
| **02** | VHost hopping (Host brute + proxy rewrite) | 60–90 min | [execution_batches/02-vhost-hopping.md](./execution_batches/02-vhost-hopping.md) |
| **03** | LFI → `web.config` → DLL pull | 60–90 min | [execution_batches/03-lfi-webconfig-dll.md](./execution_batches/03-lfi-webconfig-dll.md) |
| **04** | VIEWSTATE / machineKey → RCE path | 60–120 min | [execution_batches/04-viewstate-rce.md](./execution_batches/04-viewstate-rce.md) |
| **05** | Vendor deps + DNSpy workflow | 60–90 min | [execution_batches/05-dnspy-dependencies.md](./execution_batches/05-dnspy-dependencies.md) |
| **06** | Blind XXE local DTD + fragment leak | 60–90 min | [execution_batches/06-xxe-fragment.md](./execution_batches/06-xxe-fragment.md) |
| **07** | Shortname enum + logical ffuf completion | 60–120 min | [execution_batches/07-shortname-fuzz.md](./execution_batches/07-shortname-fuzz.md) |

## Progress

```text
[ ] 01 fingerprint-httpapi
[ ] 02 vhost-hopping
[ ] 03 lfi-webconfig-dll
[ ] 04 viewstate-rce
[ ] 05 dnspy-dependencies
[ ] 06 xxe-fragment
[ ] 07 shortname-fuzz
```

## Reference (not the session path)

| File | Use |
|------|-----|
| [OPERATOR-NOTES-hacking-iis-nahamcon.md](./OPERATOR-NOTES-hacking-iis-nahamcon.md) | Full first-principles + paste archive |
| [pentest-checklist.md](./pentest-checklist.md) | Tick coverage |
| [resources.md](./resources.md) | Links |
| [slides-raw/](./slides-raw/) | Deck images |
