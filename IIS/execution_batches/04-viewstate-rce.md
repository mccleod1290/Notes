# Batch 04 — VIEWSTATE + machineKey → RCE path

## objective

With `validationKey` / `decryptionKey` from `web.config`, confirm VIEWSTATE usage and generate/forge a payload path (viewgen / ysoserial.net). Prefer OOB proof.

## estimated_time

60–120 minutes

## prerequisites

- machineKey values (batch 03)
- RCE in scope
- OAST

## testing_workflow

### 1) Technique A — extract keys

```bash
grep -i machineKey web.config
# validationKey, decryptionKey, validation, decryption algs
```

### 2) Technique B — find VIEWSTATE

```bash
curl -sk "https://TARGET/SomePage.aspx" | grep -o '__VIEWSTATE[^"]*' | head
```

### 3) Technique C — forge + send

Use [viewgen](https://github.com/0xacb/viewgen) or ysoserial.net per current CLI.  
Send forged `__VIEWSTATE` on a page that accepts it. Prove with OOB (`nslookup`/`curl` to collab), not destructive commands.

## decision_points

| If… | Then… |
|-----|--------|
| RCE/OOB works | Document; optional post-ex out of this kit |
| Encryption mode blocks you | Re-check decryptionKey/alg; sticky sessions on LB |
| No WebForms VIEWSTATE | Close this batch; → **05** |

## expected_findings

- Insecure deserialization RCE via known keys

## next_batch_to_continue_with

→ **[05-dnspy-dependencies.md](./05-dnspy-dependencies.md)**
