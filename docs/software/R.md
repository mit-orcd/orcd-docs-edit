---
tags:
 - Software
 - R
---

# R

R is a powerful programming language widely used for statistical computing and graphics. It provides a variety of statistical techniques and graphical tools, making it a useful tool for data analysis and visualization.

## R Modules

There are currently a few different versions of R installed on Engaging. You can find these versions by running `module avail R`. Loading this module will allow you to run two commands from the command line: `R` and `Rscript`. The `R` command will start an interactive R session, while `Rscript` allows you to run R scripts from the command line.

### Installing Packages

Our latest versions (`R/4.4.3` and `R/4.5.2`) are [containerized](../glossary.md#container) and come with a limited number of pre-installed packages, but the container images contain the system libraries needed to install many additional packages. These R environments use the same containers as [RStudio](#rstudio) on the OnDemand web portal, so you can be sure that the packages you install in your R environment will also be available in RStudio, and vice versa.

Installing additional packages using one of these modules on Engaging is the same process as installing packages on your local machine. You can do so by starting up R from the command line and using the `install.packages()` function, for example:

```bash
module load R/4.4.3
R
```

Then, from the R command line:

```R
install.packages("tidyverse")
```

This will take a bit of time, as R will download dependencies and compile the package. You may be asked to select a CRAN mirror, which is a server that hosts R packages. You can select any mirror, but it is recommended to choose one that is geographically close to you for faster downloads.

Once the package has been installed, it will get saved to your home directory in `~/R/x86_64-pc-linux-gnu-library/4.4` (or `4.5` if you are using R/4.5.2). You can check this directory by running `.libPaths()` from the R CLI.

## R with Conda

Conda is a package manager commonly used for Python, but is compatible with R and can be very useful for installing packages. This can be helpful when the packages you need have specific dependency requirements. You can find more information on Conda in the [Python software section](python.md#conda-environments).

When you create a Conda environment, you can specify exactly the packages you need. Conda is available through the Miniforge module:

```bash
module load miniforge
```

Now, you should be able to run `conda` commands, such as creating and activating an environment:

```bash
conda create -n my_R_environment
conda activate my_R_environment
```

To search for specific R packages (beginning with "r-"), you can use `conda search`. For example, the following looks for all versions of Tidyverse available through Conda:

```bash
conda search r-tidyverse
```

The base R installation through Conda is called `r-base`. This will automatically be downloaded and installed when you install any R package to your environment. To install packages, use `conda install`:

```bash
conda install r-tidyverse
```

By default, the latest compatible versions of `r-base` and other R packages are automatically installed. If you prefer different versions of R (`r-base`) or you need a specific version of a package, you can specify in your `install` command:

```bash
conda install r-base=4.1.2
conda install r-tidyverse=2.0.0
```

!!! note
    It's much more efficient to specify all the packages you need when you first create your environment rather than installing them one by one. This way, the environment only needs to be solved once, and Conda ensures that packages are compatible with each other. You can do this by naming the packages in the `create` command: `conda create -n my_R_env r-tidyverse r-pillar`

Once your environment is created and activated, entering `which R` should direct you to the version of R within your Conda environment.

## RStudio

You can use RStudio on the Engaging cluster via [OnDemand](https://orcd-ood.mit.edu) > Interactive Apps > RStudio Server. From there, select the specifications you need, including runtime, memory, and R version.

As mentioned above, the RStudio environment uses the same containerized R installations as the command line modules. This means that any packages you install in RStudio will also be available when you use R from the command line, and vice versa. Packages you install in RStudio will be saved to your home directory in `~/R/x86_64-pc-linux-gnu-library/<version>`.

## FAQs

**How do I change the path where my libraries are installed?**

Before starting R, you can set the `R_LIBS_USER` environment variable from your Bash terminal:

```bash
export R_LIBS_USER=/path/to/R/library/directory
```

You can also set the path from within R:

```R
.libPaths("/path/to/R/library/directory")
```

Both of these commands prepend your custom path to the library path that already existed.
