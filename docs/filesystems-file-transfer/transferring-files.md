# Transferring Files

There are a few different ways to transfer files depending on your goals, the data you are transferring, and what you are comfortable with. On this page we cover the different methods of transferring files, as well as touch on how to transfer files between systems.

We recommend using [OnDemand](#ondemand) for every-day file transfer and [Globus](#globus) for transferring large files or large numbers of files. For those who prefer to use the command line you can use [scp or rsync](#command-line).

For system-specific information on transferring files for Satori, SuperCloud, or OpenMind, click on one of the following tabs. This page discusses transferring files for Engaging.

=== "Satori"

    [Satori Transferring Files Documentation Page](https://mit-satori.github.io/satori-getting-started.html#transferring-files)

=== "SuperCloud"

    [SuperCloud Transferring Files Documentation Page](https://supercloud.mit.edu/accessing-and-transferring-data-and-files)

=== "OpenMind"

    [OpenMind Transferring Files Documentation Page](https://github.mit.edu/MGHPCC/OpenMind/wiki/How-to-transfer-files%3F)

## OnDemand

Engaging and Satori both have an OnDemand web portal. SuperCloud has its own custom portal.

=== "Engaging"

    [Engaging OnDemand Portal](https://engaging-ood.mit.edu/)

=== "Satori"

    [Satori OnDemand Portal](https://satori-portal.mit.edu/)

=== "SuperCloud"
    [SuperCloud Web Portal](https://txe1-portal.mit.edu) ([Documentation](https://mit-supercloud.github.io/supercloud-docs/transferring-files/#downloading-files-through-the-web-portal))

With the Engaging and Satori OnDemand portals you can do the following using the File Browser:

- Upload and download files and directories
- Rename, move, and delete files and directories
- View and edit files

Once you are logged into OnDemand, you can use the File Browser by selecting Files -> Home Directory in the menu bar at the top left of the page.

To upload and download you can drag and drop files and directories between your File Browser window and your desktop Finder/Explorer windows. You can also use the "Upload" and "Download" buttons. Select multiple files by holding the Control (or Command) key and clicking on the files you'd like to select. Those files can then be downloaded with the "Download" button.

### Viewing and Editing Files

The File Browser is also the easiest way to view and edit files in place. Click on the file that you would like to view or edit. Then click either the "View" or "Edit" buttons directly above the list of files.

The editor has some nice features like line numbers and syntax highlighting for most languages. You can also change the display colors, the font size, and whether you'd like the words to wrap. Click "Save" to save any edits you made.

## Globus

If you are moving more than a few files, or your files are particularly large, we recommend using Globus. Globus is a tool that helps transfer large amounts of data between systems. Some advantages of using Globus are:

- It is easy to initiate transfers through the Globus webpage
- You don't need to stay logged into Globus through the entire transfer
- If your transfer is interrupted it will continue automatically where it left off once the connection is re-established

To transfer data:

1. **Log in:** Log into [Globus](https://www.globus.org/) with your MIT credentials.
2. **Select your source and destination collections:** In the "File Manager" tab in each of the two "Collection" boxes search for the collection(s) for the system(s) you want to transfer data to or from (see below for a list of ORCD  Collections).
3. **Navigate to your source and destination directories:** On the source side navigate to the source directory and select the files and/or directories you'd like to transfer. On the destination side navigate to the location where you'd like to copy your files
4. **Select any additional settings:** Click on "Transfer and Timer Options" for additional settings, such as syncing new or changed files and scheduling recurring transfers.
5. **Initiate the transfer:** Once you have selected the files and options you want, press the "Start" button on the source column.
6. **Monitor your transfer (optional):** Click on "Activity" to view the status of your active transfers. You will also get an email when you transfer is complete, or if Globus runs into any issues with the transfer.

The Globus Documentation has a [tutorial](https://docs.globus.org/guides/tutorials/manage-files/transfer-files/) with screenshots to demonstrate this process.

Here is a list of Globus Collections on ORCD systems:

| System | Globus Collection | 
| ----------- | ----------- |
| Engaging | MIT ORCD Engaging Collection | 
| Satori | mithpc#satori | 
| OpenMind | mithpc#openmind | 

To transfer data to or from your own computer you will need to set up Globus Connect Personal. Follow the instructions on the page for your system listed [here](https://docs.globus.org/globus-connect-personal/).

More documentation on transferring files through Globus can be found on the [Globus Documentation Pages](https://docs.globus.org/guides/tutorials/manage-files/transfer-files/). Globus also has an [FAQ](https://docs.globus.org/faq/transfer-sharing/) that is helpful for answering any questions you might have.

## Command Line

The most common commands used to transfer files are `scp` and `rsync`. You will need to run both of these commands from your local computer, before logging into any ORCD system. In order to use these two commands you will need:

- The hostname of the remote machine you are transferring files to or from, these are listed below
- The full path on the remote machine where you are copying the file to or from
- The ability to ssh to the remote machine where you are transferring files to or from

The hostname of the node where you will be transferring files is often a login node, but may also be a dedicated data transfer node. Select the system you are using to see options for the hostname here:

=== "Engaging"

    - `orcd-login001.mit.edu`
    - `orcd-login002.mit.edu`
    - `orcd-login003.mit.edu`
    - `orcd-login004.mit.edu`

=== "Satori"

    - `satori-login-001.mit.edu`
    - `satori-login-002.mit.edu`

=== "OpenMind"

    - `openmind-dtn.mit.edu`

=== "SuperCloud"

    - `txe1-login.mit.edu`

Both `scp` and `rsync` work similar to `cp`, in that you specify a source (where the file is coming from) and destination (where the file is going to). The main difference is that you will need to specify the hostname of the remote system.

```bash
# using cp to copy files within the same system
cp /path/to/source /path/to/destination

# using scp to copy files from the local system to <hostname>
scp /path/to/source <hostname>:/path/to/destination

# using scp to copy files from <hostname> to the local system
scp <hostname>:/path/to/source /path/to/destination
```

Unless you have your paths memorized, the easiest way to do this is to have two terminals open. The first terminal is logged into Engaging or other remote system, the second is on your local computer. In each navigate to the respective source and destination directories. In the Engaging tab you can run the `pwd` command to print out the path to your current location and copy the output to use in the `scp` or `rsync` command.

### scp

First, open a terminal on your computer (not logged into any ORCD system).

To transfer a file from your local computer to an ORCD system you would use the command:

=== "Engaging"

    ``` bash
    scp <local-file-name> USERNAME@orcd-login001.mit.edu:<path-to-engaging-dir>
    ```

=== "Satori"

    ``` bash
    scp <local-file-name> USERNAME@satori-login-001.mit.edu:<path-to-satori-dir>
    ```
=== "OpenMind"

    ``` bash
    scp <local-file-name> USERNAME@openmind-dtn.mit.edu:<path-to-openmind-dir>
    ```

=== "SuperCloud"

    ``` bash
    scp <local-file-name> USERNAME@txe1-login.mit.edu:<path-to-supercloud-dir>
    ```

For example, let's say you have the local file `myscript.py` and you want to transfer it to the directory `mycode` in your home directory. The command would be:

=== "Engaging"

    ``` bash
    scp myscript.py USERNAME@orcd-login001.mit.edu:/home/USERNAME/mycode/
    ```

=== "Satori"

    ``` bash
    scp  myscript.py USERNAME@satori-login-001.mit.edu:/home/USERNAME/mycode/
    ```
=== "OpenMind"

    ``` bash
    scp  myscript.py USERNAME@openmind-dtn.mit.edu:/home/USERNAME/mycode/
    ```

=== "SuperCloud"

    ``` bash
    scp myscript.py USERNAME@txe1-login.mit.edu:/home/gridsan/USERNAME/mycode/
    ```

To transfer the other direction (from an ORCD system to your local computer) switch the order:

=== "Engaging"

    ``` bash
    scp USERNAME@orcd-login001.mit.edu:<path-to-engaging-file> <path-to-local-dir>
    ```

=== "Satori"

    ``` bash
    scp USERNAME@satori-login-001.mit.edu:<path-to-satori-file> <path-to-local-dir>
    ```
=== "OpenMind"

    ``` bash
    scp USERNAME@openmind-dtn.mit.edu:<path-to-openmind-file> <path-to-local-dir>
    ```

=== "SuperCloud"

    ``` bash
    scp USERNAME@txe1-login.mit.edu:<path-to-supercloud-file> <path-to-local-dir>
    ```

If you were to have the file `results.csv` that you want to copy from the `output` directory in your remote home directory to the current directory on your computer the command would be:

=== "Engaging"

    ``` bash
    scp USERNAME@orcd-login001.mit.edu:/home/USERNAME/output/results.csv .
    ```

=== "Satori"

    ``` bash
    scp USERNAME@satori-login-001.mit.edu:/home/USERNAME/output/results.csv .
    ```
=== "OpenMind"

    ``` bash
    scp USERNAME@openmind-dtn.mit.edu:/home/USERNAME/output/results.csv .
    ```

=== "SuperCloud"

    ``` bash
    scp USERNAME@txe1-login.mit.edu:/home/gridsan/USERNAME/output/results.csv .
    ```

Note the `.` in the command above means the current directory.

Similar to the `cp` command, if you want to transfer an entire directory and all of its subdirectories, use the `-r` (recursive) flag for either direction:

=== "Engaging"

    ``` bash
    scp -r <local-directory-name> USERNAME@orcd-login001.mit.edu:<path-to-engaging-dir>
    ```

=== "Satori"

    ``` bash
    scp -r <local-directory-name> USERNAME@satori-login-001.mit.edu:<path-to-satori-dir>
    ```
=== "OpenMind"

    ``` bash
    scp -r <local-directory-name> USERNAME@openmind-dtn.mit.edu:<path-to-openmind-dir>
    ```

=== "SuperCloud"

    ``` bash
    scp -r <local-directory-name> USERNAME@txe1-login.mit.edu:<path-to-supercloud-dir>
    ```

!!! note
    To `scp` files to/from the login nodes on Engaging, you will need to
    authenticate with Duo. You may get a Duo push without any indication from the command line.

### rsync

The use of `rsync` is very similar to `scp`, but the behavior is different. By default `rsync` will not transfer files that are identical at both the source and destination. There are additional flags you can use to specify what `rsync` should do when files differ. The `rsync` command can be very useful when you want to "sync" updates to a directory or when transferring large directories. If a transfer fails during `rsync` you can re-run the command and it will pick up where it left off, rather than re-transfer everything.

For general use, the example commands above for `scp` apply, use the same command but replace `scp` with `rsync`.

Some useful flags include:

- `-r`, `--recursive` to recursively copy files in all sub-directories
- `-l`, `--links` to copy and retain symbolic links
- `-u`, `--update` skips any files for which the destination file already exists and has a date later than the source file
- `-v`, `--verbose` prints out more information during the file transfer, add more `v`s for more information
- `--partial` keeps partially transferred files, useful when transferring large files so rsync can continue where it left off if the transfer fails
- `--progress` prints information about the progress of the transfer
- `-n`, `--dry-run` does not run the transfer but prints out what actions it would be taken, useful to avoid unintended file overwrites

You can run `rsync --help` to print out a full list of flags that can be used with the `rsync` command.

!!! note
    To `rsync` files to/from the login nodes on Engaging, you will need to
    authenticate with Duo. You may get a Duo push without any indication from the command line.

### Moving files between ORCD Systems

If you need to move files between ORCD systems you ssh to one of the ORCD systems and initiate the transfer from that system to the other. Once you are logged into one system the process is the same as if you were to transfer files to or from your own computer. For example to move a file from Satori to Engaging using `scp` you would first log into Satori and then use `scp` to transfer the file:
```bash title="Transferring files from Engaging to Satori"
ssh USERNAME@satori-login001.mit.edu
scp <path-to-satori-file> USERNAME@orcd-login001.mit.edu:<path-to-engaging-directory>
```
You can also `ssh` into Engaging and initiate the transfer from there using a similar command.

## Graphical Applications for File Transfer

There are a few applications you can download that will allow you to transfer files with  drag-and-drop, similar to how you would move files around on your own computer.

Some of the most common options are:

- [Cyberduck](https://cyberduck.io/) (Mac and Windows)
- [FileZilla](https://filezilla-project.org/) (Mac, Windows, and Linux)
- [WinSCP](https://winscp.net/eng/index.php) (Windows only)

To use these you will need to know the hostname of the ORCD system you are accessing, either one of the login nodes or a dedicated data transfer node. See the list of hostnames at the top of this page to see which you should use for the system you are transferring files to.



