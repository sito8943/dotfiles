#!/bin/sh
# Claude Code status line — robbyrussell style
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=$(basename "$cwd")
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Git branch (skip optional lock to avoid conflicts)
branch=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

# Build the line
# Arrow + directory (cyan)
line=$(printf '\033[1;32m➜\033[0m  \033[0;36m%s\033[0m' "$dir")

# Git branch (blue/red) when available
if [ -n "$branch" ]; then
  line=$(printf '%s \033[1;34mgit:(\033[0;31m%s\033[1;34m)\033[0m' "$line" "$branch")
fi

# Model name
if [ -n "$model" ]; then
  line=$(printf '%s  \033[0;35m%s\033[0m' "$line" "$model")
fi

# Context usage
if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  line=$(printf '%s  ctx:%s%%' "$line" "$used_int")
fi

printf '%s' "$line"
