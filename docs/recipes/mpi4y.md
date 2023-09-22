---
tags:
 - OpenMind
 - Engaging
 - SuperCloud
 - Howto Recipes
---

# Installing and Using MPI for Python

MPI for Python (`mpi4py`) provides Python bindings for the Message Passing Interface (MPI) standard, allowing Python applications to exploit multiple processors on workstations, clusters and supercomputers.

You can learn about `mpi4py` here: [https://mpi4py.readthedocs.io/en/stable/](https://mpi4py.readthedocs.io/en/stable/).

## Mpi4py on OpenMind

### Install 

First, refer to [this page](https://github.mit.edu/MGHPCC/OpenMind/wiki/How-to-make-Python-ready-for-use%3F) to set up your python environement. 

Intall `openmpi` and `mpi4py`, 
```
conda install -c conda-forge openmpi
conda install -c conda-forge mpi4py
```

