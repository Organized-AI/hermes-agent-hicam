# HICAM Content & Document Tools

Lets Hermes generate and organize written documents and notes from what it's
ingested — meeting summaries, follow-up drafts, research write-ups.

## What this includes
- **Document generation** — ask Hermes to draft a summary, memo, or follow-up
  based on recent ingested call transcripts.
- **Notes organization** — Hermes can file generated notes into
  `~/.hermes/notes/` by topic.
- **Obsidian integration** (optional) — `obsidian/SKILL.md` in this folder
  lets Hermes read, search, create, and edit notes directly in an Obsidian
  vault if you use one. Set `OBSIDIAN_VAULT_PATH` in `~/.hermes/.env` to
  point at your vault; otherwise it falls back to
  `~/Documents/Obsidian Vault`. If you don't use Obsidian, ignore this file.

## Example
```
hermes chat
> Summarize the last three calls with [person] and draft a follow-up email.
```

No additional credentials required.
