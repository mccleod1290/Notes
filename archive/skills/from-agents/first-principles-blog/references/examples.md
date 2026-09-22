# Worked 3-part examples

Copy the **structure**. Copy Casino facts only if you re-ran that box.

One primitive = one block: (1) one-sentence definition, (2) adjacent terms,
(3) other places that do **this** job. If part 3 needs a new definition,
start a new block.

Prereq: the 3-part law in `SKILL.md`. None of these examples need extra
theory.

```text
one primitive → one 3-part block
  JS copies        → recover the original program
  nmap flags       → extra questions to one knocker
  www-data         → what this uid can already read
  logs             → a secret written to a readable file
  SSTI             → the server renders the string
```

Source: HackSmarter Casino (`10.0.31.65`, 2026-08-27).
Public post: https://mccleod1290.github.io/hack-smarter-labs/linux/casino/

---

## Example 1 — JavaScript packaging

**Key terms:** `main.js` / `app.js`, `app.min.js`, `app.min.js.map`

**1. What it is (first principle).**
JavaScript is the program the browser runs; the file name only labels
**which copy** of that program you are holding.

**2. Adjacent terms (same program, three packages).**
- `main.js` / `app.js` / `src/api/roomVerification.js` — original: spaces,
  comments, real function names. Humans write this.
- `app.min.js` — **minified**: same program with whitespace and comments
  stripped (names often shortened) so the download is smaller. The browser
  only needs this copy to run the site.
- `app.min.js.map` — **source map**: JSON that says “column 80 in the min
  file came from line 3 of `roomVerification.js`.” DevTools uses it for
  breakpoints. It often embeds the original in `sourcesContent`.

Why the names differ: a CDN caches the tiny runtime file; developers still
debug the original. The map is **not** required for the site to work.
Shipping it to production leaks the readable program.

**3. Variations grounded to “recover the original JS.”**
- Footer comment `//# sourceMappingURL=...` or HTTP header `SourceMap`
- Try `app.js.map`, `main.js.map`, `bundle.js.map` next to any `.min.js`
- Tools: DevTools → Sources, `sourcemapper`, or read the **whole** min
  file (API paths still appear as string literals if the map is 404)

If the map is 404: you still have the minified program; search it for URLs
and `fetch(`.

Illegal part 3: XSS payload lists. That is a new primitive (the browser
runs a string as script).

Casino fact: `app.min.js` was two lines; the map restored
`fetch('/api/v1/rooms/status?status=occupied')`.

Use when the site ships `.min.js` and you need the readable program. Skip
when you already have original sources.

---

## Example 2 — Command flags (`nmap`)

```bash
nmap -sC -sV -Pn -p- --min-rate 2000 -oA enum/nmap_full 10.0.31.65
```

**1. What it is.**
A port scan knocks on TCP (or UDP) ports and writes down who answers.

**2. Adjacent terms.**
- `rustscan` — same job (find open ports), faster default, often piped
  into nmap for scripts.
- `masscan` — same job at internet scale; less service detail.
- “top 1000 ports” vs `-p-` — same knocker; different door list.

Why the names differ: nmap is the detailed knocker; rustscan and masscan
trade detail for speed. The default port list is a time shortcut, not a
different attack.

**3. Flags used (each flag is one extra question).**

| Piece | Meaning |
|-------|---------|
| `-sC` | run nmap’s default scripts (HTTP title, SSH host keys) |
| `-sV` | talk a little more so the product and version are visible |
| `-Pn` | skip the ping check; scan anyway (VPN labs often drop ICMP) |
| `-p-` | all 65535 TCP ports, not the default top 1000 |
| `--min-rate 2000` | send at least 2000 packets/sec so a full scan finishes on a slow VPN |
| `-oA enum/nmap_full` | write three files with one name: `.nmap` (human), `.gnmap` (grep), `.xml` (tools) |
| `10.0.31.65` | the host to knock on |

This command is TCP (`-p-` without `-sU`). UDP is a separate scan.

If you omit `-Pn` and the host ignores ping, nmap reports the host down
and skips ports. If `--min-rate` is too high, replies can drop and open
ports look closed.

Illegal part 3: a full Metasploit tutorial. That is a new primitive
(exploit framework), not “ask this scanner one more question.”

Use at first look at a host. Skip when you already have a current port
list.

---

## Example 3 — OS object (`www-data`)

**1. What it is.**
Linux processes run as a user; `www-data` (uid 33 on Debian/Ubuntu) is
the dedicated account for the web worker so a hacked site does not start
as root.

**2. Adjacent terms.**
- `nginx` / `apache` / `httpd` — other common web uids. Same idea: least
  privilege for HTTP.
- `nobody` — generic unprivileged account, not tied to the web stack.
- `root` — uid 0, no permission checks. Different on purpose.

Why the names differ: each service gets its own uid so a hole in one
daemon is not a hole in every file on the box.

**3. Variations grounded to “what can this web user read/run?”**
- `id` — uid, gid, groups
- world-readable homes (`644` on `id_rsa`)
- web roots `/var/www`, app configs, writable upload dirs

If `id` is not `www-data`, you are a different user; this block does not
apply.

Illegal part 3: kernel exploits. That is a new primitive (memory safety),
not “what files does the web user already have.”

Use after a web shell. Skip when you already have another user’s shell.

---

## Example 4 — Log privesc

**Technique:** group `adm` can read `/var/log/provisioning.log`; a root
provisioner printed the root password.

**1. What it is.**
A log is a file a process appends text to. If a privileged process prints
a secret, and you can read that file, you have the secret.

**2. Adjacent terms (same primitive: secret recorded in a readable file).**
- `~/.bash_history` — records **what a user typed** (passwords on the CLI).
- `/var/log/auth.log` (or `secure`) — records **that** `su` happened,
  usually not the password.
- `adm` — a read ticket for many logs, not a root uid. The privesc is
  the secret in the file, not the group name.

Why the names differ: history is a per-user command log; syslog-style
files are the machine’s log; `adm` is only who may read those files.

**3. Variations grounded to “secret in a log you can read.”**

- `/var/log/cloud-init-output.log` / `cloud-init.log` — cloud images echo
  userdata, sometimes passwords
- `/var/log/installer/` and first-boot `syslog`
- `/var/log/auth.log` — failed passwords; PAM debug sometimes prints secrets
- web logs if a cred landed in a query string
- names: `provision*`, `bootstrap*`, `firstboot*`, `cloud-init*`

```bash
ls -la /var/log
grep -RniE 'passw|credential|secret|token' /var/log 2>/dev/null
```

| Piece | Meaning |
|-------|---------|
| `ls -la` | long list: mode, owner, group — see if you can read the file |
| `grep -R` | recursive search |
| `-n` | print line numbers |
| `-i` | ignore case |
| `-E` | extended regex so `a|b|c` means any of these |
| `2>/dev/null` | hide “permission denied” on files you still cannot read |

If you are not in `adm` and the file is not world-readable, this path is
closed. If grep finds nothing, the secret may use other words, sit in a
rotated log, or not be in logs at all.

Illegal part 3: “also check SUID binaries and kernel version.” That is a
**new** first principle (mis-set executable bits / memory corruption).
Put it in its own block only if you actually take that path.

Use when you can read a log directory. Skip when you cannot read the
files — then the next question is still “who can read this file?”, or a
new block if you switch to SUID.

---

## Example 5 — SSTI vs XSS (technique cousins)

**1. What SSTI is.**
Server-Side Template Injection: you type a string, the server pastes it
into a template and **renders** the template, so `{{7*7}}` is math, not
text.

**2. Adjacent terms (untrusted string → a language → a sink).**
- **XSS** — the **browser** runs the string as JavaScript. Sink is the page.
- **SSTI** — the **server** runs the string as template code. Sink is the
  engine (Jinja, Twig, Freemarker, ERB). You can read files and spawn
  processes.
- **CSTI** — client-side templates (Angular `{{ }}` in the browser).
  XSS-shaped; it does not give you `www-data`.
- Jinja2 vs Twig: same class, different language. `{{7*'7'}}` →
  `7777777` is Jinja (string repeat); Twig often yields `49`.

Why the names differ: the letters say **where** the engine runs (server,
client, or the page’s JS). Same input shape, different machine.

**3. Variations grounded to “does this field get rendered on the server?”**
- Probe every reflected field: name, email, filename, error, PDF, email body
- Canary `{{7*7}}`, then engine fingerprint, then RCE
- Same stored value, two sinks: Casino dashboard showed raw `{{7*7}}`
  (escaped); profile flash evaluated it

If `{{7*7}}` comes back as the literal characters, that field is not an
SSTI sink. It may still be XSS if the browser would run a script tag.

Illegal part 3: reverse-shell cookbook as if it were a new bug. The shell
is **how you use** the RCE, still the same primitive.

Use when a field you type is reflected after server-side templating.
Skip when the string never reaches a template engine.

---

## Anti-example (part 3 went off the primitive)

**Wrong:** “We read `provisioning.log`. You should also try GTFOBins,
dirty pipe, and linpeas.”

**Why it fails:** those are other primitives (sudo misconfig, kernel,
shotgun enum). The reader loses the lesson: **logs are files**.

**Right:** name three other **log files** that the same `adm` read would
cover. Start a new block if you later switch primitives.
