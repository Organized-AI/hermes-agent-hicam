---
name: codex-self-heal
description: Diagnose and self-heal Codex API failures (empty responses, auth errors, streaming issues). Use when Codex/GPT returns errors or empty responses.
version: 1.0.0
metadata:
  hermes:
    tags: [codex, self-heal, diagnostics, reliability]
    auto_trigger:
      on_error: ["response.output is empty", "codex_refresh_failed", "Invalid API response"]
---

# Codex Self-Heal

Automatically diagnose and recover from Codex API failures. Only relevant if
you've configured Codex/ChatGPT as a model provider — skip this if you're
using a different provider.

## Known Issues & Fixes

### 1. Empty Response Output (response.output is empty)

**Root cause**: The Codex Responses API streams text via `output_text.delta`
events but sends `output: []` in the `response.completed` event. The OpenAI
SDK's `get_final_response()` returns the empty output instead of
accumulating deltas.

**Self-heal**: A patch in `run_agent.py` accumulates delta text during
streaming and reconstructs `response.output` when the API returns it empty.
If this fails:
```bash
# Check the patch is in place (should return >= 6)
grep -c "_codex_accumulated_text" ~/.hermes/hermes-agent/run_agent.py

# Check for syntax errors
python3 -c "import py_compile; py_compile.compile('run_agent.py', doraise=True)"

# Clear bytecode cache and restart
find ~/.hermes/hermes-agent -name "__pycache__" -exec rm -rf {} +
launchctl unload ~/Library/LaunchAgents/ai.hermes.hicam.plist
launchctl load ~/Library/LaunchAgents/ai.hermes.hicam.plist
```

### 2. Auth Token Expired (codex_refresh_failed, 401)

**Root cause**: Codex OAuth tokens expire. The refresh token can become
exhausted.

**Self-heal steps**:

Step 1 — try refreshing the token programmatically:
```bash
cd ~/.hermes/hermes-agent && venv/bin/python3 -c "
from hermes_cli.auth import refresh_codex_oauth_pure, _read_codex_tokens, _save_codex_tokens
data = _read_codex_tokens()
tokens = data['tokens']
new = refresh_codex_oauth_pure(tokens['access_token'], tokens['refresh_token'])
_save_codex_tokens(new)
print('Token refreshed successfully')
"
```

Step 2 — if refresh fails with `invalid_grant`, re-authenticate via the
device code flow: run `hermes setup` interactively.

Step 3 — reset exhausted credential status:
```bash
hermes auth reset openai-codex
```

Step 4 — restart the gateway:
```bash
launchctl unload ~/Library/LaunchAgents/ai.hermes.hicam.plist
launchctl load ~/Library/LaunchAgents/ai.hermes.hicam.plist
```

### 3. Streaming Must Be Enabled

**Root cause**: Codex API requires `stream: true`. If `streaming.enabled:
false` in config.yaml, responses break.

**Fix**: Verify and fix streaming config:
```bash
# Check current setting
grep -A1 "^streaming:" ~/.hermes/config.yaml
# Must show: enabled: true

# Fix if needed
sed -i '' 's/enabled: false/enabled: true/' ~/.hermes/config.yaml
```

## Diagnostic Checklist

When Codex errors occur, run through this in order:

1. **Check error logs**: `tail -20 ~/.hermes/logs/errors.log`
2. **Check auth status**: `hermes auth list` (look for "exhausted")
3. **Test token refresh**: run the refresh script from step 2 above
4. **Check streaming config**: must be `enabled: true`
5. **Check self-heal patch**: `grep -c "_codex_accumulated_text" ~/.hermes/hermes-agent/run_agent.py` (should be >= 6)
6. **Clear caches**: `find ~/.hermes/hermes-agent -name "__pycache__" -exec rm -rf {} +`
7. **Restart gateway**: unload then load the launchd plist
