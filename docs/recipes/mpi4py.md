---
tags:
 - MPI
 - Python
 - Howto Recipes
---

# MPI for Python

MPI for Python (`mpi4py`) provides Python bindings for the Message Passing Interface (MPI) standard, allowing Python applications to exploit multiple processors on workstations, clusters and supercomputers.

You can learn about `mpi4py` here: [https://mpi4py.readthedocs.io/en/stable/](https://mpi4py.readthedocs.io/en/stable/).

## Installation 

The `mpi4py` package is installed in the `miniforge` modules. If you are using your own conda, mamba, or virtual environment, you can install `mpi4py` in that environment.

## Example codes

Prepare your Python codes. 

**Example 1:** The following code is for sending and receiving a dictionary. Save it in a file named `p2p-send-recv.py`:

```python title="p2p-send-recv.py"
--8<-- "https://github.com/mit-orcd/orcd-examples/raw/main/mpi4py/p2p-send-recv.py"
``` 

**Example 2:** The following code is for sending and receiving an array. Save it in a file named `p2p-array.py`:

```python title="p2p-array.py"
--8<-- "https://github.com/mit-orcd/orcd-examples/raw/main/mpi4py/p2p-array.py"
```

## Submitting jobs

Prepare a job script. The following is a job script for running `mpi4py` codes on 8 CPU cores of one node. Save it in a file named `p2p-job.sh`:

```bash title="p2p-job.sh"
--8<-- "https://github.com/mit-orcd/orcd-examples/raw/main/mpi4py/p2p-job-engaging.sh"
```

Finally, submit the job:

```
--8<-- "https://github.com/mit-orcd/orcd-examples/raw/main/mpi4py/p2p-job-submit.sh"
```
