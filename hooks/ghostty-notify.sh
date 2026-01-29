#!/usr/bin/env bash
# Claude notification hook with macOS alert

if [ -t 0 ]; then
    HOOK_INPUT=""
else
    HOOK_INPUT=$(cat)
fi

if [ -n "$HOOK_INPUT" ]; then
    MESSAGE=$(echo "$HOOK_INPUT" | jq -r '.message // "Claude needs attention"')
else
    MESSAGE="Claude needs attention"
fi

# Detect current terminal
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    TERM_BUNDLE="com.mitchellh.ghostty"
elif [ -n "$ITERM_SESSION_ID" ]; then
    TERM_BUNDLE="com.googlecode.iterm2"
elif [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
    TERM_BUNDLE="com.apple.Terminal"
else
    TERM_BUNDLE="com.mitchellh.ghostty"  # fallback
fi

# Ghostty OSC 9 notification (if in Ghostty)
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    printf '\e]9;%s\a' "$MESSAGE" > /dev/tty 2>/dev/null
fi

# macOS notification with click-to-focus
if command -v terminal-notifier &> /dev/null; then
    terminal-notifier \
        -title "Claude Code" \
        -message "$MESSAGE" \
        -appIcon "/Applications/Claude.app/Contents/Resources/electron.icns" \
        -activate "$TERM_BUNDLE" \
        -sound default
else
    # Fallback to osascript (no click handling)
    osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\" sound name \"default\""
fi
