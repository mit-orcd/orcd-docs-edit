---
tags:
 - Jupyter
 - Best Practices
---

# Jupyter Notebooks

Jupyter notebooks provide a way to run code in an interactive environment. While
most prominently used for [Python](../software/python.md), Jupyter supports a
range of languages, such as [Julia](../software/julia.md) and
[R](../software/R.md).

## Choosing an Approach

There are multiple ways to run Jupyter notebooks on the computing clusters
available through ORCD. The route you choose depends on your needs and level of
familiarity with high performance computing environments.

### Web Portal

The most straightforward way to run a Jupyter notebook on one of our computing
clusters is to use the cluster's web portal.

- Link to web portal:
[https://orcd-ood.mit.edu/](https://orcd-ood.mit.edu/)

- Select "Interactive Apps" --> "Jupyter Notebook"

- Follow the on-screen instructions to start a session. You are able to use
a custom Conda environment provided it has `jupyterlab` installed.

- If you'd like to run [Julia](#julia), enter the name of the Julia module
you're using (e.g., `julia/1.8.5`). Note that you need to have `IJulia`
installed in your environment for this version of Julia.

- If you'd like to run [R](#r), enter the name of your custom Conda
environment that has `r-irkernel` installed.

- When the session is ready, click "Connect to Jupyter." From here you can
create a Jupyter notebook and select the language you would like to use.

### VS Code

First, follow [these instructions](./vscode.md) to set up VS Code to run on a
compute node.

Open a Jupyter notebook and click the top right button to select a kernel. You
can select "Python Environments" for any Conda environments or "Jupyter Kernel"
to find Julia or R environments. If you have installed R with Conda, you can
find your Conda environment under "Jupyter Kernel." `jupyterlab` must be
installed to your Conda environment.

## Language-Specific Instructions

### Julia

You will need to add the `IJulia` package to your environment for Jupyter to
recognize the Julia kernel. You can do so from the command line:

```bash title="Bash"
module load julia
julia
```
```julia title="Julia"
using Pkg
Pkg.add("IJulia")
Pkg.build("IJulia")
```

Unlike R, Julia environments are separate from Conda. However, if the `IJulia`
package is installed, then the Julia kernel should be visible regardless of the
Conda environment from which you run your Jupyter notebook.

See our [Julia documentation](../software/julia.md) for more information.

### R

To run R in a Jupyter notebook, you need to create a Conda environment with
both `r-irkernel` and `jupyterlab` installed:

```bash
module load miniforge
conda create -n r_jupyter_env jupyterlab r-irkernel
conda activate r_jupyter_env
```

Most R packages are available through Conda, so feel free to install other
packages you need to this environment.

See our [R documentation](../software/R.md) for more information.

### Python

To run Python Jupyter notebooks, install `jupyterlab` to whatever Conda
environment that contains the packages you need.

See our [Python documentation](../software/python.md) for more information.

## FAQs

**How do I run a Jupyter notebook with a GPU?**

The cluster web portals offer an option to allocate a GPU to your Jupyter
session. If you would like to use a different partition, however, then follow
the instructions for [VS Code](#vs-code) or [port forwarding](#port-forwarding)
and request a GPU in your Slurm job. See [our documentation on requesting
resources](../running-jobs/requesting-resources.md#gpus) for more information.

**Jupyter does not recognize the kernel for my environment. What do I do?**

First, make sure you have `r-irkernel` installed if you're using R, `IJulia`
installed (and built) if you're using Julia, and `jupyterlab` installed to
your Conda environment.

On VS Code, you may need to specify the path to the `conda` binary of the Conda
installation you're using. This can be done by editing the "Python: Conda Path"
setting. For example, if you're using the `miniforge/24.3.0-0` module on
Engaging, the path would be:

```
/orcd/software/core/001/pkg/miniforge/24.3.0-0/condabin/conda
```

To see all kernels that Jupyter recognizes, activate a Conda environment with
`jupyterlab` installed and run `jupyter kernelspec list`.

**I tried to install `jupyterlab` to my Conda environment, but the installation
failed. How can I run a Jupyter notebook with the dependencies I need?**

It's best to install the packages you need when you create a Conda environment
rather than one-by-one after the environemnt has been created. This will make
Conda more likely to solve your environment succesfully. For example:

```bash
conda create -n jupyter_env jupyterlab pandas pytorch
```

See [Conda Environments](../software/python.md#conda-environments) for
more information.
