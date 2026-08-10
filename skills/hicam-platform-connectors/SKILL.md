# HICAM Platform Connectors

Lets you talk to Hermes through Slack, Discord, or WhatsApp instead of only
Terminal. The adapters themselves are already built into the core Hermes
engine (`plugins/platforms/slack`, `plugins/platforms/discord`,
`plugins/platforms/whatsapp`) — this skill exists to document how to turn
them on, since they're inactive until configured.

## 1. Install the messaging extras
The base install deliberately excludes messaging libraries to keep the
footprint small. Install them with:
```
~/.hermes/venv/bin/pip install -e '.[messaging]'
```
(This is done automatically by the HICAM installer when you select
Platform Connectors during setup.)

## 2. Set credentials
Each platform needs its own bot credentials, added to `~/.hermes/.env`:

**Slack** (Socket Mode)
- `SLACK_BOT_TOKEN` — bot token (`xoxb-...`) from https://api.slack.com/apps
- `SLACK_APP_TOKEN` — app-level token (`xapp-...`, needs `connections:write` scope)
- Optional: `SLACK_ALLOWED_USERS`, `SLACK_HOME_CHANNEL`

**Discord**
- `DISCORD_BOT_TOKEN` — from https://discord.com/developers/applications
- Optional: `DISCORD_ALLOWED_USERS`, `DISCORD_HOME_CHANNEL`

**WhatsApp** (via local Node.js bridge)
- `WHATSAPP_ENABLED=true`
- Requires the WhatsApp Web bridge running locally — see
  `plugins/platforms/whatsapp/plugin.yaml` in the hermes-agent-hicam repo
  for the full setup.

## 3. Enable in config
Add the platform to `~/.hermes/config.yaml`:
```yaml
gateway:
  name: hicam-hermes
  platforms: [slack]   # or [discord], [whatsapp], or a combination
```

## 4. Restart the gateway
```
launchctl kickstart -k gui/$(id -u)/ai.hermes.hicam
```

None of this is required — `$VENV/bin/hermes chat` in Terminal always
works with no platform connector configured.

## If Slack drops out
See `troubleshooting/slack-network-recovery.md` in this folder for a fast
recovery checklist covering Tailscale/macOS routing issues and Socket Mode
reconnect failures.
