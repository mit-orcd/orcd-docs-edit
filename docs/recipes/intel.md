---
tags:
 - Intel
 - Compiler
 - C
 - Fortran
 - Howto Recipes
---

# Intel compiler

Intel compiler is optimized for intel CPUs. It provides an MPI implemetation and the Math Kernel Library (MKL). The performance of C and Fortran codes can be improved on Intel CPUs if compiled with Intel compiler.


## Use Intel compiler on Rocky 8 nodes

Log in to the Rocky 8 head node first,
```
ssh <user>@orcd-login003.mit.edu
```

> Refer to [this page](https://orcd-docs.mit.edu/accessing-orcd/ssh-login/) for login. 

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

Compile your C or Fortran codes,
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
CC=icx
FC=ifort
MPICC=mpicc
MPIFC=mpiifort
```
Use the variable `MKLROOT` in the Makefile when needed.

See the reference at the end of this page for how to compile C/Fortran codes and use GNU make. 


## Use Intel compiler on CentOS 7 nodes

Log in to the Rocky 8 head node first,
```
ssh <user>@orcd-vlogin003.mit.edu
```

> Refer to [this page](https://orcd-docs.mit.edu/accessing-orcd/ssh-login/) for login. 

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

If you use GNU Make to build your program, set up the varialbes in the Makefile, 
```
CC=icc
FC=ifort
MPICC=mpicc
MPIFC=mpiifort
```
Use the variable `MKLROOT` in the Makefile when needed.

See the reference at the end of this page for how to compile C/Fortran codes and use GNU make. 

??? "Reference: compile C/Fortran codes and GNU make"
    Refer to [this page](https://orcd-docs.mit.edu/accessing-orcd/ssh-login/). 