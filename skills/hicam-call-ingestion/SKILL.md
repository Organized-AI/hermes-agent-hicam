# HICAM Call & Meeting Ingestion

Ingests recorded call and meeting transcripts (Zoom, Google Meet, or Granola) into
Hermes as documents it can reason over. This is the core capability of the HICAM
brain deployment — Hermes uses ingested transcripts as durable memory of past
conversations.

## How it works
1. A platform-specific adapter (see `zoom/`, `meet/`, `granola/`, or `other/`) pulls
   or receives a transcript from the configured call platform.
2. The transcript is normalized to plain text with speaker labels where available.
3. The document is written to `~/.hermes/inbox/` and picked up by Hermes' standard
   document ingestion pipeline, becoming part of searchable state.

## Configuration
Only one adapter subfolder is active at a time, chosen during the intake form at
setup (hicam.organizedai.vip). See that subfolder's `config.yaml` for adapter-specific
setup steps (OAuth credentials, desktop app requirements, etc.).

## Manual ingestion (any platform)
Regardless of which adapter is configured, you can always drop a `.txt` or `.md`
transcript file directly into `~/.hermes/inbox/` and Hermes will pick it up on its
next poll cycle.
