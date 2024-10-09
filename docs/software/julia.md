---
tags:
 - Software
 - Julia
---

# Julia

## Juliaup

Juliaup provides a convenient way to manage different versions of Julia and different package installations. It can be installed by running the following command:

```bash
curl -fsSL https://install.julialang.org | sh
```

This creates a .juliaup folder within your home directory that will contain all installations of Julia and their associated packages that are managed by Juliaup. This also edits your `.bashrc` and `.bash_profile` files, which run whenever you login to the cluster. This automatically adds Juliaup to your `$PATH` environment variable, meaning that this version of Julia becomes the default. To undo this, you can comment out the juliaup section of your `.bashrc` file and restart your session or edit the `$PATH` environment variable manually.

Click [here](https://github.com/JuliaLang/juliaup) for more information on using Juliaup.

### Installing Different Julia Versions

```bash
# Install Julia 1.9.0:
juliaup add 1.9.0
# Use Julia 1.9.0:
julia +1.9.0
```

## Conda

## Using Different Julia Versions

### Manual Installation

There are a number of versions of Julia that are currently available on our clusters (see [here](modules.md) for information on using different modules). However, sometimes, you may need a specific version of Julia that is not provided. If this happens, you can download it. 

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


