---
tags:
 - CryoEM
 - Software installation
 - Engaging
---

<!-- TODO:
- Add notes on how to see what resource limits you have
- Test out the workflow when maintenance is done
- Test if you can use an environment variable in cluster_info.json
- Create one cluster for each GPU type
- Create a cluster for mit_preemptable
- Add images
- Make sure slurm job ID gets printed correctly from batch script
-->

# Installing CryoSPARC on Engaging

CryoSPARC is a software platform for rapid, automated processing and analysis of
cryo-electron microscopy (cryo-EM) data to determine high-resolution 3D
structures of biological macromolecules.

This guide has been adapted from [these instructions](https://guide.cryosparc.com/setup-configuration-and-management/how-to-download-install-and-configure/downloading-and-installing-cryosparc).

## Getting Started

First, connect to the Engaging cluster:

```bash
ssh $USER@orcd-login001.mit.edu
```

You will need to obtain a CryoSPARC license ID. Licenses are free for
academic use. You can request a license ID [here](https://guide.cryosparc.com/setup-configuration-and-management/how-to-download-install-and-configure/obtaining-a-license-id). Once you have
received your license ID, save it as an environment variable for future uses:

```bash
echo 'export CRYOSPARC_LICENSE_ID="<your_license_id>"' >> ~/.bash_profile
source ~/.bash_profile
```

Next, choose a working directory to use for your installation:

```bash
echo 'export CRYOSPARC_WORKDIR="/path/to/workdir"' >> ~/.bash_profile
source ~/.bash_profile
```

Download and extract the master and worker software:

```bash
cd $CRYOSPARC_WORKDIR
curl -L https://get.cryosparc.com/download/master-latest/$CRYOSPARC_LICENSE_ID -o cryosparc_master.tar.gz
curl -L https://get.cryosparc.com/download/worker-latest/$CRYOSPARC_LICENSE_ID -o cryosparc_worker.tar.gz
tar -xf cryosparc_master.tar.gz cryosparc_master
tar -xf cryosparc_worker.tar.gz cryosparc_worker
```

## Installation

The CryoSPARC software setup requires two different installations:
`cryosparc_master` and `cryosparc_worker`. The "master" software is used for
running the user interface and scheduling jobs on the worker nodes, while the
"worker" software is used for performing calculations.

You will need to run the installation on a compute node. To do this, request
an interactive session:

```bash
salloc -N 1 -n 8 --mem-per-cpu=4G -p mit_normal
```

### Master Node Setup

Run this script to install the master node software:

```bash title="install_master.sh"
--8<-- "docs/recipes/scripts/cryosparc/install_master.sh"
``` 

Once this installation is complete, you can start running CryoSPARC.

```bash
# Add cryosparc_master to your path:
export PATH=$CRYOSPARC_WORKDIR/cryosparc_master/bin:$PATH
# Ensure that CryoSPARC recognizes the master node you are using:
echo 'export CRYOSPARC_FORCE_HOSTNAME=true' >> "$CRYOSPARC_WORKDIR/cryosparc_master/config.sh"
# Start cryosparc:
cryosparcm start
```

To log in to the user interface, you need to register yourself as a user:

```bash
cryosparcm createuser --email "${USER}@mit.edu" \
                      --password <your_password> \
                      --username $USER \
                      --firstname <your_first_name> \
                      --lastname <your_last_name>
```

#### Connect the Master Node to the Cluster

The master node can be set up to submit jobs to the cluster using the Slurm
scheduler. This is the preferred setup for Engaging so that GPU resources are
not allocated to your job when they are not in use.

Create the following two files within the `$CRYOSPARC_WORKDIR/cryosparc_master`
directory:

```bash title="cluster_info.json"
--8<-- "docs/recipes/scripts/cryosparc/cluster_info.json"
```

```bash title="cluster_script.sh"
--8<-- "docs/recipes/scripts/cryosparc/cluster_script.sh"
```

Now, from the same directory where you created these two files, run:

```bash
cryosparcm cluster connect
```

### Worker Node Setup

Before you can start running jobs, however, you will need to install
`cryosparc_worker`. This can be done in the same compute node session that we
used to install `cryosparc_master`.

Run the following script to install the worker node software:

```bash title="install_worker.sh"
--8<-- "docs/recipes/scripts/cryosparc/install_worker.sh"
```

All setup is now complete. You can run `cryosparcm stop` and exit your compute
node session.

## Running CryoSPARC

To run CryoSPARC, we recommend starting up the master node in a
[batch session](../running-jobs/overview.md#batch-jobs). Our friends at the
[Yale Center for Research Computing](https://research.computing.yale.edu/) have
developed a [script](https://docs.ycrc.yale.edu/clusters-at-yale/guides/cryosparc/#1-submit-a-batch-script)
for running the software on a shared cluster similar to Engaging, which we have
adapted here:

```bash title="run_cryosparc.sbatch"
--8<-- "docs/recipes/scripts/cryosparc/run_cryosparc.sbatch"
```

You can run this script with the command `sbatch run_cryosparc.sbatch`.

This will create an output file (within an `output` directory) that will have
printed instructions for accessing the user interface. This involves SSH
tunneling, which will make the compute node visible to your local computer. The
output file will contain a line that looks something like this:

```bash
ssh -L 61000:<node>:61000 <username>@orcd-login001.mit.edu
```

Here we have specified port 61000 for both the local and remote sides of
the tunnel. The remote port (to the right of the node name) must be the same as
what we specified in the master node installation script. The local port (to the
left of the node name) can be any number greater than 1024 that is not already
in use on your machine. For simplicity, we have kept the port numbers the same.

Now, using your web browser, navigate to
[http://localhost:61000](http://localhost:61000). At the login prompt, enter
the username and password you specified when you added yourself as a user:

<!-- Insert image of login here -->

Then, you should see the following user interface:

<!-- Insert image of UI here -->

When you're finished using CryoSPARC, run `scancel <job id>` to terminate your
master session. The Job ID was printed when you submitted your job and you can
also find it in your output file.

## FAQs

**What are my resource limits for submitting jobs?**

On Engaging, you are limited to using a certain number of CPU cores, RAM, and
GPUs at a time. Unfortunately, this information is not visible from the
CryoSPARC user interface. If you hit your resource limit, any new job submitted
will simply pend until the other jobs have finished.

To see what your resource limits are for a given partition on Engaging
(`mit_normal_gpu` in this case), you can use this command:

```bash
sacctmgr show qos mit_normal_gpu format=Name%30,MaxTRESPU%60
```
