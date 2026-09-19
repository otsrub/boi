#!/bin/bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$project_dir/output"
mkdir -p "$output_dir"

say -v '?' > "$output_dir/available-voices.txt"
{
  echo "Runner: ${RUNNER_OS:-macOS}"
  echo "Architecture: $(uname -m)"
  echo "macOS: $(sw_vers -productVersion)"
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Voice count: $(wc -l < "$output_dir/available-voices.txt" | tr -d ' ')"
} > "$output_dir/runner-info.txt"

cat "$output_dir/runner-info.txt"
cat "$output_dir/available-voices.txt"

