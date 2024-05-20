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

Container provides an isolated environment that supports user applications. In many cases, it is helpful to use container to obtain the needed environment for your applications on HPC clusters, so as to avoid installing too many dependencies. Container has great portability and mobility, that says, it is convenient to migrate your applications bewtween different platforms, such as laptops/desktops, cloud platforms and HPC clusters. 

The most famous container is Docker, which is designed for laptops/desktops and cloud platforms. Here we will mostly focus on another kind of conatainer Apptainer and Singularity, which are particularly designed for HPC culsters. Apptainer is an extension of Singularity. Both are compatible with Docker.  

!!! note 
   In the following, the terminology Apptainer will be used. The statements hold if the word Apptainer is replaced by Singularity in most cases. 

Users can use Apptainer to support many applications, such as Python, R, Julia, compiling C/Fortran packages, and many GUI software. In particular, container is polular in supporting Python pakcages for the artificial intelligence and data science communities, such as Pytorch, Tensorflow, and many others. 

This document is a tutorial for using Apptianer on ORCD clusters.


## Run programs with Apptainer


=== "OpenMind"

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
$ apptainer build --sandbox my-container  docker://bitnami/pytorch:latest
```

The command `build` here does nothing but download and convert. The flag `--sandbox` is to convert the container to the Sandbox format, which is convenient for adding more packages in step 4. If no more package is needed, remove the `--sandbox` flag. 

!!! note 
   All the `apptainer` commands on this page can be replaced by the `singularity` command. They work the same. 


### 3. Run your application in the container

If the container already provides all the needed software, you can run your application in the container. 

For example, shell into the container and run your application (Pytorch here).  
```
$ apptainer shell my-container
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



## Build Apptainer images



## Build a Docker image and run with Apptainer
