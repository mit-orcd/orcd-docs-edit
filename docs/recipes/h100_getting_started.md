---
tags:
 - Satori
 - Howto Recipes
 - H100
---
# Getting started on 8-way H100 nodes on Satori

A first set of H100 GPU systems has been added to Satori.
These are for priority use by IBM Watson AI Lab research collaborators.
They are also available for general opportunistic use when they are idle.


Currently ( 2023-06-19 ) there are 4 H100 systems installed. 
Each system has 8 H100 GPU cards, two Intel 8468 CPUs each with
48 physical cores and 1TiB of main memory.

Below are some instructions for getting started with these systems. 


## Access to the nodes

To access the nodes in the priority group you need your satori login id to be listed in the Webmoira 
group [https://groups.mit.edu/webmoira/list/sched_oliva](https://groups.mit.edu/webmoira/list/sched_oliva). 
Either Alex Andonian and Vincent Sitzmann are able to add accounts to the `sched_oliva` moira list.

## Interactive access through Slurm

To access an entire node through Slurm, the command below can be used from the satori login node

```bash
srun -p sched_oliva --gres=gpu:8 -N 1 --mem=0 -c 192 --time 1:00:00 --pty /bin/bash
```

this command will launch an interactive shell on one of the nodes (when a full node becomes available). 
From this shell the NVidia status command 
```bash
nvidia-smi
```
should list 8 H100 GPUs as available. 

Single node, multi-gpu training examples (for example
[https://github.com/artidoro/qlora](https://github.com/artidoro/qlora) ) should run 
on all 8 GPUs. 

To use a single GPU interactively the following command can be used
```bash
srun -p sched_oliva --gres=gpu:1 --mem=128 -c 24 --time 1:00:00 --pty /bin/bash
```

this will request a single GPU. This request will allow other Slurm sessions to run on other GPUs 
simultaneously with this session.

## Running a nightly build pytorch example with a freash miniconda and pytorch

A miniconda environment can be used to run the latest nightly build pytorch code on these 
systems. To do this, first create a software install directory and install the needed pytorch software

```bash
mkdir -p /nobackup/users/${USER}/pytorch_h100_testing/conda_setup
```

and then switch your shell to that directory.
```bash
cd /nobackup/users/${USER}/pytorch_h100_testing/conda_setup
```

now install miniconda and create an environment with the needed software
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p minic
. ./minic/bin/activate 
conda create -y -n pytorch_test python=3.10
conda activate pytorch_test                          
conda install -y -c conda-forge cupy
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu121
```

Once the software is installed, the following script can be used to test the installation.
```bash
cat > test.py <<'EOF'
import torch
device_id = torch.cuda.current_device()
gpu_properties = torch.cuda.get_device_properties(device_id)
print("Found %d GPUs available. Using GPU %d (%s) of compute capability %d.%d with "
          "%.1fGb total memory.\n" % 
          (torch.cuda.device_count(),
          device_id,
          gpu_properties.name,
          gpu_properties.major,
          gpu_properties.minor,
          gpu_properties.total_memory / 1e9))
EOF

python test.py
```

To exit the Slurm srun session enter the command
```bash
exit
```


### Running a simple batch script using an installed miniconda environment

To run a batch script on one of the H100 nodes in partition sched_oliva first type the following into
a slurm script file called, for example, `test_script.slurm`. Change the RUNDIR setting to assign the 
path to a directory where you have already installed a conda environment in a sub-directory called `minic`.

```
#!/bin/bash
#
#SBATCH --gres=gpu:8
#SBATCH --partition=sched_oliva
#SBATCH --time=1:00:00
#SBATCH --mem=0
#

nvidia-smi

RUNDIR=/nobackup/users/${USER}/h100-testing/minic
cd ${RUNDIR}

. ./minic/bin/activate

conda activate pytorch_test

cat > mytest.py <<'EOF'
import torch
device_id = torch.cuda.current_device()
gpu_properties = torch.cuda.get_device_properties(device_id)
print("Found %d GPUs available. Using GPU %d (%s) of compute capability %d.%d with "
          "%.1fGb total memory.\n" %
          (torch.cuda.device_count(),
          device_id,
          gpu_properties.name,
          gpu_properties.major,
          gpu_properties.minor,
          gpu_properties.total_memory / 1e9))
EOF

python mytest.py
```

This script can then be submitted to Slurm to run in a background batch node using the command.

```bash
sbatch < test_scirpt.slurm
```






