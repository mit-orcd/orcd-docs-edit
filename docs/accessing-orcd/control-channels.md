---
tags:
 - Engaging
 - Howto Recipes
---

# Using SSH ControlChannel to Streamline Two Factor SSH

Two factor logins for SSH login sessions add security but they can be cumbersome to work with when 
you need to create multiple login sessions. The _ControlChannel_ feature of [OpenSSH](https://www.openssh.com/) can 
be used to create multiple SSH sessions tied to a single Two Factor sign on. Using this feature 
means you can log in with Two Factor authentication once, then subsequent ssh login sessions will use the first ssh connection and Two Factor will not be needed. This will last until the initial connection is disconnected.

This page describes how to use the _ControlChannel_ feature.

## Use of SSH ControlChannel

The Simplest way to use th _ControlChannel_ option is to create a section in the file `~/.ssh/config` that activates the _ControlChannel_ feature on the nodes you use to connect. An example section is show below: 

```yaml title="~/.ssh/config"
Host orcd-login
    Hostname orcd-login.mit.edu
    ControlMaster auto
    ControlPath ~/.ssh/%r@%h:%p
    ControlPersist 300s
    User USERNAME
```

Replace `USERNAME` with the username you use on Engaging. In the 
configuration file examples the `ControlPersist` option is not required, but is shown to 
illustrate its use to keep the primary connection open for a time after that login 
session is exited.

To use the *ControlChannel* setup ssh using the name listed in the "Host" entry, in this example `orcd-login`:

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

Your initial connection will prompt you for your Kerberos password and Duo Two-Factor authentication. Additional connections will prompt you for a Kerberos password, unless you have ssh keys setup. If you have ssh keys you will only be prompted for your Kerberos password at the first login as part of the Two-Factor authentication, and additional connections will not require a Kerberos password.

Port forwarding and X session forwarding is bound to the initial _ControlChannel_ ssh session.

