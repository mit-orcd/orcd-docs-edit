---
tags:
 - OpenMind
 - MPI
 - Python
 - Howto Recipes
---

# Installing and Using MPI for Python

MPI for Python (`mpi4py`) provides Python bindings for the Message Passing Interface (MPI) standard, allowing Python applications to exploit multiple processors on workstations, clusters and supercomputers.

You can learn about `mpi4py` here: [https://mpi4py.readthedocs.io/en/stable/](https://mpi4py.readthedocs.io/en/stable/).

## Mpi4py on OpenMind

### Install 

If you use an Anaconda module, no installation is required.

If you want to use Anaconda in your directory, refer to section 3 on [this page](https://github.mit.edu/MGHPCC/OpenMind/wiki/How-to-make-Python-ready-for-use%3F) to set it up, then intall `mpi4py`, 
```
conda install -c conda-forge mpi4py
```

### Run Mpi4py

Prepare your Python codes. Example 1: The following is a code for sending and receiving a dictionary. Save it in a file named `p2p-send-recv.py`.
```
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

if rank == 0:
    data = {'a': 7, 'b': 3.14}
    comm.send(data, dest=1, tag=11)
    print(rank,data)
elif rank == 1:
    data = comm.recv(source=0, tag=11)
    print(rank,data)
``` 

Example 2: The following is a code for sending and receiving an array. Save it in a file named `p2p-array.py`.
```
from mpi4py import MPI
import numpy

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

# passing MPI datatypes explicitly
if rank == 0:
    data = numpy.arange(1000, dtype='i')
    comm.Send([data, MPI.INT], dest=1, tag=77)
    print(rank,data)
elif rank == 1:
    data = numpy.empty(1000, dtype='i')
    comm.Recv([data, MPI.INT], source=0, tag=77)
    print(rank,data)

# automatic MPI datatype discovery
if rank == 0:
    data = numpy.arange(100, dtype=numpy.float64)
    comm.Send(data, dest=1, tag=13)
    print(rank,data)
elif rank == 1:
    data = numpy.empty(100, dtype=numpy.float64)
    comm.Recv(data, source=0, tag=13)
    print(rank,data)
```

Prepare a job script. The following is a job script for running `mpi4py` codes on 8 CPU cores of one node. Save it in a file named `p2p-job.sh`.
```
#!/bin/bash -l
#SBATCH -N 1
#SBATCH -n 8

module load openmpi/gcc/64/1.8.1
module load openmind/anaconda/3-2022.05

mpirun -np $SLURM_NTASKS python p2p-send-recv.py
mpirun -np $SLURM_NTASKS python p2p-array.py
```

> An Openmpi module is needed. If you use Anaconda in your directory, do not load the Anaconda module. 

Finally submit the job,
```
sbatch p2p-job.sh
```

