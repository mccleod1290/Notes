# IIS — open this first

## Vibe path (do not think hard)

1. Open **[execution_batches/01-fingerprint-httpapi.md](./execution_batches/01-fingerprint-httpapi.md)**  
2. Fill the `IP=` / `NAME=` box at the top  
3. Copy-paste every command top → bottom  
4. At the bottom, open only the file in **NEXT**  
5. Stop when the timer ends  

**Only test systems you are allowed to test.**

---

## Board

| # | What you do | Time | File |
|---|-------------|------|------|
| 01 | IIS + HTTPAPI Host fix + elmah/trace | ~1 h | [01](./execution_batches/01-fingerprint-httpapi.md) |
| 02 | Other Host names on same IP | ~1 h | [02](./execution_batches/02-vhost-hopping.md) |
| 03 | `../` → web.config → DLL | ~1 h | [03](./execution_batches/03-lfi-webconfig-dll.md) |
| 04 | machineKey → VIEWSTATE RCE | ~1–2 h | [04](./execution_batches/04-viewstate-rce.md) |
| 05 | Telerik / vendor DLL reverse | ~1 h | [05](./execution_batches/05-dnspy-dependencies.md) |
| 06 | XXE local DTD + `#` fragment | ~1 h | [06](./execution_batches/06-xxe-fragment.md) |
| 07 | Shortname → ffuf finish name | ~1–2 h | [07](./execution_batches/07-shortname-fuzz.md) |

```text
[ ] 01  [ ] 02  [ ] 03  [ ] 04  [ ] 05  [ ] 06  [ ] 07
```

---

## Slide → batch (NahamCon 35 slides)

| Slides | Topic | Batch |
|--------|--------|-------|
| 1–2 | Title + why IIS (case, shortname, VIEWSTATE, ELMAH, Telerik) | 01, 05, 07 |
| 3–7 | HTTPAPI 2.0 Host rescue | **01** |
| 8–12 | VHost hop + Burp replace | **02** |
| 13–15 | LFI web.config DLL | **03** |
| 16–17 | VIEWSTATE / viewgen | **04** |
| 18–22 | DNSpy | **05** |
| 23–28 | XXE fragment | **06** |
| 29–33 | shortscan + ffuf + crunch | **07** |
| 34–35 | Links | [resources.md](./resources.md) |

Slide pictures: [slides-raw/cdn/](./slides-raw/cdn/)  
Long archive (optional): [OPERATOR-NOTES-hacking-iis-nahamcon.md](./OPERATOR-NOTES-hacking-iis-nahamcon.md)
