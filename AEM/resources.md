# AEM — Resources

## Primary sources used for these notes

| Source | What you get |
|--------|----------------|
| [HackerNotes Ep.176 — AEM deep dive (Jim Green)](https://blog.criticalthinkingpodcast.io/p/hackernotes-ep-176-aem-deep-dive-with-jim-green-sling-selectors-dispatcher-bypasses-and-xss-gadgets) | Selectors, form/listParagraphs/rawcontent, packages story, methodology |
| [Jim Green — Sling Selectors blog](https://greenjam.co.uk/blog/sling-selectors/) | Full CVE writeups for core selectors |
| [Jim Green CVE list](https://greenjam.co.uk/cves) | Inventory of `/libs` paths to retest |
| [Egorov adapt.to 2020 PDF](https://adapt.to/2020/presentations/adaptto2020-a-hackers-perspective-on-aem-applications-security-mikhail-egorov.pdf) | Forms guide XXE / JS (APSB19-48) |
| [0ang3el aem-hacker](https://github.com/0ang3el/aem-hacker) | Classic automated enum + dispatcher try |
| [Finding Critical Bugs in AEM (Kues/Pindur, Searchlight)](https://slcyber.io/research-center/finding-critical-bugs-in-adobe-experience-manager/) | Modern dispatcher bypasses, SSRF, XXE, EL, hopgoblin |
| [AEM Forms Struts/XXE/deser (Shah/Kues)](https://slcyber.io/research-center/struts-devmode-in-2025-critical-pre-auth-vulnerabilities-in-adobe-experience-manager-forms/) | Standalone Forms criticals |

## Older Egorov material (still useful mental models)

| Link | Notes |
|------|--------|
| [SpeakerDeck — AEM hacker BB](https://speakerdeck.com/0ang3el/aem-hacker-approaching-adobe-experience-manager-webapps-in-bug-bounty-programs) | Methodology slides |
| [adapt.to 2019 securing by hacking PDF](https://adapt.to/2019/presentations/adaptto2019-securing-aem-webapps-by-hacking-them-mikhail-egorov.pdf) | Dispatcher + Sling features |

## Tools

| Tool | Use |
|------|-----|
| curl | Everything in this kit |
| aem-hacker | Bulk default checks |
| hopgoblin | Modern Assetnote checks |
| ffuf | Path/selector mutations |
| nuclei | Community AEM templates (verify quality) |
| ysoserial | Forms deser labs only |

## Bonus XSS gadgets (from Jim Green / CTBB — not AEM-only)

| Gadget | POC |
|--------|-----|
| moment.js format `[]` injection | https://poc.greenjam.co.uk/just-a-moment.html |
| jQuery `.text()` entity re-decode | https://poc.greenjam.co.uk/text-xss.html |
| `javascript:` URL hostname/path bypass | https://poc.greenjam.co.uk/url-xss.html |

## Adobe advisories (examples)

- https://helpx.adobe.com/security/products/experience-manager.html  
- https://helpx.adobe.com/security/products/aem-forms.html  
- APSB19-48, APSB22-40, APSB22-59, APSB24-28, APSB25-82 (Forms), GRANITE hotfixes  

## Operator notes index

[README.md](./README.md)
