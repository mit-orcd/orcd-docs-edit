---
tags:
 - Julia
 - Howto Recipes
---

# Julia

## Installing alternate Julia versions

Sometimes, you may need to use a specific version of Julia in order for your program to work properly. To see if the cluster you're using contains the module you're need, enter `module avail` in the command line. To load this module, enter `module load julia/X.X.X`.

If the version of Julia you need is not available, you can download it. A complete list of previous Julia versions can be found [here](https://julialang.org/downloads/oldreleases/). From here, you should copy the link to the tar.gz file that corresponds to the version you need. Be sure to select the version for a Linux operating system and x86_64 architecture (??).


Download the .tar file:
```
wget [link to file]
```

Extract the .tar file:
```
tar -xvzf [file name]
```

Add the downloaded version to your path:
```
export PATH="~/path/to/your/julia/directory/bin:$PATH"
```


For example, the following lines are for Julia 1.9.0:
```
wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz
tar -xvzf julia-1.9.0-linux-x86_64.tar.gz
export PATH="~/julia-1.9.0/bin:$PATH"
```