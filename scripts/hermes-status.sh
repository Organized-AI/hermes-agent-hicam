#!/usr/bin/env bash
# HICAM Hermes health check
LABEL="ai.hermes.hicam"
if launchctl list | grep -q "$LABEL"; then
  PID=$(launchctl list | grep "$LABEL" | awk '{print $1}')
  if [ "$PID" = "-" ]; then
    echo "⚠️  $LABEL is loaded but not currently running."
    exit 1
  else
    echo "✅ $LABEL is running (pid $PID)."
    exit 0
  fi
else
  echo "❌ $LABEL is not loaded. Run the install script again or:"
  echo "   launchctl load ~/Library/LaunchAgents/ai.hermes.hicam.plist"
  exit 1
fi
