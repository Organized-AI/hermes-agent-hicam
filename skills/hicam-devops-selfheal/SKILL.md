# HICAM DevOps & Self-Healing

Keeps the Hermes gateway running reliably with minimal manual intervention.

## What this includes
- **Auto-restart** — the launchd service (`ai.hermes.hicam`) is configured with
  `KeepAlive: true`, so macOS automatically restarts the gateway if it crashes.
- **Health check script** — `scripts/hermes-status.sh` reports whether the gateway
  process is alive and responding.
- **Crash log capture** — gateway stdout/stderr is written to `~/.hermes/logs/`
  for post-mortem debugging if something goes wrong.

## Manual health check
Run any time to check gateway status:
```
~/.hermes/hermes-agent/scripts/hermes-status.sh
```

## Manual restart
```
launchctl kickstart -k gui/$(id -u)/ai.hermes.hicam
```
