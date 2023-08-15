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

## Usage

The NVHPC environment is installed as a module and can be made visible in a session using the command

```bash
module load nvhpc/2023_233/nvhpc/23.3
```
