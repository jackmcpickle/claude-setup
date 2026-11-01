#!/bin/sh
# Wraps `rtk hook claude`. Claude Code's worktree-isolation guard refuses
# `rtk git ...` inside isolated agent worktrees, so leave any command that
# runs git (at any command position, e.g. `cd x && git ...`) unrewritten
# there. Everywhere else, rtk rewrites as normal.
input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.cwd // ""')
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

case "$cwd" in
  */.claude/worktrees/*)
    if printf '%s' "$cmd" | grep -Eq '(^|[;&|(])[[:space:]]*git([[:space:]]|$)'; then
      printf '{}\n'
      exit 0
    fi
    ;;
esac

printf '%s' "$input" | rtk hook claude
