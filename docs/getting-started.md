---
tags:
  - Getting Started
  - Linux
---

Getting Started
===============

This page contains the most common steps for setting up and getting
started with your ORCD system account. We provide this page as a
convenient reference to get started. Each system has its own in-depth documentation which can be found on the [ORCD Systems](orcd-systems.md) page.

Getting an Account
------------------

If you don't already have an account, follow the instructions for the system you are interested in:

- Engaging and Satori: Login into the respective OnDemand Portal (below) using your MIT kerberos credentials. The system will then be prompted to create your account automatically. Wait couple minutes for the system to create all the pieces for your account before submitting your first job.
    - Engaging: [https://engaging-ood.mit.edu]
    - Satori: [https://satori-portal.mit.edu/]
- SuperCloud: Follow the instructions on the [Account Request Page](https://supercloud.mit.edu/requesting-account).
- OpenMind: OpenMind will be available to the general MIT Community starting 2024. Those currently eligable can follow the instructions on the [Getting an Account](https://github.mit.edu/MGHPCC/OpenMind/wiki/Cookbook:-Getting-started#account) page.

<!--
> To learn how to use your SuperCloud
account, complete the [Practical HPC
course](https://learn.llx.edly.io/course/practical-hpc/), which contains
the material below and more. The course will walk you through these
steps in more detail and often with videos to see how it is done. The
course is self paced, can be accessed anytime, and is kept up to date.
More reference material is available throughout site (some of this
material links to those pages).

When your account is first created you will have a small startup
allocation. Once you complete the [Practical HPC
course](https://learn.llx.edly.io/course/practical-hpc/) you can request
your account be updated to the standard allocation by sending email to
<supercloud@mit.edu>. Resource allocations are listed on the
[Systems and Software](systems-and-software.md) page.
-->

Logging In
----------

The first thing you should do when you get a new account is verify that
you can log in. The different ORCD systems provde multiple ways to log in, including both ssh and web portals. Links to instructions for the different systems are below.

- [Logging into Engaging](https://engaging-web.mit.edu/eofe-wiki/logging_in/)
- [Logging into Satori](https://mit-satori.github.io/satori-ssh.html)
- [Logging into SuperCloud](https://supercloud.mit.edu/getting-started)
- [Logging into OpenMind](https://github.mit.edu/MGHPCC/OpenMind/wiki/Getting-started#login)

<!--
Keep in mind that you will only be able to access the system from ssh
from the machine where you generated your ssh key. You will not be able
to log in until we have sent you an email stating that we have created
your account, which will contain your username.

First, add your ssh key to the web portal. Go
to [https://txe1-portal.mit.edu/](https://txe1-portal.mit.edu/). If you affiliated with MIT or another
institution/university select the middle option "MIT
Touchstone/InCommon Federation" to log in. Select your institution from
the dropdown (be aware they are spelled out, MIT is listed as
Massachusetts Institute of Technology, for example), click "Remember my
choice" box and then the "Select" button. Then log in with your
institution credentials. Once you are logged in, click on the
"sshkeys" link and paste your ssh key in the box at the bottom of the
page and click "Update Keys".

For instructions on how to generate ssh keys, retrieve your public key,
and additional troubleshooting tips, watch the videos in the "Account
Setup and SSH Keys" section in the "Getting Started" module of the
[Practical HPC course](https://learn.llx.edly.io/course/practical-hpc/),
or [see this page](requesting-account.md#generating-ssh-keys).

First open a command line terminal window where you generated your ssh
keys. Enter the following command, where `USERNAME` is your username on
the MIT SuperCloud system:

`ssh USERNAME@txe1-login.mit.edu`

If you generated your keys using PuTTY, open a PuTTY window. In the box
labeled "Host Name" enter`USERNAME@txe1-login.mit.edu`,
where`USERNAME`is your username on the MIT SuperCloud system. Keep the
ssh box checked (this should be default) and Port should be set to 22.
Click "Open" to start the session. You may also need to indicate your
private key on the Connection -\> SSH -\> Auth page.

-->

Shared HPC Clusters
-------------------

The each ORCD system is an HPC-style shared cluster. You are sharing this
resources with a number of other researchers, staff, and students so it
is important that you read this page and use the system as intended.

Being a cluster, there are several machines connected together with a
network. We refer to these as **nodes**. Most nodes in the cluster are
referred to as **compute nodes**, this is where the computation is done
on the system (where you will run your code). When you ssh into the
system you are on a special purpose node called the **login node**. The
login node, as its name suggests, is where you log in and is for editing
code and files, installing packages and software, downloading data, and
starting jobs to run your code on one of the compute nodes.

Each job is started using a piece of software called the **scheduler**,
which you can think of as a resource manager. You let it know what
resources you need and what you want to run, and the scheduler will find
those resources and start your job on them. When your job completes
those resources are relinquished. The scheduler is what ensures that no
two jobs are using the same resources, so it is very important not to
run anything unless it is submitted properly through the scheduler.

Software and Packages
---------------------

The first thing you may want to do is make sure the system has the
software and packages you need. We have installed a lot of software and
packages on the system already, even though it may not be immediately
obvious that it is there. Review the page for the system you are using paying particular attention to the section on modules and installing packages for the language that you use:

- [Engaging](https://engaging-web.mit.edu/eofe-wiki/software/)
- [Satori](https://mit-satori.github.io/satori-getting-started.html#setting-up-your-environment)
- [SuperCloud](https://supercloud.mit.edu/software-and-package-management)
- [OpenMind](https://github.mit.edu/MGHPCC/OpenMind/wiki/Getting-started#setup)

If you are ever unsure if we have a particular
software, and you cannot find it, please send us an email and ask before
you spend a lot of time trying to install it. If we have it, we can
point you to it, provide advice on how to use it, and if we don't have
it we can often give pointers on how to install it. Further, if a lot of
people request the same software, we may consider adding it to the
system image.

Linux Command Line
------------------

The MIT SuperCloud runs Linux, so much of what you do on the cluster
involves the Linux command line. That doesn't mean you have to be a
Linux expert to use the system! However the more you can get comfortable
with the Linux command line and a handful of basic commands, the easier
using the system will be. If you are already familiar with Linux, feel
free to skip this section, or skim as a refresher.

Most Linux commands deal with **directories** and **files**. A
**directory**, synonymous to a folder, contains files and other
directories. The list of directories that lead to a particular directory
or file is called its **path**. In Linux, directories on a path are
separated by forward slashes `/`. It is also important to note that
everything in Linux is case sensitive, so a file `myScript.sh` is not
the same as the file `myscript.sh`. When you first log in you are in you
**home directory**. Your home directory is where you can put all the
code and data you need to run your job. Your home directory is not
accessible to other users, if you need a space to share files with other
users, let us know and we can make a shared **group directory** for you.


<!--
The path to your home directory on SuperCloud is
`/home/gridsan/[USERNAME]`, where `[USERNAME]` is your username. The
character `~` is also shorthand for your home directory in any Linux
commands.
-->

Anytime after you start typing a Linux command you can press the "Tab"
button your your keyboard. This called tab-complete, and will try to
autocomplete what you are typing. This is particularly helpful when
typing out long directory paths and file names. Pressing "Tab" once
will complete if there is a single completion, pressing it twice will
list all potential completions. It is a bit difficult to explain in
text, but you can try it out yourself and watch the short demonstration
[here](https://en.wikipedia.org/wiki/Command-line_completion).

Finally, below is a list of Linux Commands. Try them out for yourself at
the command line.

-   Creating, navigating and viewing directories:
    -   `pwd`: tells you the full path of the directory you are
        currently in
    -   `mkdir dirname`: creates a directory with the name "dirname"
    -   `cd dirname`: change directory to directory "dirname"
        -   `cd ../`: takes you up one level
    -   `ls`: lists the files in the directory
        -   `ls -a`: lists all files including hidden files
        -   `ls -l`: lists files in "long format" including ownership
            and date of last update
        -   `ls -t`: lists files by date stamp, most recently updated
            file first
        -   `ls -tr`: lists files by dates stamp in reverse order, most
            recently updated file is listed last (this is useful if you
            have a lot of files, you want to know which file you changed
            last and the list of files results in a scrolling window)
        -   `ls dirname`: lists the files in the directory "dirname"
-   Viewing files
    -   `more filename`: shows the first part of a file, hitting the
        space bar allows you to scroll through the rest of the file, q
        will cause you to exit out of the file.
    -   `less filename`: allows you to scroll through the file, forward
        and backward, using the arrow keys.
    -   `tail filename`: shows the last 10 lines of a file (useful when
        you are monitoring a logfile or output file to see that the
        values are correct)
        -   t`ail <number> filename`: show you the last &lt;number\>
            lines of a file.
        -   `tail -f filename`: shows you new lines as they are written
            to the end of the file. Press CMD+C or Control+C to exit.
            This is helpful to monitor the log file of a batch job.
-   Copying, moving, renaming, and deleting files
    -   `mv filename dirname`: moves filename to directory dirname.
        -   `mv filename1 filename2`: moves filename1 to filename2, in
            essence renames the file. The date and time are not changed
            by the mv command.
    -   `cp filename dirname`: copies to directory dirname.
        -   `cp filename1 filename2`: copies filename1 to filename2. The
            date stamp on filename2 will be the date/time that the file
            was moved
        -   `cp -r dirname1 dirname2`: copies directory dirname1 and its
            contents to dirname2.
    -   `rm filename`: removes (deletes) the file

Transferring Files
-------------------------------------

One of the first tasks is to get your code, data, and any other files
you need into your home directory on the system. If your code is in
github you can use git commands on the system to clone your repository
to your home directory. You can also transfer your files to your home
directory from your computer by using the commands scp or rsync. Read
the page on [Transferring Files](using-the-system/files-and-data/transferring-files.md) to learn
how to use these commands and transfer what you need to your home
directory.

<!--
We can use codeblocks with tabs to show the different systems for this, maybe for ssh also.
-->

- [Engaging]()
- [Satori](https://mit-satori.github.io/satori-getting-started.html#transferring-files)
- [SuperCloud](https://supercloud.mit.edu/accessing-and-transferring-data-and-files)
- [OpenMind](https://github.mit.edu/MGHPCC/OpenMind/wiki/How-to-transfer-files%3F)

<!--
TODO: Add engaging link
-->


Testing your Code
-----------------

<!--
Running interactive jobs
-->

At this point you may want to do a test-run of your code. You always
want to start small in your test runs, so you should choose a small
example that tests the functionality of what you would ultimately like
to run on the system. If your test code is serial and runs okay on a
moderate personal laptop or desktop you can request an interactive
session to run your code in by executing the command:

`LLsub -i`

<!--
We can use codeblocks with tabs to show the different systems for this.
-->

After you run this command you will be on a compute node and you can do
a test-run of your code. This command will allocate one core to your
job. If your test code is multithreaded or parallel, or uses a lot of
memory, you should request a full node to be sure you don't impact
other jobs on the system:

`LLsub -i full`

<!--
We can use codeblocks with tabs to show the different systems for this.
-->

These commands by no means represent the full use of the system, and
most likely won't be the primary way you run your code. You can see each systems page on submitting jobs here:

- [Engaging](https://engaging-web.mit.edu/eofe-wiki/slurm/)
- [Satori](https://mit-satori.github.io/satori-workload-manager-using-slurm.html)
- [SuperCloud](https://supercloud.mit.edu/submitting-jobs)
- [OpenMind](https://github.mit.edu/MGHPCC/OpenMind/wiki/Getting-started#run)

<!--
Add links to submitting jobs pages
-->

<!--

We can put other useful info here.

SuperCloud Downtimes
--------------------

Note that SuperCloud has **Monthly Downtimes** which are scheduled for
the **Third Thursday** of each month. During downtimes the system is not
available. Downtimes usually last about a day and emails are sent when
they are complete. We also send out a reminder email a few days before
each downtime.
-->