---
tags:
 - Logging In
---

# Using SSH ControlChannel to Streamline Two-Factor SSH

Two-factor logins for SSH login sessions add security but they can be cumbersome to work with when you need to create multiple login sessions. The **ControlChannel** feature of [OpenSSH](https://www.openssh.com/) can be used to create multiple SSH sessions tied to a single two-factor sign on. Using this feature means you can log in with two-factor authentication once, then subsequent ssh login sessions will use the first ssh connection and two-factor will not be needed. This will last until the initial connection is disconnected.

## Use of SSH ControlChannel

The simplest way to use the ControlChannel option is to create a section in the file `~/.ssh/config` that activates the ControlChannel feature on the nodes you use to connect. An example section is show below: 

```yaml title="~/.ssh/config"
Host orcd-login
    Hostname orcd-login.mit.edu
    ControlMaster auto
    ControlPath ~/.ssh/%r@%h:%p
    ControlPersist 300s
    User USERNAME
```

Replace `USERNAME` with the username you use on Engaging. In the 
configuration file examples the `ControlPersist` option is not required, but can be used to keep the primary connection open for a set time after that login session is exited. `ControlPersist` only works if you remain connected to the internet.

To use the ControlChannel setup ssh using the name listed in the "Host" entry, in this example `orcd-login`:

=== "First Connection"
    ```
    username@mycomputer ~ % ssh orcd-login
    (USERNAME@orcd-login.mit.edu) Password: 
    (USERNAME@orcd-login.mit.edu) Duo two-factor login for USERNAME

    Enter a passcode or select one of the following options:

    1. Duo Push to XXX-XXX-1078
    2. Phone call to XXX-XXX-1078
    3. SMS passcodes to XXX-XXX-1078

    Passcode or option (1-3): 1

    Pushed a login request to your device...
    Success. Logging you in...
    Last login: Fri Oct  3 16:02:32 2025 from 146.115.151.5
    [USERNAME@login008 ~]$ 
    ```

=== "Additional Connections"
    ```
    username@mycomputer ~ % ssh orcd-login
    Last login: Fri Oct  3 16:35:34 2025 from 146.115.151.5
    [USERNAME@login008 ~]$ 
    ```

In this case you don't need to include your username because it is included in the `~/.ssh/config` file.

Your initial connection will prompt you for your Kerberos password and Duo two-factor authentication. Additional connections will prompt you for a Kerberos password, unless you have ssh keys setup. If you have ssh keys you will only be prompted for your Kerberos password at the first login as part of the two-factor authentication, and additional connections will not require a Kerberos password.

Port forwarding and X session forwarding is bound to the initial ControlChannel ssh session.

## SSH ControlChannel and VSCode

This setup is very helpful when using Visual Studio Code's Remote - SSH extension. When VS Code connects to a remote server, it doesn't just open one connection. It opens multiple, simultaneous SSH sessions in the background to handle different tasks: one for the file explorer, one for the integrated terminal, others for language servers, debuggers, and extensions.

Without a control channel: If your server requires two-factor authentication , VS Code's attempt to open these many connections at once can trigger a "storm" of two-factor prompts. You get bombarded with notifications, and the editor may fail to connect properly.

With a control channel: The experience is completely different.  VS Code establishes the initial "master" connection, and you approve a single two-factor prompt. Every other connection VS Code needs is then instantly multiplexed through the existing socket.

There are some additional settings that make using VS Code with Engaging much easier with two-factor. See our [VS Code Tips and Tricks](https://orcd-docs.mit.edu/recipes/vscode/#other-vscode-best-practices-tips-and-tricks), particularly the "Connection Timeout" and "Max Reconnection Attempts" settings.