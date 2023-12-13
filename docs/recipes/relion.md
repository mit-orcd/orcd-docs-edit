---
tags:
 - Satori
 - MPI
 - RELION
 - Howto Recipes
---

# Installing and Using RELION

RELION (for REgularised LIkelihood OptimisatioN, pronounce rely-on) is a software package that employs an empirical Bayesian approach for electron cryo-microscopy (cryo-EM) structure determination. 

## RELION on Satori 

This recipe is for building and using RELION on x86 nodes on Satori. It is different from working on IBM power9 nodes on Satori. 

### Install 

Go to your directory and download RELION,
```
cd /nobackup/users/$USER
git clone https://github.com/3dem/relion.git
```

Get an interactive session on x86 nodes of Satori,
```
srun -p sched_mit_mbathe -c 2 -t 60 --pty bash
```
> Note: The x86 nodes are available to some labs only. 

Load necessary modules
```
module use /software/spack/share/spack/lmod/linux-rocky8-x86_64/Core
module load gcc/12.2.0-x86_64  
module load openmpi/4.1.4-pmi-cuda-ucx-x86_64 
module load fftw/3.3.10-x86_64
```

> Note: These modules are installed for the x86 nodes only. 

Build RELION
```
cd relion
git checkout master 
cd ..
mkdir 4.0.1
cd 4.0.1
mkdir install
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/home/$USER/relion/4.0.1/install ../../relion
make
make install
```

It is all set for the installation.

### Run RELION




