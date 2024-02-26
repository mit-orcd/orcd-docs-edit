---
tags:
 - Engaging
 - SuperCloud
 - Openmind
 - Howto Recipes
---

# Using SSH ControlMaster to work with two factor SSH efficiently

Two factor logins for SSH login sessions add security but they can be cumbersome to work with when 
you need to create multiple login sessions. The _ControlMaster_ feature of [OpenSSH](https://www.openssh.com/) can 
be used to create multiple SSH sessions tied to a single two factor sign on. Using this feature 
means you can log in with two factor once, but then have subsequent ssh sessions use the first 
ssh connection. 

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


Replace `USERNAME` with your username on the system you are connecting to.

## Windows/PuTTY use of SSH ControlMaster

