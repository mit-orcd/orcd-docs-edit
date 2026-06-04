---
tags:
 - Howto Recipes
 - Best Practices
---
# VSCode Remote SSH Troubleshooting Checklist

## Basic Connection Checks

- Confirm SSH access to the remote host via terminal (`ssh user@host`)
- Ensure the remote host is reachable (`ping` or `traceroute`)
- Verify correct SSH port (default is 22 unless customized)
- Check for VPN or firewall restrictions

## Authentication & SSH Config

- Validate SSH key permissions (`chmod 600 ~/.ssh/id_rsa`)
- Ensure public key is in `~/.ssh/authorized_keys` on remote
- Check `~/.ssh/config` for correct host alias, user, and identity file
- Test with verbose SSH: `ssh -vvv user@host` for detailed logs

## VSCode-Specific Settings

- Confirm Remote-SSH extension is installed and updated
- Check `settings.json` for `"remote.SSH.path"` if using a custom SSH binary
- Use `"remote.SSH.useLocalServer": false` to disable local server if needed
- Clear SSH known hosts if fingerprint mismatch (`~/.ssh/known_hosts`)

## Cache & Lock File Cleanup

- Delete stale lock files in `.vscode-server` or `.vscode-remote` on remote
- Remove corrupted install folders: `~/.vscode-server/bin/*`
- Restart VSCode and retry connection

## Advanced Debugging

- Enable SSH logging in VSCode: `"remote.SSH.showLoginTerminal": true`
- Check logs: **Help > Toggle Developer Tools > Console**
- Use `"remote.SSH.verbose": true` in settings for more output
- Try connecting with `"remote.SSH.remotePlatform"` set explicitly (e.g., `"linux"`)

## Testing & Isolation

- Try connecting from a different machine or user account
- Use a minimal `~/.ssh/config` to isolate issues
- Temporarily disable antivirus or security software
