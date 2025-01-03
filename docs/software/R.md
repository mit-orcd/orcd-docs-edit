<!--
To do:
- Use tidyverse only as an example
- Look into running R on Jupyter notebooks on SuperCloud
- Look into changing kernel to R in engaging Jupyter notebook
-->

---
tags:
 - Software
 - R
---

# R

## R with Conda

Conda is a package manager commonly used for Python, but is compatible with R and can be very useful for installing packages. This can be helpful when the packages you need have specific dependency requirements. Because of these benefits, **Conda is our recommended process for using R on the cluster.**

When you create a Conda environment, you can specify exactly the packages you need. First, you'll need to load a pre-installed Conda module. There are multiple available, but we recommend Miniforge:

=== "Engaging"

    ```bash
    module load miniforge/24.3.0-0
    ```

=== "Satori"

    ```bash
    module load anaconda3/2020.02-2ks5tch
    ```

=== "SuperCloud"

    ```bash
    module load anaconda/2023b
    ```

Now, you should be able to run `conda` commands. To search for specific R packages (beginning with "r-"), you can use `conda search`. For example, the following looks for all versions of Tidyverse available through Conda:

```bash
conda search r-tidyverse
```

There are two ways to add packages to your Conda environment. The first is to create a blank Conda environment and install packages individually, for example:

```bash
conda create -n my_R_env
conda activate my_R_env
conda install r-tidyverse
```

However, we recommend naming the packages you will need when you create the environment in the first place, as this will better handle dependencies. You can do this as such:

```bash
conda create -n my_R_env r-tidyverse
```

You can also specify specific versions of packages that you'd like to install:

```bash
conda install r-tidyverse=2.0.0
```

See [the section on Conda environments in the Python software document](python.md#conda-environments) for more information.

## Pre-Installed R Modules

There are currently a few different versions of R installed on our systems. You can find these versions by running `module avail`. To use an R interactive environment, first load an R module, then enter `R`.

=== "Engaging"

    On Rocky8 nodes (eofe4 and eofe10):

    ```bash
    module load r/4.2.2-x86_64
    R
    ```

    On Centos7 nodes (eofe7, eofe8, and eofe9):

    ```bash
    module load R/4.2.2
    R
    ```

=== "Satori"

    ```bash
    module load r/4.0.3-ue52ngj
    R
    ```

### Installing Packages

The pre-installed R modules come with a limited number of packages, but it is possible to install more. This can be acheived using the standard R command `install.packages("packageName")`.

R will first try to install this package system-wide but will be blocked to avoid editing the module for the entire cluster. You will be asked if you want to use a personal library instead. Type "yes" and press enter. This creates a folder in your home directory that contains the packages for each version of R you use. You can check this directory by running `.libPaths()` from the R CLI.

## RStudio

Currently, the only cluster that RStudio is available on is Engaging. This is accessible through [Engaging OnDemand](https://engaging-ood.mit.edu) > Interactive Apps > RStudio Server. From there, select the specifications you need, including runtime, memory, and R version. Currently, OnDemand does not support local installations of R or versions of R installed through Conda.

You can install packages using the `install.packages()` command. As with running R from the command line via SSH, the new packages should automatically be installed to your home directory.

## Jupyter

Similar to RStudio, Jupyter notebooks offer a handy cell-based interface to run R code. You can run Jupyter notebooks through the web portals of *Engaging and SuperCloud*.

=== "Engaging"

    Jupyter notebooks are available through [Engaging OnDemand](https://engaging-ood.mit.edu) > Interactive Apps > Jupyter Notebook. To run R, you must create a Conda environment with both R and jupyterlab installed (see [R with Conda](#r-with-conda)). When starting up the notebook, enter the name of your custom Conda environment. Once you launch the session and open your notebook, you may need to change your kernel to R. Your current kernel is shown in the top right, and likely defaults to "Python 3 (ipykernel)". Click this to change it to R.

=== "SuperCloud"

    Click [here](https://txe1-portal.mit.edu/jupyter/jupyter_notebook.php) to open a Jupyter notebook on the SuperCloud web portal.

    On SuperCloud, the version of R that is available is from the pre-installed R environment on Anaconda. As a result, you cannot install additional pacakges. Unfortunately, it is not possible to connect your own Conda environment to Jupyter on this cluster. You can find more information about running Jupyter notebooks on SuperCloud [here](https://mit-supercloud.github.io/supercloud-docs/jupyter-notebooks/).

## Installing Other R Versions

If you need a specific version of R, the easiest way to do this is through Conda. You can specify your desired R version while creating a Conda environment by setting the `r-base` argument to version that you need. For example, for installing R version 4.1.2:

```bash
conda create -n my_R_env r-base=4.1.2
conda activate my_R_env
```

Once your environment is created and activated, entering `which R` should direct you to the version of R within your Conda environment.

## FAQs

**I am trying to use a specific R installation, but it is not being recognized. What should I do?**

Sometimes, the way your environment is set up may cause the system to default to certain R installations that you don't want. The culprit can often be found in your `.bashrc` and/or `.bash_profile` file. Usually, running `module purge` from the command line before loading the version of R you want solves the problem.

**How do I change the path where my libraries are installed?**

Before starting R, you can set the `R_LIBS_USER` environment variable from your Bash terminal:

```bash
export R_LIBS_USER=/path/to/R/library/directory
```

You can also set the path from within R:

```R
.libPaths("/path/to/R/library/directory")
```

Both of these commands essentially prepend your custom path to the library path that already existed.

## Further Resources

[Engaging: R Packages](https://engaging-web.mit.edu/eofe-wiki/software/r_packages/)

[Satori: R on Satori](https://mit-satori.github.io/satori-R.html)

[SuperCloud: Software and Package Management - R Libraries](https://mit-supercloud.github.io/supercloud-docs/software-packages/#r-libraries)