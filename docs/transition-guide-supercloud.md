# SuperCloud to Engaging Transition Guide

Updates to SuperCloud's access policies mean that starting May 1 access to SuperCloud will be limited to Lincoln Laboratory collaborators. As ORCD expands Engaging we welcome any MIT researchers who are not Lincoln collaborators and are looking for a place to run their computational workloads. The ORCD team is here to help make that transition as smooth as possible.

This page is maintained to answer questions and document how to migrate to ORCD's Engaging system. We will continue to update this page with answers to more questions and documentation.

## Frequently Asked Questions

### What are my options?

There are other computing options available to the MIT community. ORCD runs the Engaging system which has both resources available to the entire MIT community and resources purchased by individual PIs and DLCs made available to their researchers.

Some DLCIs maintain their own set of resources. See [this page](https://orcd.mit.edu/resources/dlci-shared-hardware) for a list.

### What is the timeline?

- Through April 30: All SuperCloud users can run jobs
- Starting May 1: Running jobs limited to Lincoln Collaborators
- Through May 31: Non-collaborators may continue to access SuperCloud for data migration
- June 1: SuperCloud access limited to Lincoln Collaborators

### How do I migrate to another system?

There are three main steps or milestones for moving to a new system. These will be similar to the steps you take when getting a new account on any system.

- Transfer data: Identify what data you need to keep and transfer it to the new system. We will provide documentation on this page in the near future for recommended ways to transfer large amounts of data.
- Build any missing software: Check the software stack of the new system and see what you may need to rebuild or request. Engaging maintains a software stack through modules that includes many of the software packages provided on SuperCloud. Names may be different, so run `module avail` to check for differences.
- Run jobs: Run small tests before running larger production jobs. Both SuperCloud and Engaging use Slurm, but Engaging does not have the `LL` commands such as `LLsub`, `LLfree`, and `LLstat`. Some `sbatch` flags may differ between the two systems as well. We will provide documentation on this page in the near future for the Engaging equivalent for common SuperCloud job workflows. You can also consult the section on Running Jobs in this documentation.

### Where can I get help?

The ORCD team can help with migrating data and workloads to Engaging. ORCD has regular office hours (see the [Office Hours Schedule](https://orcd.mit.edu/news-and-events/office-hours)). You can also request help through <orcd-help@mit.edu>.


## Migrating Data from SuperCloud

This section describes some recipes for migrating data from SuperCloud to Engaging, but some advice will apply to other systems.

### Step 1: What to Transfer

First, this is a good opportunity to decide what you need and what you don't need. Take a look at your home and group directories and decide what you need to keep. Transferring a lot of data (more than a few TB) or files (order of 1 million files) can take a long time. 

!!! warning "Remove files carefully"
    Remove files you no longer need very carefully. Remember, `rm` on Linux is permanent and the SuperCloud storage is not backed up!

### Step 2: Where to Transfer

Next figure out where you are going to transfer the data. ORCD has some base storage [described here](filesystems-file-transfer/filesystems.md), with additional [storage available for purchase](filesystems-file-transfer/project-filesystems.md).

Check your SuperCloud storage utilization to see how much space you use. You can see both your home directory and your group storage on your [User Profile Page](https://txe1-portal.mit.edu/profile/user_profile.php). If this is more than what the Engaging quotas can support you may want to check what you can clean up. Your group may also want to purchase additional storage.

For long-term archival storage of data that you need to keep, but will never or rarely need to access, consider purchasing archival storage such as [AWS Glacier](https://aws.amazon.com/s3/storage-classes/glacier/). For storage that you may need to access, but don't need to compute, [MIT IS&T provides some storage options](https://kb.mit.edu/confluence/display/istcontrib/Data+Storage+and+Collaboration+Options) for MIT students, staff, and faculty.

### Step 3: Transfer Your Data

If you don't have a lot of data to transfer you can use `scp` or `rsync` to transfer files at the command line. Log into either system and run your `scp` or `rsync` command from there. The best option is to do this on the download partition on SuperCloud as a batch job. You would use a batch script that looks something like this:

```bash title="transfer.sh"
#!/bin/bash

#SBATCH --partition=download

rsync -ruP path/to/source USERNAME@orcd-login001.mit.edu:/path/to/destination/supercloud-files/
```

!!! warning "Do not directly copy SuperCloud home into Engaging home"
    Be careful not to copy your SuperCloud home directory directly into your Engaging home directory. Doing so may overwrite files in your Engaging home directory, including files such as `.bashrc` which can cause issues. Instead create a subdirectory and transfer your files there.

If you have a lot of data and are having trouble with `rsync` or `scp` failing before the transfer is complete, Engaging has Globus collections that can make transfer easier. Globus will manage the file transfer for you to make sure everything transfers properly.

#### Using Globus to Transfer Data

The first step is to install Globus Connect Personal on SuperCloud. Log into SuperCloud and run the following in your home directory:

```bash
wget https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz
$ tar xzf globusconnectpersonal-latest.tgz
cd globusconnectpersonal-x.y.z #replace x.y.z with version
./globusconnectpersonal
```

Follow the instructions to set it up, it will direct you to a link where you will be prompted to log in. Use your MIT credentials to log in. There will be a code for you to copy and enter at the command line where you ran "./globusconnectpersonal". This will connect this installation to your account. It will also ask you for a name for your Collection, this will be a private one only you can see. 

Run Globus Connect personal with "./globusconnectpersonal --start". It can be done in a job on a data transfer node with the following script:
#!/bin/bash

#SBATCH -p download

~/software/globusconnectpersonal-3.2.6/globusconnectpersonal -start

This assumes version 3.2.5 installed in a directory called "software"
Go to https://www.globus.org/ and log in. Click "File Manager" and search for your SuperCloud Personal collection in the left pane. Search for the collection where you want to transfer the data ("MIT ORCD Engaging Home Collection") and navigate to the directory where you want to transfer your data. Create a directory called "SuperCloud" and select it. For PI shared pool storage use the "MIT ORCD Engaging Complete Collection".
Select the items you want to transfer from SuperCloud, or "Select all" to transfer your entire home directory. Symlinks (to group directories) and their contents are not transferred.
Click "Show Hidden Items" if you want to deselect . files (recommended). Your .bashrc and any conda environments will not work on another system and could cause issues. (Not working?)
Under Transfer and Timer options select:
Skip files on source with errors
Fail on quota errors
Encrypt transfer
Apply filter rules to the transfer- May be best to exclude . files (see screenshot)
Consider: sync, if you have already transferred some files
To transfer files from group directories may need to start globuscconnectpersonal from that directory, or add it in some way

