---
tags:
 - Howto Recipes
 - Best Practices
---

# Using PyCharm on Engaging

PyCharm provides an integrated development environment for users to edit their
Python code and has support for remote development via SSH. While we generally
recommend using [VS Code](vscode.md) due to its much broader set of features
while being free and open-source, some prefer the simplicity of PyCharm.
Furthermore, PyCharm has a free license for students and teachers.

To use PyCharm on the cluster, the setup is similar to [VS Code](vscode.md).
However, PyCharm uses a lot more memory and compute power to run, so it is
essential that you run it on a compute node.

!!! note
    To use PyCharm on a compute node, an SSH key is necessary. If you haven't
    set up SSH keys yet, refer to the
    [SSH Key Setup guide](../accessing-orcd/ssh-setup.md).

## Download PyCharm

Follow [this link](https://www.jetbrains.com/pycharm/download) to download and
install PyCharm on your local computer. Make sure you select the version that
matches the architecture of your machine.

## Requesting a Compute Node

To run PyCharm on a compute node, you first need to request an interactive job
with at least 4 cores on the cluster. PyCharm recommends using 4 cores so that the
application can run more quickly. Request more resources as required by your code.

```bash
salloc -N 1 -n 4 --mem-per-cpu=4G -p mit_normal
```

!!! note
    PyCharm is not supported on Centos7 nodes.

## Editing your SSH Config File

Once you are in the interactive session, make a note of the node you are running
on. We now want to edit our local SSH `config` file so that PyCharm can run on
that node. To do this, open the command line and locate your `config` file. It
is usually located in `~/.ssh/config`. Using your favorite editor, paste the
following (enter your username and the correct node number):

```yaml title="config"
Host engaging-compute
  User USERNAME
  HostName nodeXXXX
  ProxyJump orcd-login001.mit.edu
```

!!! note
    If you don't want to edit your `config` file every time you start up a
    PyCharm session, you can request a specific node each time you start an
    interactive session with the flag `--nodelist=nodeXXXX`. Just make sure that
    the node in your config file reflects the node that you're requesting.
    However, the node you're requesting may be unavailable, in which case you'll
    have to choose a different node and edit your `config` file anyway.

## Starting PyCharm

PyCharm can be finnicky with Duo authentication. To get around
this, connect to the [MIT VPN](https://ist.mit.edu/vpn) so that Duo is not
required.

Open PyCharm and click Remote Development > SSH on the left-hand side:

![PyCharm remote development](../images/pycharm/pycharm_remote_dev.png)

Create a new project and connect to SSH. Enter your username and host name (in
this case it's `engaging-compute`), then click "Check Connection and Continue":

![Setting up SSH connection on PyCharm](../images/pycharm/pycharm_connect_ssh.png)

This will open a new page where you will enter your project directory. Enter
the path to the directory on Engaging that you'd like to work in. You are likely
to get the most success if you point PyCharm to a blank directory (I've named
mine `pycharm` for now). Click "Download IDE and Connect":

![Entering your project directory on PyCharm](../images/pycharm/pycharm_choose_ide.png)

## Troubleshooting

If you are still running into issues, try deleting the JetBrains cache in your
home directory on the cluster via the command line:

```bash
rm -r ~/.cache/JetBrains
```
