---
tags:
 - OpenMind
 - MPI
 - Python
 - Howto Recipes
---

# Installing and Using MPI for Python (Snippets)

MPI for Python (`mpi4py`) provides Python bindings for the Message Passing Interface (MPI) standard, allowing Python applications to exploit multiple processors on workstations, clusters and supercomputers.

You can learn about `mpi4py` here: [https://mpi4py.readthedocs.io/en/stable/](https://mpi4py.readthedocs.io/en/stable/).

## Mpi4py on OpenMind

### Install 

If you use an Anaconda module, no installation is required.

If you want to use Anaconda in your directory, refer to section 3 on [this page](https://github.mit.edu/MGHPCC/OpenMind/wiki/How-to-make-Python-ready-for-use%3F) to set it up, then install `mpi4py`, 
```
--8<-- "https://github.com/mit-orcd/orcd-docs-edit/raw/kn/snippets/docs/recipes/snippets-setup/mpi4py/mpi4py_setup.sh"
```

### Run Mpi4py

Prepare your Python codes. Example 1: The following is a code for sending and receiving a dictionary. Save it in a file named `p2p-send-recv.py`.
```python title="p2p-send-recv.py"
--8<-- "https://raw.githubusercontent.com/mit-orcd/orcd-examples/main/mpi4py/p2p-send-recv.py"
``` 

Example 2: The following is a code for sending and receiving an array. Save it in a file named `p2p-array.py`.
```python title="p2p-array.py"
--8<-- "https://raw.githubusercontent.com/mit-orcd/orcd-examples/main/mpi4py/p2p-array.py"
```

Prepare a job script. The following is a job script for running `mpi4py` codes on 8 CPU cores of one node. Save it in a file named `p2p-job.sh`.
```bash title="p2p-job.sh"
--8<-- "https://raw.githubusercontent.com/mit-orcd/orcd-examples/main/mpi4py/p2p-job.sh"
```
!!! note
    An OpenMPI module is needed. If you use Anaconda in your directory, do not load the Anaconda module. 

Finally submit the job,
```
--8<-- "https://github.com/mit-orcd/orcd-docs-edit/raw/kn/snippets/docs/recipes/snippets-setup/mpi4py/mpi4py_submit.sh"
```

