# AEM — Operator Notes

**Adobe Experience Manager** engagement kit.  
Written so you can **copy, paste, and understand** under time pressure.

**Authorized targets only.**

---

## Start here (order)

| # | File | What it is |
|---|------|------------|
| 0 | [00-glance.md](./00-glance.md) | Whole picture on one page |
| 1 | [01-what-is-aem.md](./01-what-is-aem.md) | What AEM is (stupid-simple) |
| 2 | [02-fingerprint.md](./02-fingerprint.md) | “Is this AEM?” paste kit |
| 3 | [03-sling-urls.md](./03-sling-urls.md) | Selectors / suffix / why weird URLs work |
| 4 | [04-dispatcher-bypasses.md](./04-dispatcher-bypasses.md) | Get past the front door |
| 5 | [05-querybuilder-loot.md](./05-querybuilder-loot.md) | Dump the content database |
| 6 | [06-selectors-gadgets.md](./06-selectors-gadgets.md) | `rawcontent` / `listParagraphs` / `form` |
| 7 | [07-content-packages.md](./07-content-packages.md) | `/content`, `/etc/packages`, secrets |
| 8 | [08-aem-forms.md](./08-aem-forms.md) | AEM Forms (Egorov + Shah) |
| 9 | [09-modern-bugs.md](./09-modern-bugs.md) | Assetnote/Searchlight modern chain |
| 10 | [10-playbooks.md](./10-playbooks.md) | Timed engagement scripts |
| — | [checklist.md](./checklist.md) | Tick boxes while you work |
| — | [resources.md](./resources.md) | Sources & tools |

---

## Rule of the kit

1. **Fingerprint** (is it AEM?).  
2. **Bypass dispatcher** (front door lies).  
3. **Loot** (querybuilder / json dumps / packages).  
4. **Escalate** (selectors, Forms, modern bugs).  

If stuck for 10 minutes on one step → skip to next playbook step.

---

## Sources distilled here

- Jim Green / CTBB HackerNotes Ep.176 + [Sling Selectors writeup](https://greenjam.co.uk/blog/sling-selectors/)  
- Mikhail Egorov (0ang3el) [adapt.to 2020 PDF](https://adapt.to/2020/presentations/adaptto2020-a-hackers-perspective-on-aem-applications-security-mikhail-egorov.pdf) + aem-hacker  
- Shubham Shah / Assetnote / Searchlight: [Finding Critical Bugs in AEM](https://slcyber.io/research-center/finding-critical-bugs-in-adobe-experience-manager/), [AEM Forms Struts/XXE](https://slcyber.io/research-center/struts-devmode-in-2025-critical-pre-auth-vulnerabilities-in-adobe-experience-manager-forms/)
