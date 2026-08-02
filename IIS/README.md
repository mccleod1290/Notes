# IIS — Operator board (good-guy Conti speed)

**Rule:** open **one batch**. Read **WHY** (30 sec). Run **DO THIS**. Follow **NEXT**.

**Only test systems you are allowed to test.**

---

## Board (in order)

| # | Card | Time | Open this |
|---|------|------|-----------|
| 01 | Spot IIS + fix wrong Host name | ~1 h | [01](./execution_batches/01-fingerprint-httpapi.md) |
| 02 | Find other apps on same IP (VHost) | ~1 h | [02](./execution_batches/02-vhost-hopping.md) |
| 03 | Read files → web.config → DLLs | ~1 h | [03](./execution_batches/03-lfi-webconfig-dll.md) |
| 04 | Keys from config → VIEWSTATE RCE | ~1–2 h | [04](./execution_batches/04-viewstate-rce.md) |
| 05 | Break vendor plugins (DNSpy) | ~1 h | [05](./execution_batches/05-dnspy-dependencies.md) |
| 06 | Blind XXE + partial file leak | ~1 h | [06](./execution_batches/06-xxe-fragment.md) |
| 07 | Short names → finish the name with fuzz | ~1–2 h | [07](./execution_batches/07-shortname-fuzz.md) |

## Progress ticks

```text
[ ] 01  [ ] 02  [ ] 03  [ ] 04  [ ] 05  [ ] 06  [ ] 07
```

Long theory + extra pastes: [OPERATOR-NOTES-hacking-iis-nahamcon.md](./OPERATOR-NOTES-hacking-iis-nahamcon.md)  
Links: [resources.md](./resources.md) · slides: [slides-raw/](./slides-raw/)
