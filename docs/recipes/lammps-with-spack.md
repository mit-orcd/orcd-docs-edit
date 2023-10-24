---
tags:
 - Engaging
 - Howto Recipes
 - spack
 - LAMMPS
 - Rocky Linux
---

# Example of building custom LAMMPS configuration using spack

## About LAMMPS
LAMMPS is a fully open-source molecular dynamics simulator. Its name is an acronym from Large-scale Atomic/Molecular Massively Parallel Simulator.
It is widely used in materials research. LAMMPS is actively developed
[here](https://github.com/lammps) by a team of collaborators led by researchers from Sandia National Laboratory and 
Temple University.  
LAMMPS has many different compilation options that can be used to activate different technical and scientific features.

## Compiling and running a custom LAMMPS using Spack

In this recipe we look at setting up a custom configuration of LAMMPS using the [Spack](https://github.com/spack/spack) system. The recipe shows
how to compile LAMMPS in a way that uses an existing Spack install of core tools like MPI and GPU CUDA libraries and tools. The recipe
The detailed steps, that can be executed in an interactive Slurm session, are explained 
below. 

!!! note "Prerequisites"

    This example assumes you have access to a Slurm partition and are working with a Rocky Linux environment.

#### 1. Configure an instance of Spack in a directory under your account

Spack is a tool for compiling programs in a uniform away. It is designed for use by regular accounts on a computer. It does not need any administrative privileges.
Here it will be used to compile the LAMMPS software. The compilation example shows using Spack in a way that uses pre-existing Spack built software 
from another location. This can be useful on a cluster computer where a central team may have already installed and configured some standard foundation software tools, 
such as a compiler and high-performance tools for using GPUs and/or for parallel communication. Configuring these foundation software tools can involve seaprate
testing and performance settings, so using a pre-installed foundation is generally useful.

A first step to using Spack is to download the software from its Github repository using the following command.

```bash
git clone https://github.com/spack/spack.git
```
