#!/usr/bin/env bash
# Render an HTML cover letter to PDF using headless Chrome.
# Usage: cover-letter-pdf.sh <input.html> <output.pdf>
set -euo pipefail

IN="${1:?usage: cover-letter-pdf.sh <input.html> <output.pdf>}"
OUT="${2:?usage: cover-letter-pdf.sh <input.html> <output.pdf>}"

CHROME="$(command -v google-chrome || command -v google-chrome-stable || command -v chromium || command -v chromium-browser)"
[ -n "$CHROME" ] || { echo "error: no Chrome/Chromium binary found" >&2; exit 1; }
[ -f "$IN" ] || { echo "error: input not found: $IN" >&2; exit 1; }

mkdir -p "$(dirname "$OUT")"

"$CHROME" --headless --disable-gpu --no-sandbox \
  --no-pdf-header-footer \
  --print-to-pdf="$OUT" \
  "file://$IN" >/dev/null 2>&1

[ -s "$OUT" ] || { echo "error: PDF was not created" >&2; exit 1; }
echo "Wrote $OUT"
