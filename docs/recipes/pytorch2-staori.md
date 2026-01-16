---
tags:
 - Satori
 - Howto Recipes
 - Pytorch
---

# Installing and Using Pytorch 2 On Satori

Satori is an IBM cluster with the ppc64le architecture, which is different from regular clusters with the x86 architecture. Regular “pip install” and “conda install” do not work for most Python packages. 

There are limited packages with limited versions supported. Only those popular Python packages with some particular versions are available. You can search for the available list on the OpenCE web pages.

https://opence.mit.edu/#/
https://osuosl.org/services/powerdev/opence/#setting-up-the-software-repository

To install the packages listed on the above web pages, you need to prepend the channel. 

conda config --prepend channels https://ftp.osuosl.org/pub/open-ce/current

and then use “conda install” to install your packages. Refer to this page for details of pytorch. 
https://mit-orcd.github.io/orcd-docs-previews/PR/PR30/recipes/pytorch2-staori/
The process to install other packages is similar. Refer to installing Python packages on Saotri on this page: https://orcd-docs.mit.edu/software/python/#__tabbed_1_2


##Installation Steps:

Installing PyTorch version 2.0.1.

####Accessing Conda channel
The Conda channel hosting PyTorch version 2.0.1 can be accessed via the osuosl.org channel URL: https://osuosl.org/services/powerdev/opence

####1. Setting up the Environment:
Login to the designated node (e.g., satori-login-001).
Use srun command to allocate resources for set time (24hrs in the example) and request one GPU (Volta card).
Create a project directory for PyTorch installation and testing.
```
$ srun --time=24:00:00 --gres=gpu:1 --pty /bin/bash
$ mkdir directory
$ cd directory
```
####2. Installing Miniconda:
Download and install Miniconda (Python package manager) for Linux on ppc64le architecture.
Set up Miniconda in a specific directory (./mc3).
```
$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh .
$ chmod +x ./Miniconda3-latest-Linux-ppc64le.sh
$ ./Miniconda3-latest-Linux-ppc64le.sh -b -p ./mc3
$ source ./mc3/bin/activate
```
####3. Creating Conda Enviornment:
Create a Conda environment with Python version 3.10.
Activate the newly created environment.
```
$ conda create --name opence_env_osu_py310 python=3.10
$ conda activate opence_env_osu_py310
```
####4. Configuring Conda Channels and Installing PyTorch:
Add the Open-CE Conda channel.
Install PyTorch version 2.0.1 within the created Conda environment.
```
$ conda config --prepend channels https://ftp.osuosl.org/pub/open-ce/current
$ conda install pytorch==2.0.1
```

##Testing PyTorch Installation:
Create a Python script (test.py) to verify PyTorch installation and GPU recognition.
Run the script to check GPU availability and properties.
```
$ python test.py
```
###Explanation of the Test Script (test.py):
The Python script test.py performs the following tasks:
Imports the PyTorch library.
Retrieves the current GPU device ID.
Gathers GPU properties like name, compute capability, and total memory.
Prints the gathered GPU information.
```
$ cat test.py
import torch
device_id = torch.cuda.current_device()
gpu_properties = torch.cuda.get_device_properties(device_id)

print("Found %d GPUs available. Using GPU %d (%s) of compute capability %d.%d with "
      "%.1fGb total memory.\n" %
      (torch.cuda.device_count(),
       device_id,
       gpu_properties.name,
       gpu_properties.major,
       gpu_properties.minor,
       gpu_properties.total_memory / 1e9))
```

##Additional Notes
By following these steps, you should have installed PyTorch 2.0.1 successfully on Satori and validated its functionality through the provided test script.
If you have further questions, email ocrd-help@mit.edu.

