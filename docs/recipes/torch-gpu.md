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

We use an example code training a Convolutional neural network (CNN) based on the CIFAR10 data set. Refer to [description of this example](https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html). 
     
 Download the [codes for CPU](./scripts/torch-gpu/cnn_cifar10_cpu.py) and [for GPU](./scripts/torch-gpu/cnn_cifar10_gpu.py). 

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

There are various parallelisms to implement distributed deep leaning programs on mulitple GPUs, including data parallel and tensor parallel. 

### Data parallel

We use an exmaple code that trains a linear network based on a random data set. The Pytorch package [Distributed Data Parallel](https://PyTorch.org/docs/stable/notes/ddp.html) is used. Refer to [description of this example](https://pytorch.org/tutorials/beginner/ddp_series_multigpu.html).  

Download the codes [datautils.py](./scripts/torch-gpu/datautils.py) and [multigpu.py](./scripts/torch-gpu/multigpu.py). 

=== "Engaging"
    Prepare a job script named `job.sh` like this,
     ```
     #!/bin/bash
     ```
     then submit it,
     ```
     sbatch job.sh
     ```

The program will run on 4 GPUs on a single node. 

Check if the program runs on multiple GPUs using the `nvtop` command as described in the above section.  

=== "Engaging"
    To run on multiple GPUs on multiple nodes, modify the job script like this,
     ```
     #!/bin/bash
     ```

The program will run on 2 ndoes with 4 GPUs on each node. 


