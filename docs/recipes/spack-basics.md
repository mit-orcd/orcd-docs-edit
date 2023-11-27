---
tags:
 - Engaging
 - Howto Recipes
 - spack
 - Rocky Linux
---

# Example of setting up a Spack environment that inherits from the system setup

This example shows a basic example of using the Spack tool to create a custom software environment.
The example illustrates configuring Spack to reuse libraries and software that are part of the core Spack setup on a cluster. 


## About Spack

The tool [Spack](https://spack.readthedocs.io) is a system for self-service building of a large number of different scientific software applications
and libraries. Spack is an open source tool maintained in public repositories under the [Spack github organization](https://github.com/spack). 
Development of Spack is led by a team at the [Lawrence Livermore National Laboratory](https://computing.llnl.gov/projects/spack-hpc-package-manager).


## Setting up a Spack environment that inherits a system setup

The Spack tool has many options and can be used in a variety of ways. Here we show how to configure Spack to _inherit_ pre-built 
software from a core set of system supported tools that have also been built with Spack. This recipe can be used to self-build custom 
software that is not available, or that needs special configuration options. Using Spack does not require any privileged system access. 
The approach for using Spack shown here allows regular accounts to build custom software that builds on top of core system tools like 
compilers, commincations and I/O libraries that have been been built and optimized previously using Spack.

!!! note "Prerequisites"

    This example assumes you have access to a Slurm partition and are working with a Rocky Linux environment.
    The example also uses git command, so some familiarity with git is useful.

#### 1. Configure an instance of Spack in a working directory under your account

A first step to using Spack is to download the software from its Github repository into a working directory using the following command.

```bash
mkdir -p /nobackup1/users/${USER}/spack-testing
cd /nobackup1/users/${USER}/spack-testing
git clone https://github.com/spack/spack.git
```

in this example we use ` /nobackup1/users/${USER}/spack-testing` as our workig directory.

Next we configure Spack, setting the it to use standard tools that have already been built from a pre-exisiting location.

??? note
    The compilation example shows using Spack in a way that uses pre-existing _upstream_ Spack built software 
    from another location. This can be useful on a cluster computer where a central team may have already installed and configured some standard foundation software tools, 
    such as a compiler and high-performance tools for using GPUs and/or for parallel communication. Configuring these foundation software tools can involve seaprate
    testing and performance settings, so using a pre-installed foundation is generally useful. To make a Spack _upstream_ work reliably we need to use the same tag of 
    Spack as used in the upstream and provide a path name to the upstream isntallation.

To configure Spack to use the following sequence of commands.

```bash
# Switch to build location
cd /nobackup1/users/${USER}/spack-testing

# Set any .spack files to be local to this test
export SPACK_USER_CONFIG_PATH=`pwd`/user_config

# Set checked out version of downloaded Spack to match upstream Spack version
(
 cd spack
 git checkout -b v0.19.1 v0.19.1
)

# Copy reference config files for upstream and set upstream location
mkdir -p `pwd`/user_config
cp /software/spack/etc/spack/*yaml user_config
cat  > user_config/upstreams.yaml << EOF
upstreams:
  orcd-rcf-2023:
   install_tree: /software/spack-20230328/opt/spack
EOF

source spack/share/spack/setup-env.sh
```

Here the directory `/software/spack-20230328/opt/spack` holds a pre-built set of spack software. By convention this directory
is dated and software in that directory is unchanged once published.

#### 2. Test Spack settings

Once Spack has been installed and configured to use the _upstream_ the setup can be checked with some basic Spack commands.

