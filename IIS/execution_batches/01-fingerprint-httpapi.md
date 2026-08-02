# Batch 01 — Spot IIS + fix wrong Host name

## FILL IN (once)

```bash
IP="1.2.3.4"                    # the IP you are testing
NAME="app.company.com"          # fill after step 3–4 when you know it
```

## GOAL
Is this IIS? If you only see a useless **HTTPAPI 2.0 404**, find the real website **name** (Host). Do not skip the IP.

## TIME
~1 hour

## YOU NEED
- Permission to test
- Terminal with `curl` (optional: `openssl`)

---

## WHY (kid version)

One computer can host **many** websites.  
IIS picks which site by the **name** in the request (`Host:` header) — like an apartment number.

Wrong name → Windows says:

```text
Server: Microsoft-HTTPAPI/2.0
404 Not Found
```

That is **not** “server is dead.” That is “wrong apartment number.”  
The talk says: put the right Host, then scan again.

---

## DO THIS (copy top to bottom)

### 1) Fingerprint

```bash
curl -skI "http://$IP/"
curl -skI "https://$IP/"
```

**Write:** any `Server: Microsoft-IIS` / `X-AspNet` / cookies?

### 2) Is it the fake empty 404?

Look for: `Microsoft-HTTPAPI/2.0` and almost no real HTML.

If **yes** → continue. If you already have a real site name → skip to step 5 with that name.

### 3) Steal names from the TLS certificate

```bash
echo | openssl s_client -connect $IP:443 -servername $IP 2>/dev/null \
  | openssl x509 -noout -text 2>/dev/null | grep -E 'DNS:|Subject:'
```

Copy a DNS name into `NAME=...`

### 4) Try that name as Host

```bash
curl -skI --resolve "$NAME:443:$IP" "https://$NAME/"
curl -sI -H "Host: $NAME" "http://$IP/"
```

**Win:** real HTML / `Server: Microsoft-IIS` / login page — not empty HTTPAPI page.

### 5) Pin the name (so tools use it)

```bash
echo "$IP $NAME" | sudo tee -a /etc/hosts
```

### 6) Re-run checks on the **name** (slide: after fixing host)

```bash
curl -skI "https://$NAME/"
# later batches use https://$NAME/ not only the raw IP
```

### 7) Freebies from slide 2 (5 minutes)

**Case does not matter on Windows** — try mixed case:

```bash
for p in /Admin /admin /ADMIN; do
  curl -sk -o /dev/null -w "%{http_code} $p\n" "https://$NAME$p"
done
```

**Debug pages often left open:**

```bash
for p in /elmah.axd /trace.axd /Trace.axd; do
  curl -sk -o /dev/null -w "%{http_code} $p\n" "https://$NAME$p"
done
```

**200 on elmah/trace = finding** (leaks errors / paths).

### 8) Rinse and repeat (slide 7)

Find **other** IPs/assets that also show HTTPAPI 2.0 404.  
Do steps 3–6 on each. Do not skip them.

### 9) Write 3 lines

```text
IIS: yes/no
HTTPAPI_was_fake: yes/no
NAME=
elmah_or_trace:
other_HTTPAPI_assets:
```

---

## IF / THEN

| You see | You do |
|---------|--------|
| Real site with NAME | Go **NEXT** (also re-run shortname later on NAME — slide 7) |
| Still HTTPAPI, no cert name | Brute Hosts ~20 min (below), then NEXT if found |
| Cert has only partial name | Still use it in Host; or brute the rest |
| No luck at all | Stop IIS board or try more DNS words |

**Host brute (only if step 3–4 failed):**

```bash
# wordlist = subdomains; hide the “empty” size first
curl -sk -o /tmp/b -w "%{size_download}\n" -H "Host: no-such-xyz.company.com" "http://$IP/"
# put that number in -fs
ffuf -u "http://$IP/" -H "Host: FUZZ.company.com" -w subdomains.txt -mc all -fs SIZE -t 40
```

---

## NEXT
→ [02-vhost-hopping.md](./02-vhost-hopping.md)

**Slides:** 1–7 (+ tweet checklist on 2)
