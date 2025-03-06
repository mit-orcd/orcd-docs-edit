---
tags:
 - Engaging
 - Pytorch
 - GPU
 - Howto Recipes
---

# PyTorch on One GPU

PyTorch is a popular Python package for working on deep learning project. Deep leaning codes can be accelerated substantially on GPUs. This page shows a recipe to run a PyTorch code on a GPU. 


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

## A basic example of PyTorch

=== "Engaging"

     We use a PyTorch eample, which trains a Convolutional neural network (CNN) based on the CIFAR10 data set. Refer to [description of this example](https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html). 
     
     Download the codes [for CPU](./codes/cnn_cifar10_cpu.py) and [for GPU](./codes/cnn_cifar10_gpu.py). 
     

## Submit jobs

=== "Engaging"

     First,
     

