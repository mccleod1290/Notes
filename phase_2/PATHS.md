# Paths

One map for phase 2. Do not invent a second output folder.

`<slug>` is the topic in lowercase words joined by underscores.

```text
phase_2/output/<slug>/SOURCES.md
phase_2/output/<slug>/PAGE.md
phase_2/output/<slug>/PAGE.html
phase_2/output/<slug>/PAGE.pdf
phase_2/output/<slug>/pages.txt
phase_2/output/<slug>/EVAL.md
```

`phase_2/RULES.md` is the law. `phase_2/CRITERIA.md` is the only checklist.

## PAGE.md blocks

```text
# topic

## <one section per domain on the phase 1 map, in map order>
depth, breadth, possibilities
example, diagram, or code where a term would stop him

## references
opened urls, one line each, last section
```

No quiz. No workbook. No check block.

Section order is `order` in `phase_1/output/<slug>/MAP.md`. A domain that map dropped does not get a heading. If `MAP.md` is missing, do not write the page.

Render:

```text
python3 scripts/md_to_pdf.py phase_2/output/<slug>/PAGE.md \
  -o phase_2/output/<slug>/PAGE.pdf \
  --html phase_2/output/<slug>/PAGE.html
```

Write the `pages:` line into `pages.txt`.
