---
name: email-accounts
description: >-
  Read or search Hugo's work and personal Gmail from the command line. Use
  whenever the request mentions "work email", "personal email", "my email",
  "my inbox", "latest messages", or asks to check, search, or summarise mail
  for either account. Covers the gws-work / gws-personal wrappers, the account
  map, lightweight list/get recipes, and auth troubleshooting.
metadata:
  author: Hugo Åkerstrand
  version: "1.0"
---

# Email accounts

Two Gmail accounts, reached through thin shell wrappers around `gws`
(`@googleworkspace/cli`). The wrappers live in `~/.local/bin` (on `$PATH`,
symlinked from this dotfiles repo via `home.nix`).

| Wrapper | Account | Use for |
|---|---|---|
| `gws-work` | `hake@nordiccelltherapy.com` | Anything "work" - Corcellys Therapeutics, Nordic Cell Therapy Group, BII |
| `gws-personal` | `hugo.akerstrand@gmail.com` | Anything "personal" |

`gws-work` / `gws-personal` are front-ends for `gws-acct <account> <args>`, which
mints a fresh OAuth token from `~/.config/gws/<account>.json` and execs `gws`
with it. Nothing else is needed - just call the wrapper.

There is also a `mcp__claude_ai_Gmail__*` connector. It is bound to the
**personal** account only. For work, the CLI is the only path. Prefer the CLI
for both so behaviour is consistent.

## Call shape

```
gws-work    <service> <resource> [sub-resource] <method> --params '<JSON>' [--format json]
gws-personal <service> <resource> [sub-resource] <method> --params '<JSON>'
```

Gmail methods always take `"userId": "me"` in `--params`.

## Recipe: latest inbox messages

Do this in two cheap steps. Never fetch full bodies just to list what arrived.

1. List the newest message IDs:

```
gws-work gmail users messages list \
  --params '{"userId":"me","maxResults":10,"labelIds":["INBOX"]}' --format json
```

2. For each id, pull only the headers + snippet:

```
gws-work gmail users messages get \
  --params '{"userId":"me","id":"<ID>","format":"metadata","metadataHeaders":["From","Date","Subject"]}' \
  --format json
```

Parse helper (headers live in `payload.headers`):

```bash
for id in <ID1> <ID2> <ID3>; do
  gws-work gmail users messages get \
    --params "{\"userId\":\"me\",\"id\":\"$id\",\"format\":\"metadata\",\"metadataHeaders\":[\"From\",\"Date\",\"Subject\"]}" \
    --format json 2>&1 | python3 -c '
import json, sys
d = json.load(sys.stdin)
h = {x["name"]: x["value"] for x in d.get("payload", {}).get("headers", [])}
print("From:   ", h.get("From"))
print("Date:   ", h.get("Date"))
print("Subject:", h.get("Subject"))
print("Snippet:", d.get("snippet", "")[:220])
print("-" * 60)'
done
```

Present the result as a compact table (Date | From | Subject), newest first.
Only fetch a full body (`"format":"full"` or drop `format`) when the user asks
to read a specific message.

## Recipe: search

`gws-work gmail users messages list --params '{"userId":"me","q":"<gmail query>","maxResults":20}' --format json`

`q` uses normal Gmail search syntax: `from:`, `subject:`, `newer_than:7d`,
`is:unread`, `has:attachment`, `label:`, quoted phrases, `-` to exclude.

## Other services

Same wrapper, other `gws` services work too: `drive files list`,
`calendar events list`, `docs`, `sheets`. Run `gws --help` or
`gws schema <service.resource.method>` for parameters.

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `gws-acct: no credential file: ~/.config/gws/<acct>.json` | Account never exported. Have Hugo run `gws auth login` as that account, then `gws auth export --unmasked > ~/.config/gws/<acct>.json`. |
| `token mint failed` / `failed to mint access token` | Refresh token revoked or expired. Re-run the `gws auth login` + `gws auth export` step above. |
| `gws: command not found` | `@googleworkspace/cli` not installed, or `~/.local/bin` not on `$PATH`. `gws` is at `/opt/homebrew/bin/gws`; wrappers are in `~/.local/bin`. |
| Wrapper missing | `home.nix` symlinks `home/bin/gws-{acct,work,personal}` into `~/.local/bin`. Re-run the home-manager switch. |

## Source

- Wrappers: `home/bin/gws-acct`, `home/bin/gws-work`, `home/bin/gws-personal`
- Wiring: `home.nix` (`home.file.".local/bin/gws-*"`)
- Credentials: `~/.config/gws/{work,personal}.json` (git-ignored, machine-local)
