---
tags:
 - Logging in with SSH
---

# Logging in with SSH via Terminal

You can log into our systems via SSH through your local terminal. Using SSH in a terminal or command line window on your desktop is the traditional way to access HPC Systems. This method offers the most flexibility, allowing you to start interactive and batch jobs to run your code, download data, and install packages.

## Terminal by Operating System
A terminal window is a window with a command line interface. 

To log into our systems, we use the terminal to SSH into the system. SSH (Secure Shell) is the primary way to log into remote systems. Once you initiate the SSH command, the shell in your terminal will no longer run on your computer but on the remote system. Authentication is required, either using a password or SSH keys. To set up SSH keys, please refer to insert url.

Follow the directions below based on your operating system:

=== "macOS"
    Open Terminal by searching for it in Spotlight or by navigating to Applications > Utilities > Terminal.
=== "Linux"
    Open Terminal from your applications menu.
=== "Windows"
    Windows systems offer multiple terminal options: Windows Terminal, Command Prompt, and PowerShell. The best way to get a terminal depends on your version of Windows. Starting at Windows 10, the Windows Subsystem for Linux (WSL) is available, allowing you to run Linux as an application in Windows. You can also use the Windows Command Prompt if you have SSH enabled. For older versions of Windows, install a terminal program that supports bash.

    Windows 10 and Up
    You have two options:
    - Windows Command Prompt (CMD): Comes with all Windows computers and supports SSH with little to no setup. However, it lacks some tools for transferring files and uses different commands than Linux.
    - Windows Subsystem for Linux (WSL) with Ubuntu: A full Linux terminal that requires some setup but supports all commands used to interact with SuperCloud.
    
    To check if CMD has SSH enabled, run the command ssh. If SSH is not enabled, follow the instructions on this [page](https://learn.microsoft.com/en-us/windows/terminal/tutorials/ssh).

    If you want to use WSL, follow the instructions on this Page (external link) to enable WSL and install a Linux distribution of your choice. If you don't have a preference, Ubuntu is a good place to start. If you have any questions about WSL, there is a good chance they are answered in their FAQ (external link).

    Older Windows Versions
    For older Windows versions, install a terminal that supports bash and SSH, such as MobaXterm. Follow the instructions on this page to install MobaXterm and create a local shell.

    Other Notes about Windows
    Some programs may seem like valid terminals for accessing SuperCloud but are not ideal. Here are a few examples and why they are not recommended:

    - Windows Command Prompt (pre-Windows 10): Does not natively support bash or SSH commands.
    - Windows PowerShell (pre-Windows 10): Similar to Command Prompt, it does not natively support bash or SSH commands.
    - PuTTY: A GUI-based program that is tricky to set up with SSH keys and requires a separate program for file transfers.

## Logging in via SSH
Once you have your terminal set up for your specific operating system, you can use SSH to access our HPC systems. Follow the commands below for your desired system.

=== "Engaging"
    The Engaging Cluster has 4 login nodes:  
    - eofe7.mit.edu (CentOS 7)  
    - eofe8.mit.edu (CentOS 7)  
    - eofe9.mit.edu (CentOS 7)  
    - eofe10.mit.edu (Rocky 8)  
    
    To login via the command line, run the SSH command:
    ```bash 
    ssh [username]@[host]
    ```
    Replace “[username]” with your MIT Kerberos username and “[host]” with the desired login node name (e.g., ssh your_name@eofe9.mit.edu).

    Connecting to eofe9 or eofe10 requires Two-Factor Authentication.

    !!! Note
        You will be prompted to enter your MIT Kerberos password if you have not set up SSH keys. To set them up, please refer to *** Add url to SSH Key Setup ***

=== "Satori"
    Satori has two login nodes:
    - Use satori-login-001.mit.edu for submitting training jobs and related activities.
    - Use satori-login-002.mit.edu for transferring large files/datasets and compiling software.

    To login via the command line, run the SSH command:
    ```bash 
    ssh [username]@[host]
    ```
    Replace “[username]” with your MIT Kerberos username and “[host]” with the desired login node name (e.g., ssh your_name@satori-login-001.mit.edu).

=== "SuperCloud"
    The primary way to access the SuperCloud system is through ssh and requires that your public ssh-key has been added to the authorized_keys file in your SuperCloud account. Please note, if you have generated your key following the instructions at supercloud.mit.edu and sent it to supercloud@mit.edu, then it should be in place for you. If you have any issues connecting to the system, please send email to supercloud@mit.edu. Be aware that the only desktop/laptop machine you can connect from is the machine where you generated and saved your ssh keys.

    To connect to SuperCloud,

    Open a command line terminal window.
    Enter the following command, where USERNAME is your username on the SuperCloud system:
    ssh USERNAME@txe1-login.mit.edu

=== "OpenMind"
