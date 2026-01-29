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

if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    # OSC 9 notification - Ghostty tracks originating surface for click-to-focus
    # Note: Split pane targeting pending upstream fix (ghostty-org/ghostty#10445)
    printf '\e]9;%s\a' "$MESSAGE" > /dev/tty 2>/dev/null
    # Play notification sound (OSC 9 is silent)
    afplay /System/Library/Sounds/Glass.aiff &
elif [ -n "$ITERM_SESSION_ID" ] || [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
    # Other terminals: use terminal-notifier or osascript fallback
    if command -v terminal-notifier &> /dev/null; then
        terminal-notifier \
            -title "Claude Code" \
            -message "$MESSAGE" \
            -appIcon "/Applications/Claude.app/Contents/Resources/electron.icns" \
            -activate "$TERM_BUNDLE" \
            -sound default
    else
        osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\" sound name \"default\""
    fi
fi
