# hermes-agent-hicam

A trimmed deployment of [Hermes Agent](https://github.com/NousResearch/hermes-agent)
(MIT licensed, © Nous Research) configured as the HICAM Foundation's Hermes brain.

This is the exact upstream Hermes engine — gateway, agent core, CLI — with:
- Organized AI's client-specific skills, plugins, and tooling **excluded**
- HICAM-specific skills added under `skills/hicam-*`:
  - `hicam-call-ingestion` — Zoom / Google Meet / Granola transcript ingestion
    (the core capability; always installed)
  - `hicam-platform-connectors` — Slack / Discord / WhatsApp
  - `hicam-devops-selfheal` — auto-restart, health checks
  - `hicam-browser-web` — web fetch and research tooling
  - `hicam-content-docs` — document generation and notes

## Install
Don't clone this manually — use the generated one-line installer from
https://hicam.organizedai.vip, which configures only the skills you select
during setup and wires up the launchd service automatically.

## Manual setup (advanced)
```
git clone https://github.com/Organized-AI/hermes-agent-hicam.git ~/.hermes/hermes-agent
cd ~/.hermes/hermes-agent
pip install -e . --no-deps
```
Then configure `~/.hermes/config.yaml` and the relevant `skills/hicam-call-ingestion/<platform>/config.yaml`.

## License
MIT — see LICENSE. Upstream project: https://github.com/NousResearch/hermes-agent
