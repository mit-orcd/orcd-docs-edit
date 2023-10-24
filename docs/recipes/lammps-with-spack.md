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
LAMMPS is a fully open-source molecular dynamics simulator. 
Its name is an acronym from [Large-scale Atomic/Molecular Massively Parallel Simulator](https://www.lammps.org).
It is widely used in materials research. LAMMPS is actively developed
[here](https://github.com/lammps) by a team of collaborators led by researchers from Sandia National Laboratory and 
Temple University. LAMMPS has many different compilation options that can be used to activate different technical and scientific features.

## Compiling and running a custom LAMMPS using Spack

In this recipe we look at setting up a custom configuration of LAMMPS using the [Spack](https://github.com/spack/spack) system. The recipe shows
how to compile LAMMPS in a way that uses an existing Spack install of core tools like MPI and GPU CUDA libraries and tools. The recipe
The detailed steps, that can be executed in an interactive Slurm session, are explained 
below. 

!!! note "Prerequisites"

    This example assumes you have access to a Slurm partition and are working with a Rocky Linux environment.

#### 1. Configure an instance of Spack in a directory under your account

Spack is a tool for compiling programs in a uniform away. It is designed for use by regular accounts on a computer. It does not need any administrative privileges.
Here it will be used to compile the LAMMPS software. 

A first step to using Spack is to download the software from its Github repository using the following command.

```bash
git clone https://github.com/spack/spack.git
```

Next we configure Spack, setting the it ot use standard tools that have already been built from a pre-exisiting location.

??? note
    The compilation example shows using Spack in a way that uses pre-existing _upstream_ Spack built software 
    from another location. This can be useful on a cluster computer where a central team may have already installed and configured some standard foundation software tools, 
    such as a compiler and high-performance tools for using GPUs and/or for parallel communication. Configuring these foundation software tools can involve seaprate
    testing and performance settings, so using a pre-installed foundation is generally useful. To make a Spack _upstream_ work reliably we need to use the same tag of 
    Spack as used in the upstream and provide a path name to the upstream isntallation.

To configure Spack use the following sequence of commands.

```bash
# Switch to build location
mkdir -p /nobackup1/users/${USER}/lammps-testing
cd /nobackup1/users/${USER}/lammps-testing

# Set any .spack files to be local to this test
export SPACK_USER_CONFIG_PATH=`pwd`/user_config

# Download spack and set version to match upstream Spack
git clone https://github.com/spack/spack.git
(
 cd spack
 git checkout -b v0.19.1 v0.19.1
)

# Set upstream and cp reference config files for upstream
mkdir -p `pwd`/user_config
cp /software/spack/etc/spack/*yaml user_config
cat  > user_config/upstreams.yaml << EOF
upstreams:
  orcd-rcf-2023:
   install_tree: /software/spack-20230328/opt/spack
EOF

source spack/share/spack/setup-env.sh
```
