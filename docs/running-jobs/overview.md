# Job Scheduler Overview

To run something on an HPC cluster, like Engaging, you will request resources for your application using a piece of software called the *scheduler*. The scheduler that Engaging uses is Slurm (you'll see and hear "scheduler" and "Slurm" used interchangeably). It is the scheduler's responsibility to allocate the resources that satisfy your request and those of everyone else using the system. This temporary allocation of resources is called a *job*. As with all software, the scheduler uses a specific syntax for requesting resources. This section describes how to work with the scheduler and how to run jobs efficiently.

## Partitions

Engaging is a large heterogenous cluster, meaning there are many different types of nodes with different configurations. Some nodes are freely available for anyone at MIT to use, and some have been purchased by labs or departments for priority use by their group. Some nodes are meant for specific types of workloads. Nodes are grouped together in *partitions*, which designate who can access them and what they should be used for. Different partitions may have different sets of rules about how many resources you can use and how long your jobs can run on them.

To see which partitions you have access to, run the `sinfo` command: 

```
sinfo
PARTITION    AVAIL  TIMELIMIT  NODES  STATE NODELIST
mit_normal      up 1-00:00:00      2   resv node[2704-2705]
mit_normal      up 1-00:00:00     30   idle node[1600-1625,1706-1707,1806-1807]
mit_normal_gpu  up 1-00:00:00      1    mix node2906
mit_normal_gpu  up 1-00:00:00      5   idle node[1706-1707,1806-1807,2804]
mit_quicktest   up      15:00     26   idle node[1600-1625]
mit_preemptable up 7-00:00:00      1    mix node2906
mit_preemptable up 7-00:00:00     27   idle node[1600-1625,2804]
```

The `sinfo` command will tell you the names of the partitions you have access, what their time limits are, how many nodes are in each state (see [Checking Available Resources](#checking-available-resources) below), and the names of the nodes in the partitions.

The standard partitions that the full MIT community has access to are:

| Partition Name | Purpose | Hardware Type(s) | Time Limit | Resource Limit |
| ----------- | ----------- |----------- |----------- |----------- |
| `mit_normal` | Longer running batch and interactive jobs that do not need a GPU | CPU only | 12 hours | ??? |
| `mit_normal_gpu` | Batch and interactive jobs that need a GPU | GPUs (L4, L40S, H100) | 12 hours | ??? |
| `mit_quicktest` | Short batch and interactive jobs, meant for testing | CPU only | 15 minutes | ??? |
| `mit_preemptable` | Low-priority preemtable jobs- jobs that may be stopped by another job with higher priority | Mixed | ??? | ??? |

!!! note "Older Partitions"
    There are a few additional partitions that contain older nodes. These nodes run on a different operating system (Centos 7) than the ones above and therefore have a different software stack. Software built or installed on Rocky 8 or newer nodes will most likely not work on these older nodes. These partitions include `sched_mit_hill`, `newnodes`, `sched_any`, `sched_engaging_default`, and `sched_quicktest`.

If you are part of a group that has purchased nodes you may see additional partitions. They will be named based on your PI's Kerberos or your group's name, depending on who purchased the nodes.

### Preemptable Jobs

We provide the `mit_preemptable` partition so that nodes owned by a group or PI can be used by researchers outside that group when those nodes are idle. When someone from the group that owns the node runs a job on their partition, the scheduler will stop, or preempt, any job that is running on the lower-priority `mit_preemptable` partition. Jobs running on `mit_preemptable` should be checkpointed so that they don't lose their progress when the job is stopped.

<!-- section on seeing  node stats in partition, partition rules -->

## Checking Available Resources

To see what resources are available run `sinfo`. The `sinfo` command will show how many nodes are in each state. Nodes in "idle" state have all cores available, nodes in "mix" state have some cores available, and nodes in "alloc" state have no cores or other resources available.

```
sinfo -p mit_normal
PARTITION  AVAIL  TIMELIMIT  NODES  STATE  NODELIST
mit_normal    up 1-00:00:00      2   resv  node[2704-2705]
mit_normal    up 1-00:00:00      1   mix   node1707
mit_normal    up 1-00:00:00      1   alloc node1708
mit_normal    up 1-00:00:00     29   idle  node[1600-1625,1706,1806-1807]
```

Common node states are:

- idle: nodes that are fully available
- mix: nodes that have some, but not all, resources allocated
- alloc: nodes that are fully allocated
- resv: nodes that are reserved and only available to people in their reservation
- down: nodes that are not currently in service
- drain: nodes that will be put in a `down` state once all jobs running on them are completed

## Running Jobs

How you run your job depends on the type of job you would like to run. There are two "modes" for running jobs: interactive and batch jobs. Interactive jobs allow you to run interactively on a compute node in a shell. Batch jobs, on the other hand, are for running a pre-written script or executable. Interactive jobs are mainly used for testing, debugging, and interactive data analysis. Batch jobs are the traditional jobs you see on an HPC system and should be used when you want to run a script that doesn't require that you interact with it.

### Job Flags

When you start any type of job you specify what resources you need for your job, including cores, memory, GPUs, and other features. You also specify which [partition](#partitions) you would like your job to run on. If you don't specify any of these you will get the default resources: 1 core, a small amount of memory, no GPUs, and it will run on the current default partition. See the page on [Requesting Resources](running-jobs/requesting-resources.md) for the flags to use to request different types of resources.

### Interactive Jobs

The basic command for requesting an interactive job on the `mit_normal` partition is:

```batch
salloc -p mit_normal
```

The `-p mit_normal` is a flag that is passed to the scheduler, `-p` specifies the partition. This command will allocate 1 core on a node in the `mit_normal` partition. For example:

```bash
[user01@orcd-login001 ~]$ salloc -p mit_normal
salloc: Pending job allocation 60159437
salloc: job 60159437 queued and waiting for resources
salloc: job 60159437 has been allocated resources
salloc: Granted job allocation 60159437
salloc: Waiting for resource configuration
salloc: Nodes node1806 are ready for job
[user01@node1806 ~]$ 
```

Notice how the command prompt changes from `[user01@orcd-login001 ~]$` to `[user01@node1806 ~]$`. This indicates that `user01` has started an interactive job on `node1806` and any commands issued will run on this node.

### Batch Jobs

Batch jobs are used to run pre-written scripts or run commands that do not need input from you throughout the run. The first step to running a batch job is to write a job script. Job scripts can be "launched" with the `sbatch` command:

```bash
sbatch myscript.sh
```

When you run this command the scheduler will look for the resources requested in the script, allocate those resources to your job, run your script on those resources, and then release those resources once your script completes or the time limit is reached.

Here is an example job script:

```bash
#!/bin/bash

# Job Flags
#SBATCH -p mit_normal

# Set up environment
module load miniforge

# Run your application
python myscript.py
```

This script requests the same resources as the [interactive job above](#interactive-jobs): 1 cpu core on the `mit_normal` partition. The `#SBATCH -p mit_normal` may look like a comment but it is not, it is a directive to the scheduler to run with the specified flags. Note that this is the same flag used in the [interactive job example above](#interactive-jobs). It then sets up the job environment to use python with the `miniforge` module, and then runs a python script. In general, the same steps and commands you would use to run your job in an interactive job you can put in your job script.

You can think of job scripts as having three sections:

1. Scheduler/Job flags: This is where you request your resources using Slurm flags.
2. Set up your environment: Load any modules you need, set environment variables, etc. It is better to set this in your job scripts to ensure consistent environments across jobs. We don't recommend putting these commands in your `.bashrc` or running them at the command line before you launch your job.
3. Run your code or application as you would from the command line.

## Checking Job Status

To see all your currently running and pending jobs run the `squeue --me` command:



## Stopping Jobs

## Retrieving Job Stats

