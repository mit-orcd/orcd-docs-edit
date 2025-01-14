---
tags:
 - Software
 - Julia
---

# Julia

Julia is a high-level, high-performance programming language designed for technical and numerical computing, known for its speed and ease of use. Because of its popularity, we have pre-installed versions of Julia on each of our clusters. You can begin using Julia right away by running `module load julia`, or by specifying the module specifically:

=== "Engaging"

    On Rocky8 nodes:

    ```bash
    module load julia/1.10.1
    julia
    ```

    On Centos7 nodes:

    ```bash
    module load julia/1.8.5
    julia
    ```
    
=== "Satori"

    ```bash
    module load julia/1.5.3-rls2opu
    ```

=== "SuperCloud"

    ```bash
    module load julia/1.10.1
    ```

## Installing Packages

When you install packages in Julia, a .julia folder automatically gets created in your home directory that holds all packages installations. You can change this location by setting the `$JULIA_DEPOT_PATH` environment variable from the command line before you start Julia. For example:

```bash
export JULIA_DEPOT_PATH=/home/$USER/orcd/r8/pool
```

## Juliaup

Juliaup provides a convenient way to manage different versions of Julia and different package installations. It can be installed by running the following command:

```bash
curl -fsSL https://install.julialang.org | sh
```

You will be asked if you want to proceed with default settings or to customize your installation. We recommend customizing your installation. The default settings are as follows:

1. Save the .juliaup folder to your home directory. This folder contains all installations of Julia and their associated packages that are managed by Juliaup.

    - On Satori, home directories are limited to 20 GB, so you may want to change this location to `/nobackup/users/$USER`.

2. Edit your `.bashrc` and `.bash_profile` files to automatically add the Juliaup-managed version of Julia to your `$PATH` environment variable.

    - We generally discourage editing your `.bashrc` file because it can cause issues when trying to use other software. For example, if you want to use a pre-installed Julia module, you would have to manually remove Juliaup from your `$PATH` any time you connect to the cluster.

    - To add Juliaup to your `$PATH` manually, run:
    ```bash
    export PATH=/path/to/.juliaup/bin${PATH:+:${PATH}}
    ```

!!!Note
    Currently, Juliaup is not compatible with Satori or SuperCloud.

Click [here](https://github.com/JuliaLang/juliaup) for more information on installing and using Juliaup.

## Conda

*This route is not recommended. Currently looking into other ways of using Julia with Jupyter that do not go through Conda.*

## Using Different Julia Versions

### Juliaup Versions

If you're using [Juliaup](#juliaup), installing different versions of Julia is straightforward:

```bash
# Install Julia 1.9.0:
juliaup add 1.9.0
# Use Julia 1.9.0:
julia +1.9.0
```

Note that Juliaup installs versions and packages to your .julia folder.

### Manual Installation

If you are unable to use Juliaup and you need a version of Julia that is not pre-installed on the cluster, you can manually download it.

A complete list of previous Julia versions can be found [here](https://julialang.org/downloads/oldreleases/). From this site, copy the link to the tar.gz file that corresponds to the version you need. Be sure to select the version for a Linux operating system and x86_64 architecture.

Download the .tar file:
```bash
wget [link to file]
```

Extract the .tar file:
```bash
tar -xvzf [file name]
```

Add the downloaded version to your path:
```bash
export PATH="~/path/to/your/julia/directory/bin:$PATH"
```

The following example is for Julia 1.9.0:
```bash
wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz
tar -xvzf julia-1.9.0-linux-x86_64.tar.gz
export PATH="~/julia-1.9.0/bin:$PATH"
```

## Jupyter Notebooks

While Jupyter is heavily integrated with Python, it supports compatibility with
Julia. You can run Jupyter notebooks on the web portals of
[SuperCloud](https://txe1-portal.mit.edu/) and
[Engaging](https://engaging-ood.mit.edu/).

=== "Engaging"

    On the [Engaging web portal](https://engaging-ood.mit.edu/), you can specify
    one of the pre-installed Julia modules under the "Additional Modules"
    section. You can see which Julia modules are available by running `module
    av julia` from the command line.
    
    For Jupyter to recognize Julia, you need to have the `IJulia` package
    installed to your Julia environment. Note that the Julia environment you are
    using needs to match the version of Julia that you are loading as a module.

    If you would like to use a different version of Julia

=== "SuperCloud"
    
    To use a Jupyter notebook on the SuperCloud web portal, navigate to
    `/jupyter/` and launch a notebook. When the session is running, open the
    notebook and select a Julia kernel.

    !!!Note
        For more information on running Jupyter notebooks on SuperCloud, check
        the [SuperCloud documentation](https://mit-supercloud.github.io/supercloud-docs/jupyter-notebooks/).

### VS Code

For other clusters, we recommend using Jupyter notebooks through VS Code.

Please refer to the [VS Code page](../recipes/vscode.md) on our documentation for using VS Code on the cluster.

For VS code (including developer tools and Jupyter notebooks) to recognize your desired version of Julia, two things need to happen. First, you need to have the Julia extension installed. This can be done by clicking "extensions" on the left sidebar and then searching for the Julia extension. Second, Julia needs to be loaded in your `.bashrc` file that is located in your home directory. This allows the Julia extension to recognize the correct version of Julia. Add the following lines to your `.bashrc` file depending on how you are using Julia:

=== "Pre-Installed Module"

    ```bash
    module load julia
    ```

=== "Juliaup"

    ```bash
    # export PATH=/path/to/.juliaup/bin${PATH:+:${PATH}}
    export PATH="/path/to/.juliaup/bin:$PATH"
    ```

Now, once you connect VS Code to the cluster, you should see your desired version of Julia in the list of Jupyter kernels.

## FAQs

**I have loaded/installed a specific version of Julia, but it is not being recognized. What do I do?**

*Check your `$PATH` environment variable.*

<!--
TODO: Figure out how to run Julia on Jupyter
-->

