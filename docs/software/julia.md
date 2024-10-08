---
tags:
 - Software
 - Julia
---

# Julia

## Installing Alternate Julia Versions

There are a number of versions of Julia that are currently available on our clusters (see [here](https://orcd-docs.mit.edu/software/modules/) for information on using different modules). However, sometimes, you may need a specific version of Julia that is not provided. If this happens, you can download it. 

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