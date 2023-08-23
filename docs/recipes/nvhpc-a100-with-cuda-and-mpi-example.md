---
tags:
 - Engaging
 - Howto Recipes
 - nvhpc
 - mpi
 - cuda
 - cuda aware mpi
---

# Example of a minimal program using the nvhpc stack with CUDA aware MPI

## About NVHPC

NVHPC is an integrated collection of software tools and libraries distributed by NVidia. An overview document describing nvhpc 
can be found [here](https://developer.nvidia.com/hpc-sdk).
The aim of the nvhpc team is to provide up to date, preconfigured suites of compilers, libraries and tools that are 
specifically optimized for NVidia GPU hardware. It supports single and multi-GPU execution.

## Basic Usage Example

This example shows steps for using NVHPC to run a simple test MPI program, written in C, that communicates between two GPUs.
The detailed steps, that can be executed in an interactive Slurm session, are explained 
below.  A complete Slurm job example is shown at the end.

#### 1. Activate the relevant NVHPC module

The NVHPC environment is installed as a module and can be made visible in a session using the command

```bash
module load nvhpc/2023_233/nvhpc/23.3
```

this will add a specific version of the nvhpc software (version 23.3 released in 2023) to a shell or batch script. The
software added includes compilers for C, C++ and Fortran; base GPU optimized numerical libraries for linear algebra, Fourier
transforms and others; GPU optimized communication libraries supporting MPI, SHMEM and NCCL APIs.

An environment variable, `NVHPC_ROOT`, is also set. This can be used in scripts to reference the locations of libraries
when needed.

#### 2. Set paths needed for compile step

Here we use the module environment variable, `NVHPC_ROOT`, to set environment variables
that have paths needed for compilation and linking of code.

```bash
culibdir=$NVHPC_ROOT/cuda/lib64
cuincdir=$NVHPC_ROOT/cuda/include
```

#### 3. Create a C program for that excutes some simple multi-node, multi-GPU test code.

Here we create a file holding C code that uses MPI to send information between two GPUs 
running in different processes.

```bash
cat > test.c <<'EOFA'
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <cuda_runtime.h>
int main(int argc, char *argv[])
{
  int myrank, mpi_nranks; 
  int LBUF=1000000;
  float *sBuf_h, *rBuf_h;
  float *sBuf_d, *rBuf_d;
  int bSize;
  int i;

  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);                  // my MPI rank
  MPI_Comm_size(MPI_COMM_WORLD, &mpi_nranks);

  if ( mpi_nranks != 2 ) { printf("Program requires exactly 2 ranks\n");exit(-1); }

  int deviceCount;
  cudaGetDeviceCount(&deviceCount);               // How many GPUs?
  printf("Number of GPUs found = %d\n",deviceCount);
  int device_id = myrank % deviceCount;
  cudaSetDevice(device_id);                       // Map MPI-process to a GPU
  printf("Assigned GPU %d to MPI rank %d of %d.\n",device_id, myrank, mpi_nranks);

  // Allocate buffers on each host and device
  bSize = sizeof(float)*LBUF;
  sBuf_h = malloc(bSize);
  rBuf_h = malloc(bSize);
  for (i=0;i<LBUF;++i){
    sBuf_h[i]=(float)myrank;
    rBuf_h[i]=-1.;
  }
  if ( myrank == 0 ) {
   printf("rBuf_h[0] = %f\n",rBuf_h[0]);
  }

  cudaMalloc((void **)&sBuf_d,bSize);
  cudaMalloc((void **)&rBuf_d,bSize);

  cudaMemcpy(sBuf_d,sBuf_h,bSize,cudaMemcpyHostToDevice);

  if ( myrank == 0 ) {
   MPI_Recv(rBuf_d,LBUF,MPI_REAL,1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
  } 
  else if ( myrank == 1 ) {
   MPI_Send(sBuf_d,LBUF,MPI_REAL,0,0,MPI_COMM_WORLD);
  }
  else
  {
   printf("Unexpected myrank value %d\n",myrank);
   exit(-1);
  }

  cudaMemcpy(rBuf_h,rBuf_d,bSize,cudaMemcpyDeviceToHost);
  if ( myrank == 0 ) {
   printf("rBuf_h[0] = %f\n",rBuf_h[0]);
  }

  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Finalize();
}
EOFA
```

#### 4. Compile program

Here we use nvhpc MPI wrapper to compile. The two environment variables we set earlier ( `cuincdir` and `culibdir` ) are used to
let the compile step know where to find the relevant CUDA header and library files.


