# Batch 01 — Spot IIS + fix wrong Host name

## GOAL
See if the box is IIS. If you get a useless **HTTPAPI 2.0 404**, find the real website name (Host).

## TIME
~1 hour

## YOU NEED
- IP or URL in scope
- `curl` (optional `openssl`)

---

## WHY (30 seconds)

IIS can host **many sites on one IP**.  
It picks the site by the **Host** name in the request (like apartment number).  

If you only hit the IP with the wrong name, Windows answers with:

`Server: Microsoft-HTTPAPI/2.0` + empty 404  

That is **not** “dead server.” That is “wrong apartment number.”  
Bad guys skip these IPs. You do not.

---

## DO THIS

```bash
IP="x.x.x.x"
```

### 1) Fingerprint

```bash
curl -skI "http://$IP/"
curl -skI "https://$IP/"
```

Write what you see: `Server:`, `X-AspNet`, cookies, status.

### 2) Is it the fake 404?

Look for: `Microsoft-HTTPAPI/2.0` and almost no real website HTML.

### 3) Steal names from the certificate

```bash
echo | openssl s_client -connect $IP:443 -servername $IP 2>/dev/null \
  | openssl x509 -noout -text 2>/dev/null | grep -E 'DNS:|Subject:'
```

### 4) Try a real name

```bash
# change app.company.com to a name you found
curl -skI --resolve app.company.com:443:$IP "https://app.company.com/"
curl -sI -H "Host: app.company.com" "http://$IP/"
```

### 5) If it works — pin the name

```bash
echo "$IP app.company.com" | sudo tee -a /etc/hosts
```

Use the **name** for all later scans, not only the IP.

### 6) Write 3 lines

```text
IIS: yes/no
HTTPAPI_fake_404: yes/no
REAL_HOST=
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Real site with host | → **NEXT** |
| HTTPAPI only, no cert name | Brute Hosts 20–40 min (ffuf Host header), then **NEXT** if found |
| Clear IIS already | Still note version → **NEXT** |

---

## NEXT
→ [02-vhost-hopping.md](./02-vhost-hopping.md)
