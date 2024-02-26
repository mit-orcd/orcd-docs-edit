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

On a Mac or Linux system the simplest way to use th _ControlMaster_ option is to create an alias in the file `~/ssh/config` 

## Windows/PuTTY use of SSH ControlMaster

