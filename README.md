# Claude Code Settings

Custom configuration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI.

## Files

- `settings.json` - Global settings, permissions, hooks, plugins
- `CLAUDE.md` - Global instructions for Claude behavior
- `hooks/ghostty-notify.sh` - Ghostty notification script with click-to-focus

## Quick Setup

```bash
# Copy to ~/.claude/
cp settings.json ~/.claude/settings.json
cp CLAUDE.md ~/.claude/CLAUDE.md
mkdir -p ~/.claude/hooks
cp hooks/ghostty-notify.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/ghostty-notify.sh
```

## My Configuration

### Enabled Plugins

| Plugin | Purpose |
|--------|---------|
| `ralph-loop` | Autonomous loop for complex tasks |
| `pyright-lsp` | Python type checking via LSP |
| `typescript-lsp` | TypeScript language server |
| `code-review` | PR code review assistant |
| `security-guidance` | Security best practices |

### Hooks

**Ghostty Desktop Notifications** - OSC 9 notification with click-to-focus + audio:
```json
{
  "Notification": [{
    "matcher": "",
    "hooks": [{
      "type": "command",
      "command": "~/.claude/hooks/ghostty-notify.sh",
      "timeout": 5
    }]
  }]
}
```

The script (`hooks/ghostty-notify.sh`) uses OSC 9 escape sequences for native Ghostty notifications. Clicking the notification focuses the terminal window. Falls back to audio-only if not in Ghostty.

### Permissions

Pre-approved commands (no confirmation needed):
- `make`, `docker`, `docker compose`, `docker exec`
- `pnpm`, `pnpx`, `pnpm storybook`
- `uv run`, `uv pip`, `python`
- `ls`, `cat`, `grep`, `find`, `curl`, `echo`
- `WebSearch`

Default mode: `acceptEdits` (auto-approve file edits)

### Other Settings

- `alwaysThinkingEnabled: true` - extended thinking for complex tasks
- Custom status line via `ccstatusline`

## CLAUDE.md Instructions

Key behaviors configured:
- **Concision** - sacrifice grammar for brevity in all interactions
- **PR comments** - use checkbox markdown for TODOs
- **Changesets** - format in `.changeset/0000-your-change.md`
- **GitHub** - prefer `gh` CLI
- **Git branches** - prefix with `feature/`, `fix/`, `refactor/`
- **Plans** - end with concise unresolved questions

## Recommended Additions

### More Hooks

**Auto-format on write:**
```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
    }]
  }]
}
```

**Sound on completion:**
```json
{
  "Stop": [{
    "matcher": "",
    "hooks": [{
      "type": "command",
      "command": "afplay /System/Library/Sounds/Glass.aiff"
    }]
  }]
}
```

### MCP Servers

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "<token>" }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

### Popular MCP Servers

| Server | Purpose |
|--------|---------|
| `@modelcontextprotocol/server-github` | GitHub API |
| `@modelcontextprotocol/server-postgres` | PostgreSQL |
| `@modelcontextprotocol/server-sqlite` | SQLite |
| `@modelcontextprotocol/server-brave-search` | Web search |
| `@modelcontextprotocol/server-puppeteer` | Browser automation |
| `@modelcontextprotocol/server-memory` | Persistent notes |

## Hook Events Reference

| Event | When | Variables |
|-------|------|-----------|
| `PreToolUse` | Before tool runs | `$CLAUDE_TOOL_NAME`, `$CLAUDE_TOOL_INPUT` |
| `PostToolUse` | After tool runs | `$CLAUDE_TOOL_NAME`, `$CLAUDE_FILE_PATH` |
| `Notification` | On notification | `$CLAUDE_NOTIFICATION` |
| `Stop` | On completion | - |

## Resources

- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [MCP Servers](https://github.com/modelcontextprotocol/servers)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
