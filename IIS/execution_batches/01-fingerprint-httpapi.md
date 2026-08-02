# Batch 01 — Fingerprint IIS + HTTPAPI host rescue

## objective

Confirm the host is IIS/ASP.NET-ish, and rescue **Microsoft-HTTPAPI/2.0 404** assets by finding the correct **Host** name (do not skip “dead” IPs).

## estimated_time

60–90 minutes

## prerequisites

- In-scope IP or URL
- `curl`, optional `openssl` / `nmap`

## testing_workflow

### 1) Technique A — fingerprint

```bash
IP=x.x.x.x
curl -skI "http://$IP/"
curl -skI "https://$IP/"
# Note: Server, X-AspNet*, cookies, status
```

### 2) Technique B — HTTPAPI signal

```bash
# Looking for: Server: Microsoft-HTTPAPI/2.0 + generic 404
curl -skI "http://$IP/"
curl -skI "https://$IP/"
```

### 3) Technique C — harvest Host candidates + probe

```bash
echo | openssl s_client -connect $IP:443 -servername $IP 2>/dev/null \
  | openssl x509 -noout -text 2>/dev/null | grep -E 'DNS:|Subject:'

# Probe a candidate
curl -skI --resolve app.company.com:443:$IP "https://app.company.com/"
curl -sI -H "Host: app.company.com" "http://$IP/"
```

If name works:

```bash
echo "$IP app.company.com" | sudo tee -a /etc/hosts
# Re-run scans against the NAME not the raw IP
```

## decision_points

| If… | Then… |
|-----|--------|
| Real IIS site with hostname | → **02** VHost hop on same IP |
| Only HTTPAPI, no name yet | Host brute 20–40 min; if found → **02** |
| Clear IIS app already | Still note version; → **02** then **03** when file features appear |

## expected_findings

- Live site behind wrong Host; version headers; hosts file mapping

## next_batch_to_continue_with

→ **[02-vhost-hopping.md](./02-vhost-hopping.md)**
