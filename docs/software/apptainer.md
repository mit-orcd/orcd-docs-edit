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

Container provides an isolated environment that supports user applications. In many cases, it is helpful to use container to obtain the needed environment for your applications on HPC clusters, so as to avoid installing too many dependencies. 

Container has great portability and mobility, that says, it is convenient to migrate your applications bewtween different platforms, such as laptops/desktops, cloud platforms and HPC clusters. 

The most widely used container is Docker, which is designed for laptops/desktops and cloud platforms. On ORCD clusters, we use another kind of conatainer: Apptainer and Singularity, which are particularly designed for high-perfromance computing. Apptainer is extended from Singularity. Both are compatible with Docker. 

!!! note 
    In the following, the terminology Singularity will be used. The statements hold if it is replaced by  Apptainer in most cases. 

Users can use Singularity to support many applications, such as Python, R, Julia, compiling C/Fortran packages, and many GUI software. In particular, container is polular in supporting Python pakcages for the artificial intelligence and data science communities, such as Pytorch, Tensorflow, and many others. 

In this docuemnt, the first several sections are focused on how to use Singularity on ORCD clusters. The last section will be focused on how to build Docker image on your laptop and migrate it to ORCD clusters. 


## Run programs with Apptainer

=== "OpenMind"

A typical workflow to use a Singularity container on ORCD cluster is the following. First, many applications are well-supported in existing Apptainer or Docker images. Search for an image on Docker Hub, in which the needed applicaiton has already been installed by some developers, then download and use it directly. If there is no suitable image for the needed application, you can build an image. Here is the step-by-step how-to document. 


### 1. Preparations

Get an interactive session on a compute node with the Rocky 8 system.
```
srun -t 500 --constraint=rocky8 -c 4 --mem=10G --pty bash
```
Check available Apptainer versions on Openmind,
```
module av openmind8/apptainer
```
Load an Apptainer module,
```
module load openmind8/apptainer/1.1.7
```

### 2. Download an existing container

Search for a container that provides your desired operating system and software stack (e.g. in [Docker Hub](https://hub.docker.com/), [Singularity Hub](https://singularity-hub.org/search), or [Neurodocker](https://github.com/ReproNim/neurodocker)). 

Here is an example of downloading a container from Docker Hub to support Pytorch. 
```
apptainer build --sandbox my-container  docker://bitnami/pytorch:latest
```

The command `build` here does nothing but download and convert. The flag `--sandbox` is to convert the container to the Sandbox format, which is convenient for adding more packages in step 4. If no more package is needed, remove the `--sandbox` flag. 

!!! note 
    All the `apptainer` commands on this page can be replaced by the `singularity` command. They work the same. 


### 3. Run your application in the container

If the container already provides all the needed software, you can run your application in the container. 

For example, shell into the container and run your application (Pytorch here).  
```
apptainer shell my-container
Apptainer> python
Python 3.8.17 (default, Jun 16 2023, 21:48:21) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
```

Or, execute a command via the container,
```
singularity exec my-container python
```

By default, the home directory and the `/tmp` directory are bound to the container. The `/om` or `/om2` directories are often used to store data, bind them using `-B` when needed,
```
apptainer shell -B /om,/om2 my-container
```

!!! note 
    Use the flag `--nv` to provide GPU support in the container when needed. 


### 4. Submit a batch job to use Apptainer 

When the test is successful, it is recommended to submit a batch job to run your program, 
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
module load openmind8/apptainer/1.1.7                    # load a singularity module
apptainer exec --nv -B /om,/om2  my-container python my-code.py    # Run the job steps 
```
Fill in the container name including the full path. 

!!! note
    Here shows an example of Python. Other applications are used in similar ways.  


## Build Apptainer images



It often happens that some needed packages do not exist in the originally downloaded base container. In this case, build these packages in the base container. 

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


## Build a Docker image and run it with Apptainer
