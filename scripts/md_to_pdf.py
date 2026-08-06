#!/usr/bin/env python3
"""Markdown → PDF for Notes vault (WeasyPrint). Usage: md_to_pdf.py IN.md -o OUT.pdf"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import markdown
from weasyprint import HTML

CSS = """
@page { margin: 1.5cm; size: A4; }
body { font-family: DejaVu Sans, sans-serif; font-size: 10.5pt; line-height: 1.35; color: #111; }
h1 { font-size: 16pt; border-bottom: 1px solid #333; padding-bottom: 0.3em; }
h2 { font-size: 13pt; margin-top: 1.2em; }
h3 { font-size: 11.5pt; }
code, pre { font-family: DejaVu Sans Mono, monospace; font-size: 9pt; }
pre { background: #f4f4f4; padding: 0.6em; overflow-wrap: break-word; white-space: pre-wrap; }
table { border-collapse: collapse; width: 100%; margin: 0.8em 0; font-size: 9.5pt; }
th, td { border: 1px solid #ccc; padding: 0.35em 0.45em; vertical-align: top; }
th { background: #eee; }
a { color: #0645ad; }
"""


def convert(md_path: Path, pdf_path: Path) -> None:
    body = markdown.markdown(
        md_path.read_text(encoding="utf-8"),
        extensions=["tables", "fenced_code", "nl2br"],
    )
    doc = (
        "<!DOCTYPE html><html><head><meta charset='utf-8'>"
        f"<style>{CSS}</style></head><body>{body}</body></html>"
    )
    HTML(string=doc, base_url=str(md_path.resolve().parent)).write_pdf(str(pdf_path))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("input")
    ap.add_argument("-o", "--output", required=True)
    args = ap.parse_args()
    md_path = Path(args.input)
    pdf_path = Path(args.output)
    if not md_path.is_file():
        print(f"missing: {md_path}", file=sys.stderr)
        return 1
    convert(md_path, pdf_path)
    print(pdf_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
