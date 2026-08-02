# IIS — Resources

From training slide “More resources on hacking IIS,” plus a few stable companions.

**Engagement operator notes (first principles + paste kits):**  
[OPERATOR-NOTES-hacking-iis-nahamcon.md](./OPERATOR-NOTES-hacking-iis-nahamcon.md)  
**Slide images (1–35):** [slides-raw/cdn/](./slides-raw/cdn/)  
**Deck:** [SlideShare — Hacking IIS NahamCon](https://www.slideshare.net/slideshow/hacking-iis-nahamconpdf/255244262)

## Core (from slide 34)

| Link | What |
|------|------|
| [https://bit.ly/3uzOP4N](https://bit.ly/3uzOP4N) | Assetnote YouTube channel |
| [https://youtu.be/HrJW6Y9kHC4](https://youtu.be/HrJW6Y9kHC4) | Hacking IIS — Part 1 |
| [https://youtu.be/_4W0WXUatiw](https://youtu.be/_4W0WXUatiw) | Hacking IIS — Part 2 |
| [http://soroush.secproject.com/blog/](http://soroush.secproject.com/blog/) | Soroush Dalili — strong IIS / ASP.NET research blog |
| [https://twitter.com/bitquark](https://twitter.com/bitquark) | bitquark — IIS shortname scanner work |
| [https://twitter.com/nytr0gen_](https://twitter.com/nytr0gen_) | nytr0gen — XXE partial leakage via fragment identifier errors |
| [https://assetnote.io](https://assetnote.io) · [@assetnote](https://twitter.com/assetnote) | Slide 35 branding / research home |

## Extra links from the deck

| Link | What |
|------|------|
| [https://bit.ly/36D3WQg](https://bit.ly/36D3WQg) | Path traversal → source (Minded Security) |
| [https://bit.ly/2MzJ1qI](https://bit.ly/2MzJ1qI) / [https://bit.ly/2NDZc73](https://bit.ly/2NDZc73) | VIEWSTATE research |
| [https://github.com/0xacb/viewgen](https://github.com/0xacb/viewgen) | VIEWSTATE generator (slide 17) |
| [https://bit.ly/3cF8pWs](https://bit.ly/3cF8pWs) | XXE payload notes |
| [https://bit.ly/2LjXoyM](https://bit.ly/2LjXoyM) | XXE with local DTD files |
| [https://bit.ly/3q2yFwY](https://bit.ly/3q2yFwY) | Shortname / crunch companion (slide 33) |
| [https://sourceforge.net/projects/asp-ent-man/](https://sourceforge.net/projects/asp-ent-man/) | Talk VHost $1900 target product |

## Tools (start here)

| Tool / topic | Notes |
|--------------|--------|
| [IIS ShortName Scanner](https://github.com/irsdl/IIS-ShortName-Scanner) | 8.3 short name / tilde enumeration (irsdl / related ecosystem) |
| [shortscan](https://github.com/bitquark/shortscan) | bitquark’s shortname scanner (see his posts/talks) |
| `curl` / Burp / Caido | Fingerprint headers, path tricks, method probes |
| `nmap` scripts | `http-enum`, `http-iis-webdav-vuln`, version scripts (leads only) |

## Themes to study next

- IIS **tilde / 8.3 short filename** disclosure  
- **Path normalization** / double decode / backslash vs slash  
- `web.config` exposure and ASP.NET config secrets  
- **WebDAV**, handlers, modules, extension mapping  
- VIEWSTATE / machine keys (when ASP.NET)  
- HTTP.sys / request filtering edge cases  

Watch Parts 1–2 first, then dig Soroush’s blog for depth on whatever you hit in the wild.
