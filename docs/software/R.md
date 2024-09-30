---
tags:
 - Software
 - R
---

NOTES: 
- All of this is for Engaging; check compatibility with other clusters

# R

## Pre-Installed R Modules

There are currently a few different versions of R installed on our systems. You can find these versions by running `module avail`. To use an R interactive environment, first load an R module, then enter `R`. For example, on Engaging Rocky8:

```bash
module load r/4.2.2-x86_64
R
```

### Installing Packages

The pre-installed R modules come with a limited number of packages, but it is possible to install more. This can be acheived using the standard R command `install.packages("packageName")`.

Because these installations are not system-wide, a directory will be created in your home directory that contains all installed packages for the version of R you are using. You can check this directory by running `.libPaths()` from the R CLI. You can also set this path manually by setting the `R_LIBS_USER` environment variable from your Bash terminal:

```bash
export R_LIBS_USER=/path/to/R/library/directory/
```

## R with Conda

Conda is a package manager commonly used for Python, but is compatible with R and can be very useful for installing packages. This can be helpful when the packages you need have specific dependency requirements.

When you create a Conda environment, you can specify exactly the packages you need. First, you'll need to load a pre-installed Conda module. There are multiple available, but we recommend the Miniforge modules:

```bash
module load miniforge/24.3.0-0
```

Now, you should be able to run `conda` commands. To search for specific R packages (beginning with "r-"), you can use `conda search`. For example, the following looks for all versions of Tidyverse available through Conda:

```bash
conda search r-tidyverse
```

There are two ways to add packages to your conda environment. The first is to create a blank conda environment and install packages individually, for example:

```bash
conda create my_R_env
conda activate my_R_env
conda install r-tidyverse
```

However, we recommend naming the packages you will need when you create the environment in the first place, as this will better handle dependencies. You can do this as such:

```bash
conda create my_R_env r-tidyverse
```

You can also specify specific versions of packages that you'd like to install:

```bash
conda install r-tidyverse=2.0.0
```

## OnDemand RStudio

You can use RStudio on a cluster through OnDemand. Package installation behaves similarly as if you were running a version of R via the command line. Currently, OnDemand is only supported on the Engaging Centos7 nodes.

## Installing Other R Versions

If you need a specific version of R, the easiest way to do this is through Conda. You can specify your desired R version while creating a Conda environment by setting the `r-base` argument to version that you need. For example, for installing R version 4.1.2:

```bash
conda create -n R_env r-base=4.1.2
conda activate R_env
```

Once your environment is created and activated, entering `which R` should direct you to the version of R within your Conda environment.
