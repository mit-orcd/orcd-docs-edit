---
tags:
 - Engaging
 - Pytorch
 - GPU
 - Howto Recipes
---

# Run PyTorch on GPUs

PyTorch is a popular Python package for working on deep learning project. Deep leaning codes can be accelerated substantially on GPUs. 

This page shows recipes to run PyTorch codes on CPU, a single GPU and multiple GPUs. 


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

## Run PyTorch on CPU and a single GPU

=== "Engaging"

     We use a PyTorch eample, which trains a Convolutional neural network (CNN) based on the CIFAR10 data set. Refer to [description of this example](https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html). 
     
     Download the codes [for CPU](./codes/cnn_cifar10_cpu.py) and [for GPU](./codes/cnn_cifar10_gpu.py).
     
     Prepare a job script named `job.sh` like this,
     ```
     #!/bin/bash
     #SBATCH -p mit_normal_gpu   
     #SBATCH --gres=gpu:1 
     #SBATCH -t 30
     #SBATCH -n 2
     #SBATCH --mem=10GB
     #SBATCH -o output/%N-%J.out
     
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

## Run PyTorch on multiple GPUs with data parallel

There are defferent schemes on

### Data parallel
=== "Engaging"
    test. 
     


