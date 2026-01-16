#!/usr/bin/env bash
# Ghostty OSC 9 Notification Hook for Claude Code

# Read JSON from stdin
if [ -t 0 ]; then
    HOOK_INPUT=""
else
    HOOK_INPUT=$(cat)
fi

# Extract message from JSON input
if [ -n "$HOOK_INPUT" ]; then
    MESSAGE=$(echo "$HOOK_INPUT" | jq -r '.message // "Claude needs attention"')
else
    MESSAGE="Claude needs attention"
fi

# Send OSC 9 notification if in Ghostty
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    printf '\e]9;%s\a' "$MESSAGE" > /dev/tty 2>/dev/null
fi

# Audio cue
afplay /System/Library/Sounds/Ping.aiff &
