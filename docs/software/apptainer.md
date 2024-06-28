---
tags:
 - Engaging
 - OpenMind
 - SuperCloud
 - Apptainer
 - Singularity
 - Howto Recipes
---

# Apptainer and Singularity

Container provides an isolated environment that supports user applications. In many cases, it is helpful to use a container to obtain the environment for your applications on HPC clusters, so as to avoid installing too many dependencies.

Container has great portability and mobility, that says, it is convenient to migrate your applications bewtween different platforms, such as laptops/desktops, cloud platforms and HPC clusters. 

The most well known container is Docker, which is designed for laptops/desktops and cloud platforms. On ORCD clusters, we use Apptainer and Singularity, which are particularly designed for high-perfromance computing. Apptainer is extended from Singularity. Both are compatible with Docker. 

!!! note 
    In the following, the terminology Singularity will be used in most cases. The statements hold if the words Singularity and Apptainer are switched. 

Users can use Singularity to support many applications, such as Python, R, Julia, C/Fortran packages, and many GUI software. In particular, container is polular in supporting Python pakcages for the artificial intelligence and data science communities, such as Pytorch, Tensorflow, and many others. 

In this docuemnt, we will focuse on how to use Singularity on ORCD clusters. A typical workflow to use Singularity on ORCD cluster is the following. First, many applications are well-supported in existing Docker images. Search for an image on the internet, in which your target applicaiton has already been installed by some developers, then download the image and use it directly. If there is no suitable image for your target application, you can build an image to support it.

!!! note 
    Image is a file to support container. Users can launch a containter from an image. 


## Run applications with Singularity

=== "OpenMind"

Let us start with running an application with Singularity on the cluster frist. 

### 1. Preparations

As Singularity needs computing resources, alwways start with getting an interactive session on a compute node with the Rocky 8 OS,
```
srun -t 500 --constraint=rocky8 -c 4 --mem=10G --pty bash
```
Check available Apptainer versions in modules,
```
module av openmind8/apptainer
```
Load an Apptainer module, for example, 
```
module load openmind8/apptainer/1.1.7
```

!!! note 
    Apptainer supports both apptainer and singularity commands.


### 2. Download an image

Search for an image that provides your target application, for exmaple on [Docker Hub](https://hub.docker.com/). Here is an example for downloading an Docker image to support Pytorch. 
```
singularity pull pytorch.sif docker://bitnami/pytorch:latest
```
The `pytorch.sif` is the name of the image. You can name it as you like. 

!!! note 
    When using an Apptainer module, the `singularity` file is a soft link to an executable named `apptainer`, so all `singularity` commands on this page can be replaced by the `apptainer` command. They work the same. 


### 3. Run your application in the container

When the image is ready, launch a container from the image and then run your application. For example, shell into the container and run your codes interactively,  
```
$ singularity shell pytorch.sif 
Apptainer> python
Python 3.11.9 (main, May 13 2024, 16:49:42) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> # Run your codes here.
```

Alternatively, execute a command to run your codes in the container, 
```
singularity exec pytorch.sif python my-code.py
```

### 4. Submit a batch job to use Apptainer 

When the test run process is completed, it is recommended to submit a batch job to run your program, 
```
sbatch job.sh
```

Here is a typical batch job script (e.g. named `job.sh`):
```
#!/bin/bash                      
#SBATCH -t 01:30:00                  # walltime = 1 hours and 30 minutes
#SBATCH -N 1                         #  one node
#SBATCH -n 2                         #  two CPU (hyperthreaded) cores
#SBATCH --gres=gpu:1                 #  one GPU
#SBATCH --constraint=high-capacity   #  high-capacity GPU
module load openmind8/apptainer/1.1.7                     # load a singularity module
apptainer exec --nv -B /om,/om2  pytorch.sif python my-code.py    # Run the job steps 
```
Use the full path if the image file is not in the current directory. 

!!! note
    Here shows an example of Python. Other applications are similar.  


## More on using Singularity

By default, the home directory and the `/tmp` directory are bound to the container. The `/om` or `/om2` directories are often used to store data, bind them using `-B` when needed,
```
apptainer shell -B /om,/om2 my-container
```

!!! note 
    Use the flag `--nv` to provide GPU support in the container when needed. 

## Build Singualrity images

It often happens that some needed packages do not exist in the originally downloaded base container. In this case, build these packages in the base container. 

Search for an image with the operating system and software stack that supports your target application the best. 

Search for an image that provides your target application, for exmaple on [Docker Hub](https://hub.docker.com/). Here is an example for downloading an image to support Pytorch. 
```
apptainer build --sandbox my-container  docker://bitnami/pytorch:latest
```

The command `build` here does nothing but download and convert. The flag `--sandbox` is to convert the container to the Sandbox format, which is convenient for adding more packages in step 4. If no more package is needed, remove the `--sandbox` flag. 

Contiue from step 3. 

For example, if you want to use Pandas together with Pytorch, build it like this,
```
$ apptainer shell --writable my-container
Apptainer> apt-get update
Apptainer> pip install pandas
Apptainer> python 
Python 3.8.17 (default, Jun 16 2023, 21:48:21) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import pandas as pd
```

The flag `--writable` is to enable permission to modify the container. 

??? note
    The `sudo` command is not needed here. 

Fakeroot for apt-get.

Build an image on other machines and run it with Singularity on the clusters. 

Build a Docker image on your MAC or PC. 
Build a Singularity image on your Linux machine.

