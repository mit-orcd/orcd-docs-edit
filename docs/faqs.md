# Frequently Asked Questions

## Getting Started

### How do I get an account?

If you have an MIT Kerberos account, then you can get an account on Engaging. To register, navigate to the [ORCD OnDemand Portal](https://orcd-ood.mit.edu/) and log in. Your account will automatically be created. Please wait a few minutes before trying to start any jobs or interactive sessions.

### How do I get GPU access?

We have L40S and H200 GPUs available on Engaging through the `mit_normal_gpu` partition. There are also a variety of GPU types available through the [`mit_preemptable`](running-jobs/overview.md#preemptable-jobs) partition. Take a look at out page on [requesting resources](running-jobs/requesting-resources.md#gpus) to see how to request them for your job.

If your lab would like to purchase GPUs to be hosted on Engaging, please contact
<orcd-help-engaging@mit.edu>.

### I just created an account on Engaging, but I can't run any jobs. What's the problem?

Some users get the following error message when trying to submit a job right after creating their account:

```
sbatch: error: Batch job submission failed: Invalid account or account/partition combination specified
```

It sometimes takes an extra bit of time for your account to be set up properly so that you can submit jobs. Wait about 15 minutes and try again.

## Access & Login

### I have set up an SSH key but I am still being prompted to enter my password when I try to log in. Why?

To log in with an SSH key first log into [ORCD OnDemand](https://orcd-ood.mit.edu) before logging in with SSH. This allows you to log with with your SSH key only, without requiring a password or Duo authentication. The Duo requirement is satisfied if you log into [ORCD OnDemand](https://orcd-ood.mit.edu) about once per day.

### I got locked out of my Engaging account. How do I restore my access?

People sometimes get locked out of their accounts due to repeated failed authentication attempts, specifically from Duo two-factor authentication. When this happens, they get the following message:

```
Your account is disabled and cannot access this application. Please contact your administrator.
```

This is usually caused by third-party software that connects to Engaging over SSH, such as [VS Code](recipes/vscode.md#other-vscode-best-practices-tips-and-tricks). Your account will be automatically reactivated after a bit of time.

There are two things that can help:

1. Log into [ORCD OnDemand](https://orcd-ood.mit.edu) before logging in with SSH. This allows you to log with with your SSH key only, without requiring a password or Duo authentication. The Duo requirement is satisfied if you log into [ORCD OnDemand](https://orcd-ood.mit.edu) about once per day.
2. If you use VSCode, adjust the [VSCode Remote SSH settings](https://orcd-docs.mit.edu/recipes/vscode/#adjust-the-remotessh-extension-settings), which will allow for more time to connect and reduce the number of auto-reconnect attempts.

### I cannot connect to a compute node using VS Code remote SSH.

Sometimes, when following [our instructions for running VS Code on the cluster](recipes/vscode.md), users are prompted to enter their password when they connect to the compute node and they get "permission denied." This is most often because they do not have an SSH key set up on Engaging. You can do so following [these instructions](accessing-orcd/ssh-setup.md).

### How do I get or give access to my group's resources?

Some PI groups, labs, or departments on Engaging have purchased rental storage or hardware. We manage access to storage and compute resources through MIT Moira groups. Group admins, often the group PI or a senior researcher in the group, have the ability to add new members to the group. Admins will see a group that starts with "orcd_ug" under the "Lists I can Administer" column in [WebMoira](https://groups.mit.edu/webmoira/), which gives access to all the group's resources. See [Accessing Group Resources](services/accessing-group-resources.md) for details on using WebMoira.

To get or give access ask your group admin to grant access in Moira. If you are not sure who the group admin is, or they aren't sure how to give access, send an email to <orcd-help@mit.edu>. We will let you know who the group admin is and a direct link to the page where they can add you or the new group member.

## Running Jobs

### How do I check the status of my job?

Instructions for checking job status can be found
[here](running-jobs/overview.md#checking-job-status).

### How do I increase the time limit for my job?

Use the `-t` flag in your job script. If you do not specify, Slurm will give
you the maximum time limit for that partition. You can check the maximum time
limit by running `sinfo -p <partition name>`.

For public partitions on Engaging, such as `mit_normal`, we cannot increase the
maximum job time limit, as these resources are shared. For jobs that
need to run longer than the time limit, we encourage
checkpointing, which is a way of periodically saving progress so that subsequent
jobs can pick up where previous jobs left off. The implementation of checkpointing
is domain-specific and can vary greatly. You can find more information on
checkpointing [here](https://rc-docs.northeastern.edu/en/latest/best-practices/checkpointing.html).

For increasing the maximum time limit on partitions owned by other groups,
please email <orcd-help-engaging@mit.edu>.

### What is the `mit_preemptable` partition? What is preemption?

The `mit_preemptable` partition allows you to run programs on lab-owned nodes while they're not being used. While this partition has higher resource limits and longer runtimes than other public partitions like `mit_normal` and `mit_normal_gpu`, jobs submitted to `mit_preemptable` are **low priority** and **preemptable**. See [Preemptable Jobs](running-jobs/overview.md#preemptable-jobs) for more information.

### Why won't my application run on a different partition?

On Engaging, the older nodes (such as the `sched_mit_hill` and `newnodes`
partitions) run on CentOS 7 while the newer nodes (such as `mit_normal` and
`mit_preemptable`) run on the Rocky 8 operating system (OS). Each set of nodes
has a different set of modules, so if you have set up software to run on one OS,
it will probably not work on the other OS.

### I submitted a job to `mit_normal_gpu` and it's still pending in the queue. Why is it taking so long?

This is most likely because there aren't enough resources available or other jobs are ahead of yours in the queue (see [Checking Job Status](running-jobs/overview.md/#checking-job-status)). To check what resources are available, use the `sinfo` command. This variation will show what GPU resources exist and are in use on each node in mit_normal_gpu:

```
sinfo -O "Partition,Nodes:10,CPUsState,Gres:30,GresUsed:30,StateCompact" -e -p mit_normal_gpu
```

The H200s on Engaging are in high demand. Jobs that request an H200 can sometimes wait a few hours until it's their turn to run. During high-demand times, such as leading up to conference deadlines, it can take even longer. Here are some steps you can take to minimize wait time:

1. **Consider using an L40S instead.** L40S GPUs are less powerful than H200s yet much more readily available on Engaging. If your application requires less VRAM than what is available on one or two L40Ss (44GB each), then this is probably a good approach for you. Though H200s are faster, the increased wait time may outweigh the benefits in speedup.
2. **Request fewer resources (cpus, memory, or GPUs) or a shorter time limit.** Slurm takes resource requests and time limits into account when scheduling jobs. Jobs that ask for less tend to start sooner. Use the [`jobstats`](running-jobs/application-analysis.md#jobstats) command to see what resources you used in your recent jobs.
3. **Subscribe to a Standard or Advanced Account Level.** Users with a valid cost object can pay a monthly fee to run higher-priority jobs and request more resources than the free tier. This doesn't guarantee that your jobs will run immediately, but they should have a shorter wait time overall. More information can be found on our [Compute Services](services/compute-services.md) page.

## Software & Environment

### How do I install a Python package?

See our documentation on [Python](software/python.md).

### I am unable to install a package in R. How can I debug the issue?

Our latest versions (R/4.4.3 and R/4.5.2) are containerized and contain the system libraries needed to install most additional packages. These R environments use the same containers as RStudio on the OnDemand web portal, so you can be sure that the packages you install in your R environment will also be available in RStudio, and vice versa.

If you run into a missing dependency you can try creating a conda environment for your R project. Conda has the ability to install some dependency libraries in th environment. One downside of a R conda environment is it cannot be used in RStudio.

Please refer to the [R user guide](software/R.md) for more information on install R packages.

### How can I submit a module request?

We are open to creating new modules for the Engaging cluster. You can submit
module requests to <orcd-help-engaging@mit.edu>.

### Can I use export-controlled software on the cluster?

Export-controlled software has specific requirements around who is allowed to
access the software. Often, Engaging does not meet these requirements, so
we generally do not allow such software to be used on our system. Please refer
to the terms of use of the software and direct any questions to
<orcd-help@mit.edu>.

### How do I run Jupyter notebooks?

You can run Jupyter in a few different ways:

1. Jupyter Notebook Interactive App on the [ORCD OnDemand](https://orcd-ood.mit.edu) site (preferred)
2. [VS Code](recipes/vscode.md)
3. Port forwarding

See our [Jupyter documentation](recipes/jupyter.md).

### How do I use Git on the cluster?

Git is highly encouraged for use on the cluster. It is useful for backing up
code and version control, especially when collaborating with others.

We recommend setting up an SSH key with GitHub for security and convenience.
This allows you to use the "SSH" link rather than the "HTTPS" link when cloning
repositories. To set up an SSH key, follow these steps:

1. [SSH](accessing-orcd/ssh-login.md) to the cluster you're using

2. Enter the following from the command line:

    ```bash
    ssh-keygen -t ed25519 -C "$USER@mit.edu"
    ```

3. Press "enter" to save your private and public keys to the default `~/.ssh`
location. When prompted, optionally enter a passphrase for higher security. You
will now have two new files in your `~/.ssh` directory: `id_ed25519` and
`id_ed25519.pub`.

4. Print the contents of your **public key** (using `cat id_ed25519.pub`) and
copy the output

5. Navigate to [GitHub.com](https://github.com) > click your profile in the top right
corner > select "Settings" > "SSH and GPG keys" > "New SSH key"

6. Add a title (e.g., "engaging"), paste your **public key**, and click "Add
SSH key"

See [GitHub's documentation on SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux) for more information.

### Xfce desktop has failed to start. How can I fix this?

This issue is often caused by Conda setup commands existing in your `~/.bashrc`
file. This happens when you run `conda init` when using Miniforge or another
Anaconda install. We recommend **not** running `conda init` as it can lead to
errors such as this one.

To fix this, remove or comment out all conda setup commands from your
`~/.bashrc` file.

### Why doesn't my password work when I try to run the sudo command?

Regular users are not allowed to use sudo on Engaging. Engaging is a shared environment. Sudo enables root-level access, which allows our system administrators to modify system files, install software, and change permissions. If misused unintentionally or accidentally, it could compromise the entire cluster. Therefore, use of sudo is reserved for engaging system administrators who work to secure, maintain, and tune the cluster. If you need specific software and you are having difficulty installing it, contact orcd-help@mit.edu and someone on the staff can assist you. Please see `https://orcd-docs.mit.edu/software/overview/` for more information. 
