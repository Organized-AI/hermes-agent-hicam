# Hermes Slack Gateway Network Recovery

Diagnose and recover Hermes Slack gateway outages caused by macOS/Tailscale
routing or Slack Socket Mode reconnect failures.

## When to use

Use this when Hermes' Slack replies stop, or the gateway process appears to
be running but Slack is not receiving/responding.

Common symptom:
```text
slack_bolt.AsyncApp: Failed to check the current session ... Cannot connect to host slack.com:443 ssl:default [Network is unreachable]
```

## Fast recovery checklist

1. Confirm gateway process and launchd state:
```bash
ps aux | egrep -i 'hermes_cli.main gateway|hermes-gateway|slack_bolt' | egrep -v egrep
launchctl print gui/$(id -u)/ai.hermes.hicam 2>&1 | sed -n '1,120p'
```

2. Inspect logs without dumping secrets:
```bash
tail -120 ~/.hermes/logs/gateway.log
tail -120 ~/.hermes/logs/gateway.error.log
```
Look for: Slack Socket Mode reconnect loops, `Network is unreachable`, app
token already in use / stale PID locks.

3. Test Slack and general IPv4 connectivity:
```bash
/usr/bin/nc -vz -G 5 slack.com 443
/usr/bin/curl -I --connect-timeout 10 https://slack.com/api/api.test
/usr/bin/nc -vz -G 5 1.1.1.1 443
/usr/bin/nc -vz -G 5 google.com 443
```
If Google works but Slack/1.1.1.1 fail with `Network is unreachable`,
suspect broken IPv4 routing with IPv6 still working.

4. Inspect macOS routes and interfaces:
```bash
netstat -rn -f inet | sed -n '1,80p'
route -n get default 2>&1 || true
route -n get 1.1.1.1 2>&1 || true
networksetup -getinfo Wi-Fi 2>&1 || true
tailscale debug prefs 2>/dev/null | sed -n '1,120p'
tailscale status --self
```
Important observed clue: `route -n get 1.1.1.1` can report `not in table`
even while a default route appears in `netstat`; Slack may still fail
because IPv4 routing is effectively broken.

## Tailscale exit-node fix

If the machine has no usable IPv4 route but Tailscale is up and an exit
node is available on your tailnet, route through it:
```bash
tailscale set --exit-node=<exit-node-ip-or-name> --exit-node-allow-lan-access=true
sleep 5
/usr/bin/nc -vz -G 8 1.1.1.1 443
/usr/bin/nc -vz -G 8 slack.com 443
/usr/bin/curl -I --connect-timeout 10 https://slack.com/api/api.test
```
**Caution:** setting an exit node routes *all* your outbound traffic
through that node. If the node is offline, this can break your internet
connection entirely — clear it with `tailscale set --exit-node=` if that
happens.

## Verify Slack recovered

After network recovery or a gateway restart, Slack Bolt should reconnect
automatically. Wait 10-20 seconds and check:
```bash
tail -80 ~/.hermes/logs/gateway.log
```
Success looks like:
```text
[Slack] Authenticated as @<botname> in workspace <workspace>
[Slack] Socket Mode connected
✓ slack connected
```

## Restart / launchd recovery

```bash
launchctl unload ~/Library/LaunchAgents/ai.hermes.hicam.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/ai.hermes.hicam.plist
```
A boot-out warning like `Could not find service ...` when the launchd job
is already absent is not itself a failure — it will reload and continue.
Verify the final status and the live Slack connection log lines instead
of treating that message alone as an error.

## Pitfalls

- Don't restart repeatedly before checking network — Slack Socket Mode
  often reconnects automatically once routing is fixed.
- `gateway.error.log` may include unrelated OAuth/callback noise from
  other integrations; separate that from Slack reconnect logs.
- Tailscale exit-node state can affect IPv4 routing; verify with real
  `nc`/`curl` probes rather than assuming.
- Avoid exposing Slack tokens or app tokens in logs or summaries.
