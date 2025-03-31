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

On this page, we inttoruce recipes to run deep-learning programs wtih Pytorch on GPUs. 


## Installing PyTorch

=== "Engaging"

     First, load a Miniforge module to provide python platform, 
     ```
     module load miniforge/24.3.0-0
     ```
     Create a new environment and install PyToch,
     ```
     conda create -n torch
     source activate torch
     pip install torch
     ```

     with CUDA support is by default. 
     Check if CUDA is installed. 
     Check NCCL. 

## PyTorch on CPU and a single GPU

We start with a recipe to run PyTorch on CPU and a single GPU.

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

The programs `cnn_cifar10_cpu.py` and `cnn_cifar10_gpu.py` will run on CPUs and a GPU respectively. When the problme size is large, the program will be accelerated on a GPU. 

While the job is running, you can check if the program runs on GPU. First, check the hostname that it runs on,
```
squeue -u $USER
```
and then log in the node,
```
ssh <nodeXXX>
```
and check if the the GPU usage with the `nvtop` command.


## PyTorch on multiple GPUs

Deep learning programs can be further accelerated on multiple GPUs. 

There are various parallelisms to enable distributed deep leaning on mulitple GPUs, including data parallel and model parallel. In the following two sections, we introduce recipes to run PyTorch programs on multiple GPUs based on these two parallelisms respectively. 

### Data parallel

Data parallel allows traning a model with multiple batches of data simultaneously. The model has to fit into the GPU memory.

On a cluster, there are many nodes and multiple GPUs on each node. We first introduce a recipe to run PyTorch programs with multiple GPUs on one node, and then extend it to multiple nodes. 

We use an exmaple code that trains a linear network with a random data set, based on the [Distributed Data Parallel](https://PyTorch.org/docs/stable/notes/ddp.html) package in PyTorch. Refer to the description of [this example for multiple GPUs within one node](https://pytorch.org/tutorials/beginner/ddp_series_multigpu.html) and [for multiple GPUs across multiple nodes](https://pytorch.org/tutorials/intermediate/ddp_series_multinode.html). 

Download the codes for this example: [datautils.py](./scripts/torch-gpu/datautils.py), [multigpu.py](./scripts/torch-gpu/multigpu.py), [multigpu_torchrun.py](./scripts/torch-gpu/multigpu_torchrun.py), and [multinode.py](./scripts/torch-gpu/multinode.py).


#### Single-node multi-GPU data parallel

We first introcude a recipe for for single-node multi-GPU data parallel. The program `multigpu.py` is set up for this purpose. 

=== "Engaging"

    To run the program on 4 GPUs within one node, prepare a job script named `job.sh` like this,
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

The program `multigpu.py` will run on 4 GPUs on a single node. The training prcesses happens on 4 batches of data simultaneously. 

Check if the program runs on multiple GPUs using the `nvtop` command as described in the above section.  

There is another way to run a Pytorch prgram with single-node multi-GPU, that is to use the `torchrun` command. The program is chanded to `multigpu_torchrun.py` for this purpose. In the above job script, change the last line to this, 
```
torchrun --nnodes=1 --nproc_per_node=4 --rdzv_id=101 --rdzv_endpoint="localhost:1234" multigpu_torchrun.py --batch_size=1024 100 20
```

With the flag `--nproc_per_node=4`, the `torchrun` command will run the program on 4 GPUs. 

The flags with `rdzv` (meaning the Rendezvous tool) are required by `torchrun` to coordinate multiple processes. The flag `--rdzv-id=$SLURM_JOB_ID` sets to the `rdzv` ID be the job ID, but it can be any random number. The flag `--rdzv-endpoint=localhost:1234 ` is to set the host and the port. Use `localhost` when there is only one node. The port can be any 4-digit number lager than 1024.   

??? GPU communication within one node
    The NVIDIA Collective Communications Library (NCCL) is set as backend in the PyTorch programs `multigpu.py` and `multigpu_torchrun.py`, so the data communication bewteen GPUs within one node benifits from the high bandwidth of NVLinks. 


#### Multi-node multi-GPU data parallel

Now we introcude a recipe to extend the above exmaple to multi-node multi-GPU data parallel. The program `multinode.py` is set up for this purpose. 

There are two key points in this approach.

1. Use the `srun` command in Slurm to launch a `torchrun` command on each node.

2. Set up `torchrun` to coordinate processes on different nodes.

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

The `srun` command lanches a `torchrun` process on each of the two nodes, as the `#SBATCH` flags `-N 2` and `--ntasks-per-node=1` request for tow nodes with one task per node.

The `#SBATCH` flags `--cpus-per-task=4` and `--gpus-per-node=4` request 4 GPU cores and 4 GPUs on each node. Accordingly, the `torchrun` flags are set as `--nnodes=$SLURM_NNODES --nproc-per-node=$SLURM_CPUS_PER_TASK`, so that the `torchrun` command runs the program on 4 CPU cores and 4 GPUs on each of the two nodes. That says the training prcesses happens on 8 GPUs. 

The flags with `rdzv` are required by `torchrun` to coordinate processes across nodes. The `--rdzv-backend=c10d` is to use a C10d store (by default TCPStore) as the rendezvous backend, the  advantage of which is that it requires no 3rd-party dependency. The `--rdzv-endpoint=$master_node_ip:1234 ` is to set up the IP address and port of the the master node. The IP address is obtained in a previous part in the job script.

Refer to details of torchrun on [this page](https://pytorch.org/docs/stable/elastic/run.html).

??? GPU communication within one node nad across nodes
    The NCCL is set as backend in the PyTorch program `multinode.py`, so the data communication bewteen GPUs within one node benifits from the high bandwidth of NVLinks, and the data communication bewteen GPUs acress nodes benifits from the bandwidth of Infiniband network. 





### Model parallel

In a training process of deep learning, the model size is big, especially for the large language models (LLMs) based on the transformer architecture. When the module does not fit in a GPU memory, normal data parallel mentioned above does not work. There is a [Fully Sharded Data Parallel (FSDP)](https://pytorch.org/blog/introducing-pytorch-fully-sharded-data-parallel-api/) approach in PyTorch to split the model into multiple GPUs so that the memory requreiment fits, but this approach is still within the data parallel framework and does not gain additional speed up beyond data parallel. 

A more appropriate approach is model parallel, which split the model into the memory of multiple GPUs and speed up the computation too. There are various schemes of model parallel, such as pipeline parallel and tensor parallel. Usually, model parallel is applied on top of data parallel to gain further speed up. 

Her we use an example with hybrid FSDP

hybrid

FSDP cross node, tp within a node, more data communication. 

https://github.com/pytorch/tutorials/blob/main/intermediate_source/TP_tutorial.rst

Download the codes 

#### Single-node multi-GPU data parallel

hybrid




