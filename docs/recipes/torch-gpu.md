---
tags:
 - Engaging
 - Pytorch
 - GPU
 - Howto Recipes
---

# Deep Learning with Pytorch on GPUs

 Deep leaning is the fundation of artificial intelligence nowadays. Deep leaning programs can be accelerated substantially on GPUs. 
 
PyTorch is a popular Python package for working on deep learning projects.

This page shows recipes to run Pytorch programs on GPUs. 


## Installing PyTorch

=== "Engaging"

     First, load a Miniforge module to provide python platform, 
     ```
     module load miniforge/24.3.0-0
     ```
     Create a new environment and install PyToch with CUDA support,
     ```
     conda create -n torch
     source activate torch
     pip install torch
     ```

## PyTorch on CPU and a single GPU

We use an example code training a convolutional neural network (CNN) with the CIFAR10 data set. Refer to [description of this example](https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html). Download the [codes for CPU](./scripts/torch-gpu/cnn_cifar10_cpu.py) and [for GPU](./scripts/torch-gpu/cnn_cifar10_gpu.py). 

=== "Engaging"  

     Prepare a job script named `job.sh` like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu   
     #SBATCH --gres=gpu:1 
     #SBATCH -t 30
     #SBATCH -N 1
     #SBATCH -n 2
     #SBATCH --mem=10GB
     
     module load miniforge/24.3.0-0
     source activate pytorch
     
     echo "~~~~~~~~ Run the pytorch code on CPU ~~~~~~~~~"
     time python cnn_cifar10_cpu.py
     echo "~~~~~~~~ Run the pytorch code on GPU ~~~~~~~~~"
     time python cnn_cifar10_gpu.py
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

The `mit_normal_gpu` partition is for all MIT users. If your lab has a parititon with GPUs, you can use it too.  

The `-N 1 -n 2` requets two CPU cores on one node and the `--mem=10GB` means 10 GB of memory per node (not per core).

The programs `cnn_cifar10_cpu.py` and `cnn_cifar10_gpu.py` will run on CPUs and a GPU respectively. 

While the job is running, check the hostname that it runs on,
```
squeue -u $USER
```
and then log in the node,
```
ssh <nodeXXX>
```
and check if the program runs on a GPU with the `nvtop` command.


## PyTorch on multiple GPUs

There are various parallelisms to implement distributed deep leaning on mulitple GPUs, including data parallel, tensor parallel, pipeline parallel, and expert parallel. Here are recipes to run programs on multiple GPUs based on the frist two parallelisms. 

### Data parallel

Data parallel allows traning a model with multiple batches of data simultaneously. The model has to fit into the GPU memory. 

We use an exmaple code that trains a linear network with a random data set, based on the [Distributed Data Parallel](https://PyTorch.org/docs/stable/notes/ddp.html) package in PyTorch. Refer to the description of [this example for multiple GPUs within one node](https://pytorch.org/tutorials/beginner/ddp_series_multigpu.html) and [for multiple GPUs across multiple nodes](https://pytorch.org/tutorials/intermediate/ddp_series_multinode.html). 

Download the codes [datautils.py](./scripts/torch-gpu/datautils.py), [multigpu.py](./scripts/torch-gpu/multigpu.py), and [multinode.py](./scripts/torch-gpu/multinode.py).

#### Single-node multi-GPU data parallel

=== "Engaging"

    To run the program on multiple GPUs within one node, prepare a job script named `job.sh` like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu
     #SBATCH --job-name=ddp
     #SBATCH -N 1
     #SBATCH -n 4
     #SBATCH --mem=20GB
     #SBATCH --gres=gpu:4   
     #SBATCH -o %x-%N-%J.out

     module load miniforge/23.11.0-0
     source activate pytorch

     echo "======== Run on multiple GPUs ======"
     # Set 100 epochs and save checkpoints every 20 epochs
     python multigpu.py --batch_size=1024 100 20
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

The `-N 1 -n 4 --gres=gpu:4` flags requet 4 GPU cores and 4 GPUs on one node. For most GPU programs, it is recommended to set the number of CPU cores no less than the number of GPUs. 

The PyTorch program will run on 4 GPUs on a single node. The training prcesses happens on 4 batches of data simultaneously. 

Check if the program runs on multiple GPUs using the `nvtop` command as described in the above section.  

> The NVIDIA Collective Communications Library (NCCL) is set as backend in the PyTorch program `multigpu.py`, so the data communication bewteen GPUs within one node benifits from the high bandwidth of NVLinks. 

#### Multi-node multi-GPU data parallel

=== "Engaging"

    To run on multiple GPUs across two nodes, prepare a job script like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu
     #SBATCH --job-name=ddp-2nodes
     #SBATCH -N 2
     #SBATCH --ntasks-per-node=1
     #SBATCH --cpus-per-task=4
     #SBATCH --gpus-per-node=4 
     #SBATCH --mem=20GB
     #SBATCH -o %x-%N-%J.out

     module load miniforge/23.11.0-0
     source activate pytorch

     # Get IP address of the master node
     nodes=( $( scontrol show hostnames $SLURM_JOB_NODELIST ) )
     nodes_array=($nodes)
     master_node=${nodes_array[0]}
     master_node_ip=$(srun --nodes=1 --ntasks=1 -w "$master_node" hostname --ip-address)

     echo "======== Run on multi-node multi-GPU ======"     
     srun torchrun --nnodes=$SLURM_NNODES \
          --nproc-per-node=$SLURM_CPUS_PER_TASK \
          --rdzv-id=$SLURM_JOB_ID   \
          --rdzv-backend=c10d \
          --rdzv-endpoint=$master_node_ip:1234 \
          multinode.py --batch_size=1024 100 20
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

As the flags `-N 2` and `--ntasks-per-node=1` request for tow nodes with one task per node, the `srun` command lanches one `torchrun` process on each of the two nodes. 

The flags `--cpus-per-task=4` and `--gpus-per-node=4` request 4 GPU cores and 4 GPUs on each node. 
Therefore, with the flags `--nnodes=$SLURM_NNODES --nproc-per-node=$SLURM_CPUS_PER_TASK`, the two `torchrun` processes on both nodes run the PyTorch program on 2 nodes with 4 CPU cores and 4 GPUs on each node. That says the training prcesses happens on 8 GPUs dealing with 8 batches of data simultaneously. 

The flags with `rdzv` (meaning Rendezvous) are required by `torchrun` processes to coordinate across nodes. The ID in `--rdzv-id=$SLURM_JOB_ID` is set to be the job ID, but it can be any random number. The `--rdzv-backend=c10d` is to use a C10d store (by default TCPStore) as the rendezvous backend, the  advantage of which is that it requires no 3rd-party dependency. The `--rdzv-endpoint=$master_node_ip:1234 ` is to set up the IP address and port of the the master node. The IP address is obtained previously and the port can be any 4-digit number lager than 1024.   

Refer to details of torchrun on [this page](https://pytorch.org/docs/stable/elastic/run.html).

> The NCCL is set as backend in the PyTorch program `multinode.py`, so the data communication bewteen GPUs within one node benifits from the high bandwidth of NVLinks, and the data communication bewteen GPUs acress nodes benifits from the bandwidth of Infiniband network. 


### Tensor parallel

Data


