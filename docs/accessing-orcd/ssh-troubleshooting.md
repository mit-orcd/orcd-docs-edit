---
tags:
 - SSH
 - Troubleshooting
 - Logging In
---

# SSH Troubleshooting

## Connection Refused or Timeout

Make sure you are using the correct login command:
```bash
ssh [kerberos-username]@orcd-login.mit.edu
```

If the connection hangs or times out, you may be on a network that blocks SSH. Try a different network or contact [orcd-help@mit.edu](mailto:orcd-help@mit.edu).

## Permission Denied

**Check your username:** Make sure you are using your MIT Kerberos username, not your full email address.

**Check your SSH key permissions:** Run these commands on your laptop:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
```

**Key not uploaded:** If you have not yet set up SSH keys, see the [SSH Key Setup](ssh-setup.md) page.

!!! note
    Even with SSH keys set up, you will still be prompted for your MIT Kerberos password and Duo. This is expected.

## Host Key Warning

If you see a message like `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED` or `This host key is known by the following other names`, run:
```bash
ssh-keygen -R orcd-login.mit.edu
```
Then reconnect and type `yes` when prompted. This is common after system maintenance.

!!! warning
    If this happens repeatedly without any maintenance, contact [orcd-help@mit.edu](mailto:orcd-help@mit.edu).

## Too Many Authentication Failures

If you see:
```
Received disconnect from ... : Too many authentication failures
```

Add the following to your `~/.ssh/config`:
```
Host orcd-login.mit.edu
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
```

!!! note
    This setting only applies to connections to `orcd-login.mit.edu` and will not affect SSH connections to any other servers.

## Forgot SSH Key Passphrase

There is no way to recover a forgotten passphrase. Generate a new SSH key pair and upload it to Engaging following the [SSH Key Setup](ssh-setup.md) instructions.

## Dropped or Slow Connections

Add the following to your `~/.ssh/config` to keep sessions alive:
```
Host orcd-login.mit.edu
    ServerAliveInterval 60
    ServerAliveCountMax 10
```

For slow initial connections, also add `GSSAPIAuthentication no`:
```
Host orcd-login.mit.edu
    ServerAliveInterval 60
    ServerAliveCountMax 10
    GSSAPIAuthentication no
```

??? info "Other factors that can affect connection stability"
    - **Wi-Fi instability** — a flaky wireless connection will drop SSH sessions regardless of keepalive settings. Try a wired connection if you experience frequent drops.
    - **MIT VPN** — being connected to the MIT VPN can add latency depending on your network path.
    - **Server-side idle timeout** — the server may enforce its own idle timeout. Client-side keepalives help but are not a guarantee against disconnection.
    - **Large data transfers** — running a file transfer in the same session can saturate the connection and make the session appear hung. Use a separate terminal window for transfers.

## Cannot Connect to a Compute Node

Compute nodes are not directly accessible from outside the cluster, and you must have a running job on the node to connect to it. SSH to the login node first, then connect to the compute node:
```bash
ssh [kerberos-username]@orcd-login.mit.edu
ssh nodeXXXX
```

To connect directly from your laptop in one step using ProxyJump, see [Setting up your Config File](../recipes/vscode.md#setting-up-your-config-file) in the VS Code recipe for an example config.

## IP Address Blocked

If you have had repeated failed login attempts, our systems may have temporarily blocked your IP address. This will look like a connection timeout or `Connection refused` rather than an authentication error — your connection will not reach the server at all.

If you suspect your IP address has been blocked, stop attempting to connect and wait 10 minutes. The block will lift automatically if no further failed attempts are made during that time.

!!! warning
    If you have VS Code open with a Remote SSH session, it may attempt to reconnect automatically in the background, which will reset the 10-minute timer and keep the block in place. Close VS Code before waiting for the block to clear.

If the block does not clear after 10 minutes, open a ticket with [orcd-help@mit.edu](mailto:orcd-help@mit.edu) and include your IP address. You can find it with:

=== "macOS/Linux"
    ```bash
    curl ifconfig.me
    ```
=== "Windows"
    ```
    curl ifconfig.me
    ```
    If that does not work, try:
    ```
    (Invoke-WebRequest -Uri "ifconfig.me").Content
    ```

## Account Locked

10 failed Duo attempts will lock your account. This lock is managed by [MIT IS&T](https://ist.mit.edu/duo-security/duo), not ORCD, and will lift automatically after 90 minutes provided no further failed login attempts are made during that time.

!!! warning
    If you have VS Code open with a Remote SSH session, it may attempt to reconnect automatically in the background, resetting the 90-minute timer and keeping your account locked. Close VS Code before waiting for the lock to clear.

To prevent this from happening again:

- Log into [ORCD OnDemand](https://orcd-ood.mit.edu) — this satisfies Duo authentication and removes the Duo requirement for SSH for a few hours.
- Use [SSH Control Channels](control-channels.md) to reduce how often you need to authenticate with Duo.
- If you use VS Code, adjust the [VS Code Remote SSH settings](../recipes/vscode.md#adjust-the-remotessh-extension-settings).

If your account does not unlock after 90 minutes, contact [orcd-help@mit.edu](mailto:orcd-help@mit.edu).
