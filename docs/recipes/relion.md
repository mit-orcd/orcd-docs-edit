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

> Note: The x86 nodes are available to some labs only. 

### Install RELION

Go to your directory and download RELION,
```
cd /nobackup/users/$USER
git clone https://github.com/3dem/relion.git
```

Get an interactive session on x86 nodes of Satori,
```
srun -p sched_mit_mbathe -c 2 -t 60 --pty bash
```

Load modules for the GCC compiler and Openmpi implementation,  
```
module use /software/spack/share/spack/lmod/linux-rocky8-x86_64/Core
module load gcc/12.2.0-x86_64  
module load openmpi/4.1.4-pmi-cuda-ucx-x86_64 
```

> Note: These modules are installed for the x86 nodes only. 

Build RELION with CUDA and FFTW features,
```
cd relion
git checkout master 
cd ..
mkdir 4.0.1
cd 4.0.1
mkdir install
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/home/$USER/relion/4.0.1/install -DFORCE_OWN_FFTW=ON -DAMDFFTW=ON -DCUDA_ARCH=80 ../../relion
make
make install
```

It is all set for the installation.

### Use RELION

There is a nice Graphical User Interface (GUI) for RELION. To use the GUI, first log in Satori with x-forwardig support,
```
ssh -Y <user>@satori-login-002.mit.edu
```

Get an interactive session with GPU and x-forwarding support on x86 nodes of Satori,
```
srun --x11 -p sched_mit_mbathe --gres=gpu:1 -c 6 -t 60 --pty bash
```

Set up environment for compilers, mpi implementation, FFTw, and RELION,
```
module use /software/spack/share/spack/lmod/linux-rocky8-x86_64/Core
module load gcc/12.2.0-x86_64  
module load openmpi/4.1.4-pmi-cuda-ucx-x86_64 
module load fftw/3.3.10-x86_64
export LD_LIBRARY_PATH=/nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/fftw-3.3.10-qiaruimvw6zu2h4f5eolqom7tixem6vk/lib:$LD_LIBRARY_PATH
export RELION_HOME=/home/shaohao/pkg/relion/4.0.1/install
export PATH=${RELION_HOME}/bin:$PATH
export LD_LIBRARY_PATH=${RELION_HOME}/lib:$LD_LIBRARY_PATH
```

then open the RELION GUI, 
```
relion &
```

Users can use GUI to edit files or submit jobs. Refer to details on [this page](https://hpc.nih.gov/apps/RELION/index.html).

Alternatively, users can prepare a batch job script to submit jobs. Here is an exaple job script,
```
#!/bin/bash
#SBATCH --partition=sched_mit_mbathe
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH -n 96
#SBATCH --mem=500000
#SBATCH --gres=gpu:4
#SBATCH --nodelist=node2034
#SBATCH --chdir='.'

module use /software/spack/share/spack/lmod/linux-rocky8-x86_64/Core 
module load gcc/12.2.0-x86_64  openmpi/4.1.4-pmi-cuda-ucx-x86_64 
export LD_LIBRARY_PATH=/nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/fftw-3.3.10-qiaruimvw6zu2h4f5eolqom7tixem6vk/lib:$LD_LIBRARY_PATH
export RELION_HOME=/nobackup/users/bmp/software/relion_4.0.1_schedmitmbathe/relion/build
export PATH=${RELION_HOME}/bin:$PATH
export LD_LIBRARY_PATH=${RELION_HOME}/lib:$LD_LIBRARY_PATH

export RELION_QSUB_NRMPI='5'
export RELION_QSUB_NRTHREADS='8'
export RELION_QUEUE_NAME='sched_mit_mbathe'
export RELION_QSUB_COMMAND='sbatch'
export RELION_QSUB_TEMPLATE='/home/bmp/scripts/relion4.0.1_schedmitmbathe_base.sh'

time mpirun -np 1 --oversubscribe `which relion_refine` --o InitialModel/job008/run --iter 200 --grad --denovo_3dref  --i Import/job004/Parameters.star --ctf --K 1 --sym C1  --flatten_solvent  --zero_mask  --dont_combine_weights_via_disc --preread_images  --pool 3 --pad 1  --particle_diameter 250 --oversampling 1  --healpix_order 1  --offset_range 6  --offset_step 2 --auto_sampling  --tau2_fudge 4 --j 1 --gpu ""  --pipeline_control InitialModel/job008/
rm -f InitialModel/job008/RELION_JOB_EXIT_SUCCESS
time mpirun -np 1 --oversubscribe `which relion_align_symmetry` --i InitialModel/job008/run_it200_model.star --o InitialModel/job008/initial_model.mrc --sym C1  --apply_sym --select_largest_class  --pipeline_control InitialModel/job008/
touch InitialModel/job008/RELION_JOB_EXIT_SUCCESS
```

Put the above lines in a file named `job.sh`, then submit the job,
```
sbatch job.sh
```