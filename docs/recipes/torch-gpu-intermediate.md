---
tags:
 - Engaging
 - Pytorch
 - GPU
 - Howto Recipes
---

# Intermediate Distributed Deep Leaning with PyTorch

Deep leaning is the foundation of artificial intelligence nowadays. Deep leaning programs can be accelerated substantially on GPUs. 
 
There are various parallelisms to enable distributed deep learning on multiple GPUs, including data parallel and model parallel. 

We have introduced [basic recipes of data parallel with PyTorch](./torch-gpu.md) . PyTorch is a popular Python package for working on deep learning projects.

In data parallel, the model has to fit into the GPU memory. However, in nowadays deep-learning training processes, the model size is very big,  especially for the large language models (LLMs) based on the transformer architecture. When the model does not fit into the memory of a single GPU, the normal data parallelism does not work. 

On this page, we will introudce intermediate recipes to train large models on multiple GPUs with PyTorch. 

First, there is a [Fully Sharded Data Parallel (FSDP)](https://pytorch.org/blog/introducing-pytorch-fully-sharded-data-parallel-api/) approach to split the model into multiple GPUs so that the memory requreiment fits. Each GPU stores a shard of the model and communicate between GPUs during the training process. We will introcude recipes of FSDP in the first section. 

However, FSDP is within the data parallel framework and does not gain additional speedup beyond data parallel. Better approaches are based on model parallel, which not only splits the model into multiple GPUs but also accelerate the porgram with parallel computations. There are various schemes of model parallel, such as pipeline parallel (PP) and tensor parallel (TP). Usually, model parallel is applied on top of data parallel to gain further speedup. We will focus on recipes of hybrid Fully Sharded Data Parallel and Tensor Parallel (refered as FSDP + TP) in the second section. 


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
     This installs PyTorch with CUDA support by default, which enables it running on GPUs. 


## Fully Sharded Data Parallel 

We use an example code [training a convolutional neural network (CNN) with the MNIST data set](https://github.com/pytorch/examples/tree/main/mnist). 

We will first run the example on a single GPU and then extend it to [multiple GPUs with FSDP](https://pytorch.org/tutorials/intermediate/FSDP_tutorial.html).

Download the codes [mnist_gpu.py](./scripts/torch-gpu/mnist_gpu.py) and [FSDP_mnist.py](./scripts/torch-gpu/FSDP_mnist.py) respectively for the two cases. 

### An example with a single GPU 

=== "Engaging"  

     To run the example on a single GPU, prepare a job script named `job.sh` like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu
     #SBATCH --job-name=mnist-gpu
     #SBATCH -N 1
     #SBATCH -n 1
     #SBATCH --mem=20GB
     #SBATCH --gres=gpu:1  

     module load miniforge/24.3.0-0
     source activate torch

     python mnist.py
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

While the job is running, you can check if the program runs on a GPU. First, check the hostname that it runs on,
```
squeue -u $USER
```
and then log in the node,
```
ssh <nodeXXX>
```
and check the GPU usage with the `nvtop` command.


### Single-node multi-GPU FSDP

We extend this exeample to multiple GPUs on a single node. 

=== "Engaging"  

     Prepare a job script named `job.sh` like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu 
     #SBATCH --job-name=fsdp
     #SBATCH -N 1
     #SBATCH -n 4
     #SBATCH --mem=20GB
     #SBATCH --gres=gpu:4

     module load miniforge/24.3.0-0
     source activate torch

     python FSDP_mnist.py
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

As is set up in the protram `FSDP_mnist.py`, it will run on all GPUs reqeusted in Slurm, that is 4. That says the model is split into 4 shards with each shard stored on a GPU, and the training process happens on 4 batches of data simutanesously. 


## Hybrid Fully Sharded Data Parallel and Tensor Parallel 

In thie section, we introduce recipes of hybrid FSDP and TP.

We use an example that implements FSDP + TP on LLAMA2 (Large Language Model Meta AI 2). Refer to [the description of this example](https://pytorch.org/tutorials/intermediate/TP_tutorial.html). Download the codes: [fsdp_tp_example.py](./scripts/torch-gpu/fsdp_tp_example.py), [llama2_model.py](./scripts/torch-gpu/llama2_model.py), and [log_utils.py](./scripts/torch-gpu/log_utils.py).

### Single-node multi-GPU FSDP + TP

We first look at a recipe for runing the example on multiple GPUs on a single node. 

The code `fsdp_tp_example.py` is set up for this purpose. The TP size is equal to 2 in the code. The total number of GPUs should be equal to multiple of the TP size, meaning an even number here, then the FSDP size is equal number of GPUs devided by TP size.

=== "Engaging"
     To run the example on 4 GPUs, prepare a job script like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu
     #SBATCH -t 60
     #SBATCH -N 1
     #SBATCH -n 4
     #SBATCH --mem=30GB
     #SBATCH --gres=gpu:4

     module load miniforge/24.3.0-0
     source activate torch
     
     torchrun --nnodes=1 --nproc_per_node=4 \
              --rdzv_id=$SLURM_JOB_ID \
              --rdzv_endpoint="localhost:1234" \
              fsdp_tp_example.py 
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

With the flags `--nnodes=1 --nproc-per-node=4`, the `torchrun` command will run the program on 4 GPUs within one node. The training process happens on 2 batches of data with FSDP,  and the model is trained with TP computation on 2 GPUs for each batch of data.

The flags with `rdzv` (meaning the Rendezvous protocol) are required by `torchrun` to coordinate multiple processes. The flag `--rdzv-id=$SLURM_JOB_ID` sets to the `rdzv` ID be the job ID, but it can be any random number. The flag `--rdzv-endpoint=localhost:1234 ` is to set the host and the port. Use `localhost` when there is only one node. The port can be any 4- or 5-digit number lager than 1024. 


### Multi-node multi-GPU FSDP + TP

Finally, we extend this exampel on multiple GPUs across multiple nodes. 

=== "Engaging"
     Prepare a job script like this,
     ```
     #!/bin/bash
     #SBATCH -p  mit_normal_gpu
     #SBATCH -N 2
     #SBATCH --ntasks-per-node=1
     #SBATCH --cpus-per-task=4
     #SBATCH --gpus-per-node=4 
     #SBATCH --mem=30GB

     module load miniforge/24.3.0-0
     source activate torch
     
     # Get IP address
     nodes=( $( scontrol show hostnames $SLURM_JOB_NODELIST ) )
     nodes_array=($nodes)
     master_node=${nodes_array[0]}
     master_node_ip=$(srun --nodes=1 --ntasks=1 -w "$master_node" hostname --ip-address)

     srun torchrun --nnodes=$SLURM_NNODES \
               --nproc-per-node=$SLURM_CPUS_PER_TASK \
               --rdzv-id=$SLURM_JOB_ID   \
               --rdzv-backend=c10d \
               --rdzv-endpoint=$master_node_ip:1234 \
               fsdp_tp_example.py
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

The configuration of `#SBATCH` and `torchrun` flags is similar to that in [the basic recipes of data parallel](./torch-gpu.md). 

The program runs on 8 GPUs with 4 per node. As is set up in the code `fsdp_tp_example.py`, the training process happens on 4 batches of data with FSDP,  and the model is trained with TP computation on 2 GPUs for each batch of data.

??? "Topology of GPU Communication"
    The NVIDIA Collective Communications Library (NCCL) is set as backend in all of the PyTorch programs here, so that the data communication between GPUs within one node benefits from the high bandwidth of NVLinks, and the data communication between GPUs across nodes benefits from the bandwidth of the Infiniband network. 

    The inter-node communication is much slower than the intra-node one. The communicating data size of TP is much larger than that of FSDP. The topology of GPU Communication is set up (in the code `fsdp_tp_example.py`) in a way that TP communication is intra-node and FSDP communication is inter-node node, so that the usage of bandwidth is optimized. 


## Rference

orcd github
