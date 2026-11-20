---
tags:
 - Engaging
 - Howto Recipes
---

# Best Practices for Data Storages

Engaging provides several types of storage. Each type is designed for a specific purpose and I/O pattern. Choosing the right storage keeps your jobs running efficiently and prevents your jobs from slowing down other users' jobs.

Policies (backup, quota, purge, and purchase) are described on these pages and are not repeated here:

- Home directory, `~/orcd/pool`, and `~/orcd/scratch`: [General Use Filesystems](../filesystems-file-transfer/filesystems.md)
- `/orcd/data` and `/orcd/compute`: [Storage Services](../services/storage-services.md)

Storage under `/home/<username>` and `~/orcd` is provided to each user. Storage under `/orcd/data`, `/orcd/scratch`, `/orcd/compute`, and `/orcd/archive` is purchased by labs or departments and shared by their members.

In this page, the I/O load of a job is described as follows:

- **Heavy I/O**: reading or writing large volumes of data, or many files, repeatedly during a job. Examples: writing checkpoints frequently, many small writes, or many tasks accessing files at the same time.
- **Light I/O**: occasional reads and writes. Examples: loading input data once at the start of a job, or writing final results at the end.

## Home Directory

Path: `/home/<username>`

- Use only for documents, source code, software installations, and small test data.
- I/O performance is the same as compute storage.
- Do not store large datasets here. Use data storage instead.

## Data Storage

Paths: `~/orcd/pool` (per user) and `/orcd/data` (lab or department)

- Both paths have the same performance.
- Use for long-term storage of datasets, code outputs, and results.
- Light I/O is fine. Do not run heavy I/O jobs here: they slow down both your job and other users' jobs. Run heavy I/O jobs on scratch or compute storage instead.

## Scratch Storage

Paths: `~/orcd/scratch` (per user) and `/orcd/scratch` (lab or department)

- Both paths have the same performance.
- Use for heavy I/O jobs and for temporary or intermediate files.
- The lab or department scratch `/orcd/scratch` is not backed up and is not purged automatically.
- Delete files you no longer need when your job is done.

A typical workflow:

1. Copy input data from data storage to scratch storage.
2. Run the job on scratch storage.
3. Copy the results back to data storage.
4. Delete the files on scratch storage.

## Compute Storage

Path: `/orcd/compute` (lab or department)

- Use for running heavy I/O jobs.
- Can also be used for long-term storage.
- It costs much more than data storage, so keep only data that needs high I/O performance here.

## Archive Storage

Path: `/orcd/archive` (lab or department)

- Archive storage is provided by the Northeast Storage Exchange (NESE). NESE is a storage system hosted on a Harvard cluster at the MGHPCC and mounted on Engaging.
- The network connection between NESE and Engaging has low bandwidth, even though both are in the same building. Reading and writing NESE from Engaging is slow.
- Use only for long-term storage of data that is not actively used.
- Archive storage is not backed up.
- Do not run jobs on archive storage. Copy the data to data, scratch, or compute storage before running jobs.
- Pack small files into large archive files (see [Archive Example](#archive-example)) before copying them to archive storage.

## Small Files

Every file uses one inode. Every file operation such as open, close, or `stat` is a metadata operation handled by the metadata server of the filesystem. Millions of small files overload the metadata server.

!!! warning "Too many small files slow down the filesystem"
    Creating or accessing very large numbers of small files substantially slows down the filesystem. This affects not only your jobs but also other users' jobs.

Each file also counts against the per-user file count (inode) quota. See [General Use Filesystems](../filesystems-file-transfer/filesystems.md) for the quota.

Tips:

- Combine many small files into a few large files, such as HDF5 files or tar archives.
- Do not write one output file per step or per sample.
- Check the number of files in a directory:
  ```bash
  find <dir> -type f | wc -l
  ```

## HDF5 Example

HDF5 stores many arrays in a single file. Use one HDF5 file instead of thousands of small files.

Load the newest Miniforge module and create Conda environments for the examples:

```bash
module load miniforge/25.11.0-0
conda create -n h5 -c conda-forge h5py                              # serial h5py
conda create -n h5mpi -c conda-forge "h5py=*=mpi_openmpi*" mpi4py   # h5py built with MPI
```

### Serial I/O

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
module load miniforge/25.11.0-0
conda activate h5
python serial_h5.py
```

### Parallel I/O

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

module load miniforge/25.11.0-0
conda activate h5mpi
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
mpirun -n $SLURM_NTASKS python $SLURM_SUBMIT_DIR/parallel_h5.py
```

## Archive Example

Pack a directory of small files into one tar file before storing it on archive storage:

```bash
tar -czf mydata.tar.gz mydata/          # pack and compress the directory into one file
tar -tzf mydata.tar.gz | head           # list the contents to check
cp mydata.tar.gz /orcd/archive/<group>/ # copy one large file to archive storage
```

Before running a job, copy the archive to scratch storage and extract it there:

```bash
cp /orcd/archive/<group>/mydata.tar.gz ~/orcd/scratch/
tar -xzf ~/orcd/scratch/mydata.tar.gz -C ~/orcd/scratch/
```

For data that is already compressed (such as images or `.gz` files), omit `-z` (use `tar -cf`) to save time.

## Summary

| Storage | Paths | Use for | Run jobs here? |
| ------- | ----- | ------- | -------------- |
| Home | `/home/<username>` | Documents, source code, software, small test data | Small tests only |
| Data | `~/orcd/pool`, `/orcd/data` | Long-term datasets and results | Light I/O only |
| Scratch | `~/orcd/scratch`, `/orcd/scratch` | Heavy I/O, temporary files | Yes; delete files when done |
| Compute | `/orcd/compute` | Heavy I/O, long-term storage (higher cost) | Yes |
| Archive | `/orcd/archive` | Long-term storage of inactive data | No; copy data out first |
