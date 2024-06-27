---
tags:
 - SSH Setup
---

# SSH Setup

An SSH key is a secure access credential used in the SSH protocol and establishes a secure and encrypted connection to our HPC systems. This page is for those who wish to implement SSH key authentication on top of general MIT Kerberos authentication.

## Checking for Existing SSH Keys

Before you generate an SSH key, you should check for existing SSH keys.  

1. Open your local terminal.  
2. Run the following command to view all existing SSH keys:  
```bash
ls -al ~/.ssh
```
3. If you see a list of files, you have existing SSH keys.
If you receive an error that ~/.ssh doesn't exist, you do not have an existing SSH key pair in the default location. You can create a new SSH key pair in the next step.

## Generating SSH Keys

If you do not have an existing SSH key follow these steps. 

1. Open your local Terminal.  
2. Run the following command to generate an RSA key:  
```bash
ssh-keygen -t rsa
```
3. **Save the key pair:** When prompted to "Enter a file in which to save the key," press Enter to accept the default location.
4. **Passphrase:** Enter a secure passphrase when prompted. 
> **This passphrase is tied to the SSH key, not your system password, so be sure to remember it.**


## Uploading SSH Key on Our Systems

To upload your SSH key on our systems, you can update the authorized_keys file via Terminal. Alternatively, for the Engaging System, you have the option to use OnDemand, and for SuperCloud, you'll fill out an SSH key addition form.

=== "Terminal"

    1. Login to an HPC system login-node using MIT Kerberos Login
    2. On your local machine, copy the contents of your public key (~/.ssh/id_rsa.pub):
    3. On the head-node, append the copied contents to the authorized_keys file:
    !!! Note
        Do not remove anything already present in the authorized_keys file.


=== "OnDemand"

    1. Use OnDemand, navigate to the file explorer, and show dot files.
    2. Edit the .ssh/authorized_keys file to add your new key. Ensure you add a new line after the existing keys if needed.


=== "SuperCloud"

    1. Fill out the SSH key addition form as per the SuperCloud requirements
    https://mit-supercloud.github.io/supercloud-docs/ssh-troubleshooting-checklist/
    https://txe1-portal.mit.edu/login/login.php?return=https%3A%2F%2Ftxe1-portal.mit.edu%2F

## Testing

1. Attempt to login: ssh your_username@cluster_address
2. If prompted for a password, the SSH key setup did not work. Recheck the steps and correct any issues.

