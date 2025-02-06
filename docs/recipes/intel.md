---
tags:
 - Intel
 - Compiler
 - C
 - Fortran
 - Howto Recipes
---

# Intel compiler

Intel compiler is optimized for intel CPUs. It provides the Math Kernel Library (MKL) in which linear algebra computations are optimized. The performance of C and Fortran codes can be improved on Intel CPUs if compiled with Intel compiler. It provides an MPI implemetation for MPI programs that run on multipe nodes. Users should choose the Intel compiler for intel CPUs when possible. 


## Set up environment on Rocky 8 nodes

If you use Rocky 8 nodes, log in to an appropriate head node first,
```
ssh <user>@orcd-login003.mit.edu
```

Load an intel module,
```
intel/2024.2.1
```

Check commands for intel compiler and MPI and environment variables for MKL are ready for use,
```
$ which icx
/orcd/software/community/001/rocky8/intel/2024.2.1/compiler/2024.2/bin/icx
$ which ifort
/orcd/software/community/001/rocky8/intel/2024.2.1/compiler/2024.2/bin/ifort
$ which mpicc
/orcd/software/community/001/rocky8/intel/2024.2.1/mpi/2021.13/bin/mpicc
$ which mpiifort
/orcd/software/community/001/rocky8/intel/2024.2.1/mpi/2021.13/bin/mpiifort
$ echo $MKLROOT
/orcd/software/community/001/rocky8/intel/2024.2.1/mkl/2024.2
```


## Set up environment on CentOS 7 nodes

If you use CentOS 7 nodes, log in to an appropriate head node first,
```
ssh <user>@orcd-vlogin003.mit.edu
```

Load the modules for intel compiler, intel MPI and MKL,
```
module load intel/2018-01
module load impi/2018-01
module load mkl/2018-01 
```

Check commands for intel compiler and MPI and environment variables for MKL are ready for use,
```
$ which icc
/home/software/intel/2018-01/bin/icc
$ which ifort
/home/software/intel/2018-01/bin/ifort
$ which mpicc
/home/software/intel/2018-01/compilers_and_libraries_2018.1.163/linux/mpi/intel64/bin/mpicc
$ which mpiifort
/home/software/intel/2018-01/compilers_and_libraries_2018.1.163/linux/mpi/intel64/bin/mpiifort
$ echo $MKLROOT
/home/software/intel/2018-01/compilers_and_libraries_2018.1.163/linux/mkl/
```

## Compile and run programs with Intel compiler

Once the environment is set up in either of the preivous two sections, you can compile your C or Fortran codes like this,
```
icx -O3 name.c -o name
ifort -O3 name.c -o name
```
or MPI codes,
```
mpicc -O3 name.c -o name
mpiifort -O3 name.c -o name
```

If you use GNU Make to build your program, set up the varialbes in the Makefile, 
```
CC=icc
FC=ifort
MPICC=mpicc
MPIFC=mpiifort
```
Use the variable `MKLROOT` in the Makefile when needed.

To run your program compiled on Rocky 8 nodes, submit jobs to a partition with Rocky 8 and specify the OS with `--constraint=rocky8`. 

To run your program compiled on CentOS 7 nodes, submit jobs to a partition with CentOS 7 and specify the OS with `--constraint=centos7`. 


## References

Refer to the following references for more details on logging in, compiling C/Fortran codes, using GNU make, and using partitions in Slurm job scheduler. 

> [Log in the system](https://orcd-docs.mit.edu/accessing-orcd/ssh-login/) . 

> [Compile C/Fortran Codes and Use GNU Make](https://orcd-docs.mit.edu/software/compile/). 

> [Use Slurm to submit jobs](https://orcd-docs.mit.edu/running-jobs/overview/). 
