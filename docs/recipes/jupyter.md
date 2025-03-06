---
tags:
 - Jupyter
 - Best Practices
---

# Jupyter Notebooks

Jupyter notebooks provide a way to run code in an interactive environment. While
most prominently used for [Python](../software/python.md), Jupyter supports a range of languages, such
as [Julia](../software/julia.md), [R](../software/R.md), and Java.

## Choosing an Approach

There are multiple ways to run Jupyter notebooks on the computing clusters
available through ORCD. The route you choose depends on your needs and level of
familiarity with high performance computing environments.

### Web Portal

The most straightforward way to run a Jupyter notebook on one of our computing
clusters is to use the cluster's web portal:

=== "Engaging"

    [https://engaging-ood.mit.edu/](https://engaging-ood.mit.edu/)

    Select "Interactive Apps" --> "Jupyter Notebook"

    Follow the on-screen instructions to start a session. You are able to use
    custom Conda environments provided they have `jupyterlab` installed.

    If you'd like to run [Julia](#julia), enter the name of the Julia module you're using
    (e.g., `julia/1.8.5`). Note that you need to have `IJulia` installed in your
    environment for this version of Julia.

    If you'd like to run [R](#r), enter the name of your custom Conda environment that
    has R installed.

    !!! note
        The Engaging web portal is currently running on CentOS 7, so it has a
        different set of modules from the Rocky 8 nodes. To check which modules
        are available on CentOS 7 nodes, [SSH to a CentOS 7 node](../accessing-orcd/ssh-login.md) and type `module avail`.

=== "Satori"

    [https://satori-portal.mit.edu/](https://satori-portal.mit.edu/)

=== "SuperCloud"

    [https://txe1-portal.mit.edu/](https://txe1-portal.mit.edu/)


### VS Code

Please follow [these instructions](./vscode.md) to run VS Code on a compute node.

### Port Forwarding

## Language-Specific Instructions

### Python

### Julia

You will need to add the `IJulia` package to your
environment for Jupyter to recognize the Julia kernel. You can do so from
the command line:

```bash title="Bash"
module load julia/1.8.5
julia
```
```julia title="Julia"
using Pkg
Pkg.add("IJulia")
Pkg.build("IJulia")
```

### R

<!-- Create a conda environment with R (link to R doc)-->

## FAQs

**How do I run a Jupyter notebook with a GPU?**

**My kernel is not recognized. What do I do?**

On VS Code, you may need to specify the path to the Conda installation we're
using.

To see the kernels that Jupyter recognizes, activate a Conda environment with
`jupyterlab` installed and run `jupyter kernelspec list`.
