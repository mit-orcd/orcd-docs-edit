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
     conda create -n pytorch
     source activate pytorch
     conda install pytorch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 pytorch-cuda=12.4 -c pytorch -c nvidia
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
     #SBATCH -n 2
     #SBATCH --mem=10GB
     
     module load cuda/12.4.0
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

The first program will run on CPU and the seocond will run on a GPU. 

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
     #SBATCH -o output/%x-%N-%J.out

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

The PyTorch program will run on 4 GPUs on a single node. The training prcesses happens on 4 batches of data simultaneously. 

Check if the program runs on multiple GPUs using the `nvtop` command as described in the above section.  

=== "Engaging"

    To run on multiple GPUs across two nodes, prepare a job script like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu
     #SBATCH --job-name=ddp-2nodes
     #SBATCH -N 2
     #SBATCH -n 4
     #SBATCH --mem=20GB
     #SBATCH --gpus-per-node=4 
     #SBATCH -o output/%x-%N-%J.out

     module load miniforge/23.11.0-0
     source activate pytorch

     echo "======== Run on multiple GPUs ======"
     # Set 100 epochs and save checkpoints every 20 epochs
     torchrun python multinode.py --batch_size=1024 100 20
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

The `torchrun` command launches the program on 2 nodes with 4 GPUs on each node. The training prcesses happens on 8 batches of data simultaneously. Refer to details of torchrun on [this page](https://pytorch.org/docs/stable/elastic/run.html).


### Tensor parallel

Data


