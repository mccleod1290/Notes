# Batch 02 — Find other apps on same IP (VHost)

## GOAL
Discover **other Host names** on this IIS (internal tools) and open them.

## TIME
~1 hour

## YOU NEED
- One working public hostname on IIS (batch 01)
- Subdomain wordlist

---

## WHY (30 seconds)

Same idea as batch 01, on purpose:  
IIS often has **public** site + **internal** site (`mssql.`, `admin.`, `intranet.`) on one IP.  

Public DNS may not list the internal name.  
You still send `Host: secret.company.com` to the public IP.  
If IIS has that binding, the internal app answers. That is **VHost hopping**.

---

## DO THIS

```bash
IP="x.x.x.x"
DOMAIN="company.com"
```

### 1) Baseline size (wrong host)

```bash
curl -sk -o /tmp/base -w "%{size_download}\n" \
  -H "Host: no-such-xyz.$DOMAIN" "http://$IP/"
# put that number in BASE below
```

### 2) Brute Host header

```bash
ffuf -u "http://$IP/" -H "Host: FUZZ.$DOMAIN" \
  -w subdomains.txt -mc all -fs BASE -t 40
```

### 3) Pin a hit in Burp (optional but easy)

Match/Replace request header:

| Field | Value |
|-------|--------|
| Match | `^Host: public\.company\.com$` |
| Replace | `Host: mssql.company.com` |
| Regex | on |

### 4) curl pin

```bash
curl -sk --resolve mssql.company.com:443:$IP "https://mssql.company.com/"
```

### 5) Write down

```text
Extra hosts:
Interesting apps:
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| New admin/db app | Soft test (version, default creds if allowed) |
| File download params | → **03** |
| No extra hosts | → **03** if file features, else **07** shortnames |

---

## NEXT
→ [03-lfi-webconfig-dll.md](./03-lfi-webconfig-dll.md)  
(or [07-shortname-fuzz.md](./07-shortname-fuzz.md) if no file features yet)

**Slide map:** deck slides 8–12 (VHost hopping, Burp match-replace, internal admin).
