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

[VASP](https://www.vasp.at) is a first principles simulation tool for electronic structure and quantum mechanical molelcular dynamics computations. The name VASP is an acronym of Vienna Ab-initio Simulation Package. The VASP software is used in quantum chemistry to simulate the properties and structure of atomic scale materials. VASP can compute
detailed atomic structure of molecules, finding terms such as bond lengths and vibration frequencies.

## Building VASP software

VASP is distributed as Fortran source code that must be compiled by end-users to create an executable program. This recipe describes how to compile
VASP using the GNU compiler stack. The recipe shows commands for a Rocky Linux system.

!!! note "Prerequisites"

    * To use VASP a research group must obtain a license from the VASP team as described here [here](https://www.vasp.at/sign_in/registration_form/).
    * This example assumes you have access to a Slurm partition and are working with a Rocky Linux environment.

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

??? tip

     For different versions of VASP, the download file name and directory name will be different. In that case, remember to adjust the example commands above accordingly.

#### 2. Configure the compiler options file

The VASP software is distributed with multiple example compiler options files. 
These are in the sub-directory `arch/`. 
For this example we will use the GNU compiler options file `makefile.include.gnu_omp`. 
To activate the chosen options, copy the options file into the top-level VASP directory.

```bash
cp arch/makefile.include.gnu_omp makefile.include
```

#### 3. Activate the relevant modules

To build the vasp program from the licensed source code several tools and libraries are needed. 
The modules below add the needed software. 
The `gcc` and `openmpi` modules provide compilers (gcc) and computational tools (openmpi) 
needed for parallel computing with VASP. 
The `lapack`, `scalapack`, `fftw` and `openblas` toos are numerical libraries that VASP uses.

```bash
module load gcc/12.2.0-x86_64
module load openmpi/4.1.4-pmi-cuda-ucx-x86_64
module load netlib-lapack/3.10.1-x86_64
module load netlib-scalapack/2.2.0-x86_64
module load fftw/3.3.10-x86_64
module load openblas/0.3.21-x86_64
```

#### 4. Set environment variables that are needed for compilation

The compilation scripts that come with VASP include variables that must be set to
the clusters local values. Here we set environment variables to hold those settings.

```bash
SCALAPACK_ROOT=`module -t show  netlib-scalapack 2>&1 | grep CMAKE_PREFIX_PATH | awk -F, '{print $2}'  | awk -F\" '{print $2}'`
FFTW_ROOT=`pkgconf --variable=prefix fftw3`
OPENBLAS_ROOT=$(dirname `pkgconf --variable=libdir openblas`)
```

#### 5. Compile the VASP code

To compile the VASP code use the `make` program, passing it the environment variable settings as
shown. The settings shown will also build the Fortran 90 modules that VASP includes. Typically th

```bash
make -j OPENBLAS_ROOT=$OPENBLAS_ROOT FFTW_ROOT=$FFTW_ROOT SCALAPACK_ROOT=$SCALAPACK_ROOT MODS=1 DEPS=1
```

### 6. Check the VASP executables

The above commands should generate VASP executable programs `bin/vasp_std`, `bin/vasp_gam` and
`bin/vasp_ncl`. To test that these programs can execute the following commands can be used.

```bash
export LD_LIBRARY_PATH=${OPENBLAS_ROOT}/lib:${FFTW_ROOT}/lib:${SCALAPACK_ROOT}/lib:${LD_LIBRARY_PATH}
bin/vasp_std
```

if the code has compiled sucesfully the follow output should be generated. This output shows that the 
VASP program can be run. The output shows an error because no input files have been configured.

```
 -----------------------------------------------------------------------------
|                                                                             |
|     EEEEEEE  RRRRRR   RRRRRR   OOOOOOO  RRRRRR      ###     ###     ###     |
|     E        R     R  R     R  O     O  R     R     ###     ###     ###     |
|     E        R     R  R     R  O     O  R     R     ###     ###     ###     |
|     EEEEE    RRRRRR   RRRRRR   O     O  RRRRRR       #       #       #      |
|     E        R   R    R   R    O     O  R   R                               |
|     E        R    R   R    R   O     O  R    R      ###     ###     ###     |
|     EEEEEEE  R     R  R     R  OOOOOOO  R     R     ###     ###     ###     |
|                                                                             |
|     No INCAR found, STOPPING                                                |
|                                                                             |
|       ---->  I REFUSE TO CONTINUE WITH THIS SICK JOB ... BYE!!! <----       |
|                                                                             |
 -----------------------------------------------------------------------------

 -----------------------------------------------------------------------------
|                                                                             |
|     EEEEEEE  RRRRRR   RRRRRR   OOOOOOO  RRRRRR      ###     ###     ###     |
|     E        R     R  R     R  O     O  R     R     ###     ###     ###     |
|     E        R     R  R     R  O     O  R     R     ###     ###     ###     |
|     EEEEE    RRRRRR   RRRRRR   O     O  RRRRRR       #       #       #      |
|     E        R   R    R   R    O     O  R   R                               |
|     E        R    R   R    R   O     O  R    R      ###     ###     ###     |
|     EEEEEEE  R     R  R     R  OOOOOOO  R     R     ###     ###     ###     |
|                                                                             |
|     No INCAR found, STOPPING                                                |
|                                                                             |
|       ---->  I REFUSE TO CONTINUE WITH THIS SICK JOB ... BYE!!! <----       |
|                                                                             |
 -----------------------------------------------------------------------------

STOP 1
```

### 7. An example script to compile and run VASP

The commands above can be combined into a single script as shown below. This example
shows a script that can either be run from the command line or submitted to Slrum 
as a batch job.

