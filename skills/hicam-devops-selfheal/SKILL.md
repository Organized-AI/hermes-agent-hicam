# HICAM DevOps & Self-Healing

Keeps the Hermes gateway running reliably with minimal manual intervention.

## What this includes
- **Auto-restart** — the launchd service (`ai.hermes.hicam`) is configured with
  `KeepAlive: true`, so macOS automatically restarts the gateway if it crashes.
- **Health check script** — `scripts/hermes-status.sh` reports whether the gateway
  process is alive and responding.
- **Crash log capture** — gateway stdout/stderr is written to `~/.hermes/logs/`
  for post-mortem debugging if something goes wrong.
- **codex-self-heal.md** — diagnostic playbook for Codex/ChatGPT provider
  failures (empty responses, expired auth tokens, streaming misconfiguration).
  Only relevant if you're using Codex as your model provider.
- **slack-network-recovery.md** — diagnostic playbook for Slack gateway
  outages caused by macOS/Tailscale routing issues or Socket Mode reconnect
  failures. Only relevant if you've enabled the Slack platform connector.

## Manual health check
Run any time to check gateway status:
```
~/.hermes/hermes-agent/scripts/hermes-status.sh
```

## Manual restart
```
launchctl kickstart -k gui/$(id -u)/ai.hermes.hicam
```
