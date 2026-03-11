#!/usr/bin/env bash
#
# Build the .mcpb bundle for the Email for Claude extension.
#
# Usage:
#   ./build.sh            # produces email-mcp.mcpb
#   ./build.sh --install  # builds then opens the bundle to install in Claude Desktop
#
set -euo pipefail

BUNDLE_NAME="email-mcp"
OUT="${BUNDLE_NAME}.mcpb"

echo "==> Building ${OUT} ..."

# Clean previous build
rm -f "$OUT"

# Pack the bundle (it's just a ZIP with a different extension)
zip -r "$OUT" \
  manifest.json \
  server/ \
  pyproject.toml \
  README.md \
  -x "*.pyc" "__pycache__/*" ".git/*" "*.mcpb" "build.sh" ".gitignore"

echo "==> Created ${OUT} ($(du -h "$OUT" | cut -f1))"

if [[ "${1:-}" == "--install" ]]; then
  echo "==> Opening ${OUT} for installation ..."
  case "$(uname)" in
    Darwin) open "$OUT" ;;
    Linux)  xdg-open "$OUT" 2>/dev/null || echo "Open ${OUT} manually in Claude Desktop." ;;
    MINGW*|MSYS*|CYGWIN*) start "$OUT" ;;
  esac
fi

echo "Done."
