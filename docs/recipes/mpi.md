---
tags:
 - Engaging
 - MPI
 - Howto Recipes
---

# Message Passing Interface

Message Passing Interface (MPI) is a standard designed for data communications in parallel computing. The MPI standard defines useful library functions/routines in C, C++, and Fortran. It also works with python interface.   

There are several implementationos of MPI standard, such as `OpenMPI`, `MPICH`, `MVAPICH`, and `Intel MPI`. They work with Infiniband network for high-bandwidth data communications.

=== "Engaging"

### MPI modules

 The support team has built several OpnMPI modules on the cluster. To build or run your MPI programs, load the modules of a `gcc` compiler and an `openmpi` lib to set up environment varialbes. 

 There are two different operations systems (OS) on the cluster: CentOS 7 and Rocky 8. For CentOS 7 nodes, load these,
```
module load gcc/6.2.0 openmpi/3.0.4
```
or
```
module load gcc/9.3.0 openmpi/4.0.5
```
For Rocky 8 nodes, load these,
```
module load gcc/12.2.0 openmpi/4.1.4
```
These modules have been tested and work well. 

>>> Load a `gcc` module first, then the openmpi mouldes built with this `gcc` will be shown in `module av` and thus can be loaded. 


### Build MPI programs

This session is for building MPI programs in C or Fortran. For python users, refer to using `mpi4py` on [this page](https://orcd-docs.mit.edu/recipes/mpi4py/).

Some MPI software are provided with prebuilt binaries only. In this case, download the binaries that are compatible with the `linux` OS and the `x86_64` CPU architecture. If possible, try to choose an OpenMPI version (that the binary was built with) as close as possible to that of a module on the cluser. An example MPI sotware in this case is `ORCA`. 

Most MPI software need to be built from source codes. Downloaded the package from the internet. A typycal building process is like this,
```
./configure CC=mpicc CXX=mpicxx --prefix=</path/to/your/installation>
make
make install
```
Create a directory in `/pool001/$USER` or `/home/$USER` and put it the full path in the `--prefix=` flag. This is where the binaries will be located in. 

Example MPI sotware in this case include `Gromacs`, `Lammps`, `NWchem`, `OpenFOAM` and many others. Eevery sofware is different. Refer to its offical instalation guide for details.

Spack is a popular tool to build software systematically on clusters. It makes building processes easy in many cases, but it may not work in some other cases. If you want to use Spack to build your MPI programs on the cluster, refer to [this page](https://mit-orcd.github.io/orcd-docs-previews/PR/PR29/recipes/spack-basics/) for details. 

If you develop your MPI codes, the codes can be compiled and linked like this
```
mpicc -O3 name.c -o my_program
```
or
```
mpif90 -O3 name.f90 -o my_program
```
This will create an executable file named `my_program`. 

Users can write a `Makefile` to build programs with multiple source files. 


### MPI jobs 

MPI programs are suitable to run on multiple CPU cores of a single node or on multiple nodes. 

Here is an example script (e.g. named `job.sh`) for an MPI job on a single node. 
```
#!/bin/bash
#SBATCH -p sched_mit_hill
#SBATCH -t 30
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=10GB   

srun hostname
module load gcc/6.2.0 openmpi/3.0.4
mpirun -n $SLURM_NTASKS my_program
```
This scripte requests 8 cores (with `-n`) and 10 GB of memory (with `--mem`) on one node (with `-N`). The number of cores specified with `#SBATCH -n` is saved in the variable `SLURM_NTASKS`. The command `mpirun -n $SLURM_NTASKS` ensures that each MPI task runs on one core. 

> The `srun hostname` is to check if the correct number of cores and nodes are assigned to the job. It is not needed in production runs. 

> The modules used in this example is for CentOS 7 OS, which works for the nodes on partitions `sched_mit_hill`, `newnodes`, and `sched_any`. If using a partition with Rocky 8 OS, such as `sched_mit_orcd`, change to the modules accrodingly (see the first session). 

Submit the job with `sbatch`,
```
sbatch job.sh
```

Here is an exmaple for an MPI job on multiple nodes.
```
#!/bin/bash
#SBATCH -p sched_mit_hill
#SBATCH -t 30
#SBATCH -N 2
#SBATCH --ntasks-per-node=8
#SBATCH --mem=10GB

srun hostname
module load gcc/6.2.0 openmpi/3.0.4
mpirun -n $SLURM_NTASKS my_program
```
This requests 2 nodes with 8 cores and 10 GB of memory on each node. The command `mpirun -n $SLURM_NTASKS` ensures that MPI tasks are distributed to both nodes and each MPI task runs on one core. Alternatively, users can specify the number of cores per node using an OpenMPI option like this `mpirun -npernode $SLURM_NTASKS_PER_NODE my_program`.

If replacing `--ntasks-per-node=8` with `-n 16`, the job will request 16 cores on two nodes, but it is not guaranteed that there are 8 cores on each node. For example, it can be 7 cores on one node and 9 cores on another, or 1 core on one node and 15 cores on another, etc. 

> Check `top`. 

To get an idea on how many cores, nodes and memory should be requested, use this command to check node and job info, including the constaint associated with OS (`%f`), the nubmer of CPU cores (`%c`), the memory size (`%m`), the wall time limit (`%l`), and the current usage status (`%t`).    
```
 sinfo -N -p sched_mit_hill,newnodes,sched_any,sched_mit_orcd -o %f,%c,%m,%l,%t |grep -v drain
```
It shows the public partitions that are avaiable to most users. Among theese nodes, the number of cores on each node varies from 16 to 128, and the memory on each node varies from 63 GB to 515 GB. Jobs in these partitions have a wall time limit of 12 hours. Some labs can use their parititions for lab-purchased nodes. 

To get the beset performance of MPI, it is to request all physical CPU cores and memory on each node. For example, request two nodes with 16 cores and all of its memory like this,
```
#SBATCH -N 2
#SBATCH --ntasks-per-node=16
#SBATCH --mem=0
```

According to [Amdahl's law](https://en.wikipedia.org/wiki/Amdahl%27s_law), MPI programs are usually speeded up almost linearly as the number of cores is increased, until it is saturated at some point. It is recommended to test the speed up of your program to decide how many cores are needed. Do not increase the number of cores when the program is speeded up poorly. 


### Hybrid MPI and multithreading jobs

In MPI, memory is distributed, that says, each MPI task owns a piece of data (such as array, matrix, or tensor). Besides MPI, there is a shared-memory parallel computing technique called multithreading, in which the same data is shared by multiple therds. The most common implementation of multithreading is OpenMP. Some programs are designed in a hybrid scheme that combines both MPI and OpenMP. 

A principle to run hybrid MPI-OpenMP progmras is to ensure that this queation is satisfied,
```
(Number of MPI tasks) * (Nubmer of threads) = (Number of nodes) * (Number of cores) 
```

Usually, case. 

-n tasks
-c threads

Not doing this also works, but just confusing and not recommended. 

### MPI + GPU jobs


### MPI applications

There are many programs based on MPI, such as quantum chemestry, MD, CFD. Refe to recipes pages for usage. 



