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
The steps are as follows:

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
