#!/usr/bin/env bash

set -u

DIR="$HOME/.local/state/nvim"
THRESHOLD=102400

if [[ ! -d "$DIR" ]]; then
  exit 0
fi

find "$DIR" -type f -name "*.log" -size "+${THRESHOLD}c" -print0 2>/dev/null |
  while IFS= read -r -d '' file; do
    # echo "清空中：$file ($(du -h "$file" | cut -f1))"   # 可以先注释掉
    truncate -s 0 "$file"
  done
