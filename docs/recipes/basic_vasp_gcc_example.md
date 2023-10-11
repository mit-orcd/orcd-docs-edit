---
tags:
 - Engaging
 - Howto Recipes
 - MPI
 - cuda
 - cuda aware mpi
 - GPU
 - VASP
 - Rocky Linux
---

# Example of a build of the VASP software.

## About VASP

VASP is a first principles simulation tool for electronic structure and quantum mechanical molelcular dynamics computations. The name VASP is an acronym of Vienna Ab-initio Simulation Package. The VASP software is used in quantum chemistry to simulate the properties and structure of atomic scale materials. VASP can compute
detailed atomic structure of molecules, finding terms such as bond lengths and vibration frequencies.

## Building VASP software

VASP is distributed as Fortran source code that must be compiled by end-users to create an executable program. This recipe describes how to compile
VASP using the GNU compiler stack. The recipe shows commands for a Rocky Linux system.

!!! note "Prerequisites"

    To use VASP a research group must obtain a license from the VASP team as described here [here](https://www.vasp.at/sign_in/registration_form/).

!!! note "Prerequisites"

    This example assumes you have access to a Slurm partition and are working with a Rocky Linux environment.

#### 1. Extract VASP source code files

Once a licensed copy of VASP has been obtained the source code files must be extracted from the provided tar file that is
distributed. The command

```bash
tar -xzvf vasp.6.4.2.tgz
```

will extract the source files and their directory tree. This command should be executed in a sub-directory where you will
store the compiled VASP programs. 

Once the code has been extracted, switch to use the VASP directory for the remaining steps

```bash
cd vasp.6.4.2
```

#### 2. Configure the compiler options file

The VASP software is distributed with multiple example compiler options file in the sub-directory `arch/`. For this example
we will use the GNU compiler options file `makefile.include.gnu_omp`. We activate these options by copying file to the
top-level VASP directory.

```bash
cp arch/makefile.include.gnu_omp makefile.include
```

#### 3. Activate the relevant modules

To build the vasp program from the licensed source code several tools and libraries are needed. The modules below
add the needed software. The `gcc` and `openmpi` modules provide compilers (gcc) and computational tools (openmpi) 
needed for parallel computing with VASP. The `lapack`, `scalapack`, `fftw` and `openblas` toos are numerical libraries
that VASP uses.

```bash
module load gcc/12.2.0-x86_64
module load openmpi/4.1.4-pmi-cuda-ucx-x86_64
module load netlib-lapack/3.10.1-x86_64
module load netlib-scalapack/2.2.0-x86_64
module load fftw/3.3.10-x86_64
module load openblas/0.3.21-x86_64
```

#### 4. Set environment variables that are needed for compilation


```bash
SCALAPACK_ROOT=`module -t show  netlib-scalapack 2>&1 | grep CMAKE_PREFIX_PATH | awk -F, '{print $2}'  | awk -F\" '{print $2}'`
FFTW_ROOT=`pkgconf --variable=prefix fftw3`
OPENBLAS_ROOT=$(dirname `pkgconf --variable=libdir openblas`)
```

#### 5. Build the code

```bash
make -j OPENBLAS_ROOT=$OPENBLAS_ROOT FFTW_ROOT=$FFTW_ROOT SCALAPACK_ROOT=$SCALAPACK_ROOT MODS=1 DEPS=1
```
