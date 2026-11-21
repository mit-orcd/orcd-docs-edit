---
tags:
 - Engaging
 - Howto Recipes
---

# Best Practices for Data Storages

Engaging provides several types of storage. Each type is designed for a specific purpose and I/O pattern. Choosing the right storage keeps your jobs running efficiently and prevents your jobs from slowing down other users' jobs.

This page has three parts. First, it describes the storage types on Engaging (home, data, scratch, compute, and archive storage) and the purpose of each type. Second, it explains the small-files problem: why a large number of small files slows down the filesystem, and how to avoid it. Third, it gives examples of HDF5 files, which store large datasets efficiently, and tar archives, which pack many files into one.

## Storage Types

To choose a storage type, first determine the I/O load of your job. The sections below use two levels of I/O load:

- **Heavy I/O**: reading or writing large volumes of data, or many files, repeatedly during a job. Examples: writing checkpoints frequently, many small writes, or many tasks accessing files at the same time.
- **Light I/O**: occasional reads and writes. Examples: loading input data once at the start of a job, or writing final results at the end.

### Home Directory

Path: `/home/<username>`

Your home directory is the place for documents, source code, software installations, and small test data. Its I/O performance is the same as compute storage. Do not store large datasets in your home directory; use data or compute storage instead.

### Data Storage

Paths: `~/orcd/pool` (per user) and `/orcd/data` (lab or department)

Data storage is designed for long-term storage of datasets, code outputs, and results. The per-user path and the lab or department path have the same performance.

Jobs with light I/O can run on data storage. Do not run heavy I/O jobs here, because they slow down both your job and other users' jobs. Run heavy I/O jobs on scratch or compute storage instead.

### Scratch Storage

Paths: `~/orcd/scratch` (per user) and `/orcd/scratch` (lab or department)

Scratch storage is designed for heavy I/O jobs and for temporary or intermediate files. The per-user path and the lab or department path have the same performance.

Scratch storage is not purged automatically. Delete files you no longer need when your job is done, so that space remains available for active work.

A typical workflow uses data storage and scratch storage together:

1. Copy input data from data storage to scratch storage.
2. Run the job on scratch storage.
3. Copy the results back to data storage.
4. Delete the files on scratch storage.

### Compute Storage

Path: `/orcd/compute` (lab or department)

Compute storage is designed for running heavy I/O jobs, and it can also be used for long-term storage. However, it costs much more than data storage. Keep only data that needs high I/O performance on compute storage, and keep other data on data storage.

### Archive Storage

Path: `/orcd/archive` (lab or department)

Archive storage is provided by the Northeast Storage Exchange (NESE). NESE is a storage system hosted on a Harvard cluster at the MGHPCC and mounted on Engaging. Although both clusters are in the same building, the network connection between them has low bandwidth, so reading and writing NESE from Engaging is slow.

For this reason, use archive storage only for long-term storage of data that is not actively used. Do not run jobs on archive storage; copy the data to scratch or compute storage before running jobs. Before copying data to archive storage, pack small files into large archive files (see [Archive Example](#archive-example)).

### Policies and Ownership

!!! note "Policies"

    Policies (backup, quota, purge, and purchase) are described on these pages and are not repeated here:

    * Home directory, per-user data storage, and per-user scratch storage: [General Use Filesystems](../filesystems-file-transfer/filesystems.md)
    * Lab or department data storage and compute storage: [Storage Services](../services/storage-services.md)

!!! note "Ownership"

    * The home directory, per-user data storage, and per-user scratch storage are provided to each user.
    * Lab or department data storage, scratch storage, compute storage, and archive storage are purchased by labs or departments and shared by their members.

### Summary

| Storage | Paths | Use for | Run jobs here? |
| ------- | ----- | ------- | -------------- |
| Home | `/home/<username>` | Documents, source code, software, small test data | Small tests only |
| Data | `~/orcd/pool`, `/orcd/data` | Long-term datasets and results | Light I/O only |
| Scratch | `~/orcd/scratch`, `/orcd/scratch` | Heavy I/O, temporary files | Yes; delete files when done |
| Compute | `/orcd/compute` | Heavy I/O, long-term storage (higher cost) | Yes |
| Archive | `/orcd/archive` | Long-term storage of inactive data | No; copy data out first |

## Small Files

### Why Small Files Are a Problem

Every file uses one inode, which stores the metadata of the file. File operations such as opening, closing, listing, or deleting files read or update this metadata, and the metadata server of the filesystem handles each of these operations. As a result, millions of small files overload the metadata server.

Common commands that perform metadata operations include:

- `ls`: reads the list of files in a directory.
- `ls -l`: also reads the metadata (size, owner, permissions, and timestamps) of every file in the list.
- `rm`: removes a file and frees its inode, one metadata operation for each file.

On a directory with millions of files, each of these commands can hang and add heavy load to the metadata server.

??? note "What is an inode?"
    An inode is a data structure that the filesystem uses to store information about a file, such as its size, owner, permissions, and location on disk. Each file or directory uses one inode, regardless of its size.

!!! warning "Too many small files slow down the filesystem"
    Creating or accessing very large numbers of small files substantially slows down the filesystem. This affects not only your jobs but also other users' jobs.

Each file also counts against the per-user file count (inode) quota. See [General Use Filesystems](../filesystems-file-transfer/filesystems.md) for the quota.

### Tips to Reduce the Number of Files

To keep the number of files low, follow these tips:

- Combine many small files into a few large files, such as HDF5 files or tar archives. See the [HDF5 Example](#hdf5-example) and [Archive Example](#archive-example) below.
- Do not write one output file per step or per sample.
- Check the number of files in a directory:
  ```bash
  find <dir> -type f | wc -l
  ```

## Examples

### HDF5 Example

HDF5 is a file format for large numerical datasets. One file holds many arrays (such as NumPy arrays) in a hierarchy, you can read part of an array without loading the whole file, and many MPI processes can read and write the same file in parallel. Use one HDF5 file instead of thousands of small files, and also as an efficient format for storing a single large array.

Load the newest Miniforge module and create Conda environments for the examples:

```bash
module load miniforge/26.7.2-0
conda create -n h5 -c conda-forge h5py                              # serial h5py
conda create -n h5mpi -c conda-forge "h5py=*=mpi_openmpi*" mpi4py   # h5py built with MPI
```

#### Serial I/O

Store 1000 samples in one dataset of one file, instead of 1000 files. Save the code as `serial_h5.py`:

```python
import h5py
import numpy as np

with h5py.File("samples.h5", "w") as f:
    f.create_dataset("samples", data=np.random.rand(1000, 100))  # 1000 samples in one dataset

with h5py.File("samples.h5", "r") as f:
    x = f["samples"][42]  # read only sample 42 from disk
```

Run it:

```bash
module load miniforge/26.7.2-0
conda activate h5
python serial_h5.py
```

#### Parallel I/O

Each MPI rank writes its own rows into one shared file. Save the code as `parallel_h5.py`:

```python
from mpi4py import MPI
import h5py
import numpy as np

comm = MPI.COMM_WORLD
n = 100  # rows per rank

with h5py.File("parallel.h5", "w", driver="mpio", comm=comm) as f:  # all ranks open the same file
    dset = f.create_dataset("data", (comm.size * n, 10))           # collective: all ranks create it
    dset[comm.rank * n:(comm.rank + 1) * n] = comm.rank             # each rank writes its own rows
```

Submit it with this job script:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -n 4
#SBATCH -t 00:10:00

module load miniforge/26.7.2-0
conda activate h5mpi
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
mpirun -n $SLURM_NTASKS python $SLURM_SUBMIT_DIR/parallel_h5.py
```

### Archive Example

Pack a directory of small files into one tar file for long-term storage. The same approach applies before copying data to archive storage.

```bash
cd ~/orcd/pool
tar -czf mydata.tar.gz mydata/   # pack and compress the directory into one file
tar -tzf mydata.tar.gz | head    # list the contents to check
rm -r mydata/                    # remove the small files after checking
```

Before running a job, extract the archive to scratch storage:

```bash
tar -xzf ~/orcd/pool/mydata.tar.gz -C ~/orcd/scratch/
```

For data that is already compressed (such as images or `.gz` files), omit `-z` (use `tar -cf`) to save time.
