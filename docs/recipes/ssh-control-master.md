---
tags:
 - Engaging
 - SuperCloud
 - Openmind
 - Howto Recipes
---

# Using SSH ControlMaster to streamline two factor SSH

Two factor logins for SSH login sessions add security but they can be cumbersome to work with when 
you need to create multiple login sessions. The _ControlMaster_ feature of [OpenSSH](https://www.openssh.com/) can 
be used to create multiple SSH sessions tied to a single two factor sign on. Using this feature 
means you can log in with two factor once. Then subsequent ssh login sessions will use the first 
ssh connection and two-factor will not be needed.

This page describes how to use the _ControlMaster_ feature.

## Mac/Linux use of SSH ControlMaster

On a Mac or Linux system the simplest way to use th _ControlMaster_ option is to create a section in the file `~/ssh/config` 
that activates the _ControlMaster_ feature on the nodes you use to connect. An example section is show beloW 

=== "Engaging"
    ```yaml title="config"
    Host eofe-login
      Hostname eofe10.mit.edu
      ControlMaster auto
      ControlPath ~/.ssh/%r@%h:%p
      ControlPersist 300s
      User USERNAME
    ```

=== "Satori"
    ```yaml title="config"
    Host satori-login
      Hostname satori-login-001.mit.edu
      ControlMaster auto
      ControlPath ~/.ssh/%r@%h:%p
      ControlPersist 300s
      User USERNAME
    ```

=== "Satori"
    ```yaml title="config"
    Host om-login
      Hostname openmind7.mit.edu
      ControlMaster auto
      ControlPath ~/.ssh/%r@%h:%p
      ControlPersist 300s
      User USERNAME
    ```


Replace `USERNAME` with the username you use on the system you are connecting to. In the 
configuration file examples the `ControlPersist` option is not required, but is shown to 
illustrate its use to keep the primary master connection open for a time after that login 
session is exited.

Port forwarding and X session forwarding is bound to the initial _ControlMaster_ ssh session.

## Windows/PuTTY use of SSH ControlMaster

On a Windows system the PuTTY program (free from the [Microsoft Apps store](https://apps.microsoft.com/apps)) supports 
the ControlMaster feature. Selcting the "Share SSH connections if possible" option under the "Options for controlling
SSH connections" menu item in PuTTY will enable this feature.

