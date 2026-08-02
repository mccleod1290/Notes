# Batch 02 — Find other apps on same IP (VHost)

## FILL IN

```bash
IP="1.2.3.4"
DOMAIN="company.com"
PUBLIC="apply.company.com"     # name that already works
# after a hit:
SECRET="mssql.company.com"     # example internal name from talk
```

## GOAL
Find **other Host names** on this IIS (internal admin tools) and open them.

## TIME
~1 hour

## YOU NEED
- Batch 01 done (you have a working public name)
- A subdomain wordlist file: `subdomains.txt`
- Optional: Burp for Match & Replace

---

## WHY (kid version)

Same IP, **different names** = different apps.  
Talk **$1900** example:

- Public: `apply.company.com` (IIS)  
- Brute Host: `%word%.company.com` (Burp Intruder / ffuf)  
- Hit: `mssql.company.com` — **not** in public DNS  
- App: ASP.NET Enterprise Manager / MSSQL web UI  
  https://sourceforge.net/projects/asp-ent-man/

Public DNS may not list the secret name. You still send it. That is **VHost hopping**.

---

## DO THIS

### 1) Measure the “empty” response size

```bash
curl -sk -o /tmp/base -w "%{size_download}\n" \
  -H "Host: no-such-xyz.$DOMAIN" "http://$IP/"
```

Put that number into `BASE` below.

### 2) Brute Host header

```bash
BASE=12345   # paste size from step 1
ffuf -u "http://$IP/" -H "Host: FUZZ.$DOMAIN" \
  -w subdomains.txt -mc all -fs $BASE -t 40
```

**Win:** different size/status → real vhost. Set `SECRET=...`

### 3) Open the secret host with curl

```bash
curl -skI --resolve "$SECRET:443:$IP" "https://$SECRET/"
curl -sk --resolve "$SECRET:443:$IP" "https://$SECRET/" | head -c 400
```

### 4) Burp Match & Replace (so browser works) — from the slide

In Burp: **Proxy → Match and replace → Add**

| Field | What to type |
|-------|----------------|
| Type | Request header |
| Match | `^Host: apply\.company\.com$` (use your PUBLIC name) |
| Replace | `Host: mssql.company.com` (use your SECRET name) |
| Regex match | **checked** |

Browse `https://PUBLIC/` in browser through Burp → traffic rewrites to SECRET.

### 5) Write 3 lines

```text
Extra hosts found:
Interesting apps:
```

---

## IF / THEN

| You see | You do |
|---------|--------|
| Admin / DB / internal app | Note product; soft test only |
| File download params (`fileName=`) | → **03** |
| No extra hosts | → **03** if downloads exist, else **07** shortnames |

---

## NEXT
→ [03-lfi-webconfig-dll.md](./03-lfi-webconfig-dll.md)

**Slides:** 8–12
