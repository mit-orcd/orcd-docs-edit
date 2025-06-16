---
tags:
 - CryoEM
 - Software installation
 - Engaging
---

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

Now, you can 
