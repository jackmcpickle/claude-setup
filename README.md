# Claude Code setup

My global [Claude Code](https://code.claude.com/docs) config: settings, hooks, instructions, and skills.

## Files

| Path | What it is |
|------|------------|
| `settings.json` | Global settings: permissions, hooks, plugins, model, status line |
| `CLAUDE.md` | Global instructions. Pulls in `RTK.md` |
| `RTK.md` | Tells Claude how to read rtk-condensed command output |
| `keybindings.json` | `ctrl+alt+g` opens the Orca agent view |
| `hooks/rtk-hook.sh` | PreToolUse wrapper around `rtk hook claude` that skips git commands inside agent worktrees |
| `hooks/run-ai-dev-insights.sh` + `ai-dev-insights.mjs` | Session telemetry hook. Fails open if the script or env is missing |
| `hooks/ghostty-notify.sh` | Old notification hook, not wired up in `settings.json` any more |
| `skills/` | Skills I keep locally (not from a skills registry) |
| `skills/skill-lock.json` | Lock file for registry skills (mattpocock, eliteskills.ai, neon, vercel-labs, ...) |

## Setup on a new Mac

```bash
git clone https://github.com/jackmcpickle/claude-setup ~/Projects/claude-setup
cd ~/Projects/claude-setup

mkdir -p ~/.claude/hooks ~/.claude/skills ~/.agents
cp settings.json CLAUDE.md RTK.md keybindings.json ~/.claude/
cp hooks/*.sh hooks/*.mjs ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*
cp -R skills/*/ ~/.claude/skills/
cp skills/skill-lock.json ~/.agents/.skill-lock.json
```

Then:

1. **Auth token.** `settings.json` routes Claude through Arbor's local proxy (`ANTHROPIC_BASE_URL=http://127.0.0.1:8317`). Replace the `ANTHROPIC_AUTH_TOKEN` placeholder with the Arbor key, or delete the `env` block to log in directly.
2. **Registry skills.** Reinstall each source listed in `skills/skill-lock.json`, e.g. `npx skills add mattpocock/skills`. Skills turned off in `skillOverrides` can be skipped.
3. **Tools the hooks call.** Install these or remove their hooks:
   - `rtk` and `jq`: `brew install rtk-ai/tap/rtk jq`
   - `bun` (status line runs `bunx ccstatusline`)
   - `tokenmaxer` (npm global)
   - Adrafinil app (`brew install --cask adrafinil`)
   - `~/.ai-dev-insights.env` with `INGEST_URL` / `INGEST_TOKEN` (optional)
4. **Orca hooks.** These are left out of this repo. Orca writes its own hooks into `settings.json` when it's installed.

## Notes

- `PreToolUse` runs both `rtk-hook.sh` and a bare `rtk hook claude`, so commands get rewritten twice. The bare one can probably go.
- `defaultMode: auto`, with plan mode, AskUserQuestion, cron, and notebook tools denied.
- Bundled skills and claude.ai connectors are disabled. Unused registry skills are turned off in `skillOverrides`.
