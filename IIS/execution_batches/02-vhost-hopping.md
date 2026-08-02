# Batch 02 — VHost hopping

## objective

Find **other Hostnames** on the same IIS IP (internal apps) and set a stable way to browse them (ffuf + Burp match-replace).

## estimated_time

60–90 minutes

## prerequisites

- Working public hostname on IIS (batch 01)
- Wordlist of subdomains

## testing_workflow

### 1) Technique A — Host brute

```bash
IP=x.x.x.x
# Capture baseline size
curl -sk -o /tmp/base -w "%{size_download}\n" -H "Host: no-such-xyz.company.com" "http://$IP/"
BASE=...

ffuf -u "http://$IP/" -H "Host: FUZZ.company.com" \
  -w subdomains.txt -mc all -fs $BASE -t 40
```

### 2) Technique B — Burp match-replace

| Type | Request header |
|------|----------------|
| Match | `^Host: apply\.company\.com$` |
| Replace | `Host: mssql.company.com` |
| Regex | on |

### 3) Technique C — curl pin

```bash
curl -sk --resolve mssql.company.com:443:$IP "https://mssql.company.com/"
```

Map any new app (login, version, product).

## decision_points

| If… | Then… |
|-----|--------|
| Internal admin/db panel | Test carefully; product CVEs |
| No extra Hosts | → **03** when you see file download params; else **07** shortnames on known host |
| File download features | → **03** |

## expected_findings

- Hidden vhosts, internal tools exposed via Host header

## next_batch_to_continue_with

→ **[03-lfi-webconfig-dll.md](./03-lfi-webconfig-dll.md)** if file params exist  
else → **[07-shortname-fuzz.md](./07-shortname-fuzz.md)** in parallel track, then return to 03 when LFI found
