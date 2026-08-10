# HICAM Platform Connectors

Enables talking to Hermes through chat platforms rather than only Terminal.

## Included
- **Slack** (Socket Mode) — invite the Hermes bot to a channel and DM it directly.
  Requires `SLACK_BOT_TOKEN` and `SLACK_TEAM_ID` set in `~/.hermes/.env`.
- **Discord** — requires a bot token set as `DISCORD_BOT_TOKEN`.
- **WhatsApp** (bridge) — requires additional setup; see Hermes upstream docs at
  `gateway/platforms/whatsapp.py` for the pairing flow.

## Setup
1. Create bot credentials for whichever platform(s) you want (Slack app, Discord
   bot, etc.)
2. Add tokens to `~/.hermes/.env`
3. Restart the gateway: `launchctl kickstart -k gui/$(id -u)/ai.hermes.hicam`

None of these are required — you can always talk to Hermes via `hermes chat` in
Terminal without configuring any platform connector.
