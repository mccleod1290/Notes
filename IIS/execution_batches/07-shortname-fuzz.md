# Batch 07 — Shortname enum + logical completion fuzz

## objective

Run IIS shortname discovery, then **prefix-complete** with ffuf/crunch (not blind whole-site brute).

## estimated_time

60–120 minutes

## prerequisites

- Working IIS hostname
- shortscan or IIS-ShortName-Scanner
- ffuf, optional crunch

## testing_workflow

### 1) Technique A — detect + enumerate

```bash
shortscan "https://TARGET/"
# Vulnerable: Yes! + ASPNET~1, LIDSDI~1, ...
```

### 2) Technique B — logical ffuf from prefixes

```text
LIDSDI~1 → fuzz https://TARGET/lidsFUZZ
EASYFI~1 → https://TARGET/easyFUZZ
```

```bash
ffuf -w wordlist.txt -D -e asp,aspx,ashx,asmx -t 100 -c \
  -u "https://TARGET/lidsFUZZ"
```

### 3) Technique C — tiny suffix crunch

```bash
crunch 0 3 abcdefghijklmnopqrstuvwxyz0123456789 -o 3chars.txt
ffuf -w 3chars.txt -e aspx,ashx,asp -u "https://TARGET/lidsdiFUZZ"
```

## decision_points

| If… | Then… |
|-----|--------|
| New admin/backup paths | Feed into **03** LFI / normal testing |
| Not vulnerable | Close IIS shortname track |
| High-value path found mid-batch | Pause fuzz; exploit path |

## expected_findings

- Hidden dirs/files, old apps, backup endpoints

## next_batch_to_continue_with

**Board complete** for shortname track.  
Loop to **03–06** if new paths enable LFI/XML/vendor surfaces.
