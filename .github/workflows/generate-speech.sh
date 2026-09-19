#!/bin/bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$project_dir/output"
mkdir -p "$output_dir"

if [[ -z "${TTS_TEXT:-}" ]]; then
  echo "Text cannot be empty." >&2
  exit 1
fi

if [[ ! "${TTS_RATE:-}" =~ ^[0-9]+$ ]] || (( TTS_RATE < 80 || TTS_RATE > 500 )); then
  echo "Rate must be a whole number from 80 to 500." >&2
  exit 1
fi

case "${TTS_FORMAT:-}" in
  aiff|wav|m4a) ;;
  *)
    echo "Format must be aiff, wav, or m4a." >&2
    exit 1
    ;;
esac

printf '%s' "$TTS_TEXT" > "$project_dir/input.txt"
say -v '?' > "$output_dir/available-voices.txt"

say_arguments=(-r "$TTS_RATE" -f "$project_dir/input.txt" -o "$output_dir/speech.aiff")
if [[ -n "${TTS_VOICE:-}" ]]; then
  say_arguments=(-v "$TTS_VOICE" "${say_arguments[@]}")
fi

say "${say_arguments[@]}"

case "$TTS_FORMAT" in
  wav)
    afconvert -f WAVE -d LEI16@44100 "$output_dir/speech.aiff" "$output_dir/speech.wav"
    rm "$output_dir/speech.aiff"
    ;;
  m4a)
    afconvert -f m4af -d aac -b 192000 "$output_dir/speech.aiff" "$output_dir/speech.m4a"
    rm "$output_dir/speech.aiff"
    ;;
esac

audio_file="$output_dir/speech.$TTS_FORMAT"
if [[ ! -s "$audio_file" ]]; then
  echo "Speech generation produced no audio." >&2
  exit 1
fi

{
  echo "Voice: ${TTS_VOICE:-system default}"
  echo "Rate: $TTS_RATE words per minute"
  echo "Format: $TTS_FORMAT"
  echo "Runner: macos-26"
  echo "Architecture: $(uname -m)"
  echo "macOS: $(sw_vers -productVersion)"
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
} > "$output_dir/metadata.txt"

echo "Created $audio_file ($(du -h "$audio_file" | cut -f1))."

