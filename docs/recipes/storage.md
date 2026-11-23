---
tags:
 - Engaging
 - Howto Recipes
---

# Best Practices for Using Storage

Engaging provides several types of storage. Each type is designed for a specific purpose and I/O pattern. Choosing the right storage keeps your jobs running efficiently and prevents your jobs from slowing down other users' jobs.

This page has three parts. First, it describes the storage types on Engaging (home, data, scratch, compute, and archive storage) and the purpose of each type. Second, it explains the small-files problem: why a large number of small files slows down the filesystem, and how to avoid it. Third, it gives examples of three formats: HDF5 files, which store large numerical data efficiently; WebDataset shards, which pack datasets for PyTorch; and tar archives, which pack many files into one.

## Storage Types

To choose a storage type, first determine the I/O load of your job. The sections below use two levels of I/O load:

- **Heavy I/O**: reading or writing large volumes of data, or many files, repeatedly during a job. Examples: reading a large dataset repeatedly, writing large checkpoints frequently, many small writes, or many tasks accessing files at the same time.
- **Light I/O**: occasional reads and writes. Examples: loading input data once at the start of a job, or writing final results at the end.

### Home Directory

Path: `/home/<username>`

Your home directory is the place for documents, source code, software installations, and small test data. Its I/O performance is the same as that of scratch and compute storage. Do not store large datasets in your home directory; use data or compute storage instead.

### Data Storage

Paths: `~/orcd/pool` (per user) and `/orcd/data` (lab or department)

Data storage is designed for long-term storage of datasets, code outputs, and results.

Jobs with light I/O can run on data storage. Do not run heavy I/O jobs here, because they slow down both your job and other users' jobs. Run heavy I/O jobs on scratch or compute storage instead.

### Scratch Storage

Paths: `~/orcd/scratch` (per user) and `/orcd/scratch` (lab or department)

Scratch storage is designed for heavy I/O jobs and for temporary or intermediate files.

Currently, scratch storage is not purged automatically. Per-user scratch storage can also be used for long-term storage, but it is limited to 1 TB. For lab or department scratch storage, each lab or department decides how long files are kept. It is good practice to delete files you no longer need when your job is done, so that space remains available for active work.

The following workflow uses data storage and scratch storage together. It is recommended but not required:

1. Copy input data from data storage to scratch storage.
2. Run the job on scratch storage.
3. Copy the results back to data storage.
4. Delete the files on scratch storage.

### Compute Storage

Path: `/orcd/compute` (lab or department)

Compute storage is designed for running heavy I/O jobs, and it can also be used for long-term storage. Its I/O performance is the same as that of scratch storage. It is useful when jobs use the same data frequently over a long period, for example daily for several months, because repeatedly copying large datasets to and from scratch storage is inconvenient and may slow down your jobs. However, it costs much more than data storage. Keep only data that needs high I/O performance on compute storage, and keep other data on data storage.

### Archive Storage

Path: `/orcd/archive` (lab or department)

Archive storage is provided by the Northeast Storage Exchange (NESE). NESE is a storage system hosted on a Harvard computing cluster at the MGHPCC and mounted on Engaging. Although both clusters are in the same building, the network connection between them has low bandwidth, so reading and writing NESE from Engaging is slow.

For this reason, use archive storage only for long-term storage of data that is not actively used. Do not run jobs on archive storage; copy the data to scratch or compute storage before running jobs. Before copying data to archive storage, pack small files into large archive files (see [Archive Example](#archive-example)).

### Policies

Policies for backup, quota, purge, and purchase are described on the following pages and are not repeated here:

- The home directory, per-user data storage, and per-user scratch storage are provided to each user. Refer to [General Use Filesystems](../filesystems-file-transfer/filesystems.md)
- Lab or department data storage, scratch storage, compute storage, and archive storage are purchased by labs or departments and shared by their members. Refer to [Storage Services](../services/storage-services.md)

### Summary

| Storage | Paths | Use for | Run jobs here? |
| ------- | ----- | ------- | -------------- |
| Home | `/home/<username>` | Documents, source code, software, small test data | Small tests only |
| Data | `~/orcd/pool`, `/orcd/data` | Long-term datasets and results | Light I/O only |
| Scratch | `~/orcd/scratch`, `/orcd/scratch` | Heavy I/O, temporary files | Yes; delete files when done |
| Compute | `/orcd/compute` | Heavy I/O, long-term storage (higher cost) | Yes |
| Archive | `/orcd/archive` | Long-term storage of inactive data | No; copy data out first |

## Avoiding Many Small Files

All the storage types above are shared filesystems, where a large number of small files slows down I/O for all users. Typically, a file smaller than 1 MB is considered a small file.

### Why Many Small Files Are a Problem

Every file uses one inode, which stores the metadata of the file. File operations such as opening, closing, listing, or deleting files read or update this metadata, and the metadata server of the filesystem handles each of these operations. As a result, a large number of small files overloads the metadata server.

Common commands that perform metadata operations include:

- `ls`: reads the list of files in a directory.
- `ls -l`: also reads the metadata (size, owner, permissions, and timestamps) of every file in the list.
- `rm`: removes a file and frees its inode, one metadata operation for each file.

On a directory with a very large number of files, each of these commands can hang and add heavy load to the metadata server.

??? note "What is an inode?"
    An inode is a data structure that the filesystem uses to store information about a file, such as its size, owner, permissions, and location on disk. Each file or directory uses one inode, regardless of its size.

Each file also counts against the per-user file count (inode) quota. See [General Use Filesystems](../filesystems-file-transfer/filesystems.md) for the quota.

### Tips to Reduce the Number of Files

These tips focus on data files, such as job outputs, checkpoints, and datasets, which usually account for most of the files. Source code and documents are usually small in number and do not need to be packed.

<span style="color: black;">Keep your data files larger than 1 MB; larger files are better. As a guideline, keep no more than 1 million files per TB of data.</span>

To check the number of files in a directory, run:

```bash
find <dir> -type f | wc -l
```

Typical cases that create many small files, and how to avoid them:

- Saving output in a loop, with one file per step, iteration, or sample (see the [Bad Example](#bad-example-many-small-files)). **Solution:** Write all results into one file, such as an HDF5 file (see the [HDF5 Example](#hdf5-example)).
- Writing many output files from each task in a job array. **Solution:** Write all results of a task into one HDF5 file, so that the job array creates one file per task (see [Parallel I/O with Job Array](#parallel-io-with-job-array)).
- Running a job array with many tasks, which creates many output files even with one file per task. **Solution:** Merge the output files into one file after the job array finishes (see [Merging Outputs of Large Job Array](#merging-outputs-of-large-job-array)).
- Writing a separate output file from each MPI rank. **Solution:** Write the data of all ranks into one shared HDF5 file with parallel HDF5 (see [Parallel I/O with MPI](#parallel-io-with-mpi)).
- Saving a checkpoint file at every step and keeping all of them. **Solution:** Save a checkpoint every *n* steps, keep only the latest one, and delete the previous ones.
- Storing a dataset as many individual files, such as images, text documents, or training samples. **Solution:** Pack the files into WebDataset shards for PyTorch (see the [WebDataset Example](#webdataset-example)) or tar archives (see the [Archive Example](#archive-example)).
- Extracting a large archive into many small files and keeping them. **Solution:** Extract it to scratch storage only when a job needs the files, and delete them when the job is done (see the [Archive Example](#archive-example)).
- Creating Conda environments or installing Python packages, which creates tens of thousands of files that cannot be avoided. **Solution:** Install them in your home directory, remove environments you no longer use (`conda env remove -n <name>`), and delete cached package files (`conda clean --all`).

## Examples: Fewer Files and Efficient I/O

### Bad Example: Many Small Files

The following code saves each sample of 100 values to its own file, so 1000 samples create 1000 small files. It is the first case in [Tips to Reduce the Number of Files](#tips-to-reduce-the-number-of-files). Here, a sample is a small NumPy array:

```python
import numpy as np

for i in range(1000):
    np.save("sample_" + str(i) + ".npy", np.random.rand(100))  # one sample per file
```

Each file uses one inode and needs its own metadata operations to create, open, and delete. With more samples, this overloads the metadata server.

### HDF5 Example

HDF5 is a file format for large numerical data. An HDF5 file holds one or more *HDF5 datasets*; an HDF5 dataset is a named array, such as `samples` in the examples. Use HDF5 for two purposes:

- **Replace many small files with one file.** One HDF5 file holds many samples, so thousands of small files become one file. This reduces the load on the metadata server. The [Serial I/O](#serial-io) example writes all samples into one file. The [Parallel I/O with Job Array](#parallel-io-with-job-array) example writes one file per task instead of one file per sample, and the [merging](#merging-outputs-of-large-job-array) example combines these files into one file.
- **Read and write large data efficiently.** A program can read only the part of the data it needs, without loading the whole file into memory. With parallel HDF5, many MPI processes can read and write their own parts of the same file at the same time, as in the [Parallel I/O with MPI](#parallel-io-with-mpi) example.

First, create Conda environments for the examples.

For serial HDF5, create the `hdf5` environment with h5py from conda-forge:

```bash
module load miniforge/26.7.2-0
conda create -n hdf5 -c conda-forge h5py
```

For parallel HDF5, create the `hdf5mpi` environment. In this environment, the mpi4py and h5py packages are built from source against the Open MPI and parallel HDF5 modules on Engaging:

```bash
module load miniforge/26.7.2-0
module load openmpi/4.1.4 hdf5/1.14.3    # Open MPI and parallel HDF5 modules
conda create -n hdf5mpi -c conda-forge python numpy pip
conda activate hdf5mpi
pip install --no-binary=mpi4py mpi4py    # build mpi4py with the Open MPI module
HDF5_MPI=ON HDF5_DIR=$(dirname $(dirname $(which h5pcc))) CC=mpicc pip install --no-binary=h5py h5py   # build h5py with the HDF5 module
```

#### Serial I/O

The following code stores the same 1000 samples as the rows of one 2-D HDF5 dataset in one file. Only one file is created. Save the code as `write_h5.py`:

```python
import h5py, numpy as np

with h5py.File("serial.h5", "w") as f:
    f.create_dataset("samples", data=np.random.rand(1000, 100))  # 1000 samples of 100 values, stored as rows of one HDF5 dataset
```

The following code reads all samples and computes the mean of each sample. Save the code as `read_h5.py`:

```python
import h5py

with h5py.File("serial.h5", "r") as f:
    x = f["samples"][:]  # read all samples

result = x.mean(axis=1)  # example computation: mean of each sample
print(result[:5])        # means of the first 5 samples
```

Use the following job script to run both scripts. Save it as `serial_h5.sh`:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -t 00:10:00

module load miniforge/26.7.2-0
conda activate hdf5
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
python $SLURM_SUBMIT_DIR/write_h5.py   # write the file
python $SLURM_SUBMIT_DIR/read_h5.py    # read the file
```

Submit the job:

```bash
sbatch serial_h5.sh
```

One HDF5 file can also hold several datasets with different names, shapes and data types. For example, the same file could also store a `labels` dataset of 1000 integers, one label per sample. Storing related datasets in one file instead of separate files further reduces the number of files.

In the example above, one process reads and writes all the data, that is, all 1000 samples. This serial I/O works well for small data, but it becomes a limitation when:

- The data is large, such as many GB or TB, and one process reads or writes it too slowly.
- The data is too large to fit in the memory of one node.

In these cases, use parallel I/O, in which multiple processes read and write data at the same time. Each process handles only its own part of the data, and together the processes use more of the bandwidth of the parallel filesystem. The next sections show parallel I/O with a job array, how to merge the outputs of a large job array, and parallel I/O with MPI.

#### Parallel I/O with Job Array

In this example, each task of a job array uses serial HDF5 to write 1000 samples, the same size as the file in the [Serial I/O](#serial-io) example. Serial HDF5 does not support writing to one file from independent processes, so each task writes its own file. Then each task of a second job array reads one of these files and computes the mean of each sample. The job array has only 4 tasks, so it creates 4 files. Because the 4 tasks write at the same time, the job array can write these 4000 samples up to 4 times faster than serial I/O.

The following code writes the files. Save it as `write_array_h5.py`:

```python
import os, h5py, numpy as np

task = int(os.environ["SLURM_ARRAY_TASK_ID"])  # 0, 1, 2, or 3

with h5py.File("array_" + str(task) + ".h5", "w") as f:  # one file per task
    f.create_dataset("samples", data=np.random.rand(1000, 100))  # 1000 samples of 100 values, as in the serial example
```

The following code reads the files. Save it as `read_array_h5.py`:

```python
import os, h5py

task = int(os.environ["SLURM_ARRAY_TASK_ID"])  # 0, 1, 2, or 3

with h5py.File("array_" + str(task) + ".h5", "r") as f:  # each task reads its own file
    x = f["samples"][:]  # read all samples of the file

result = x.mean(axis=1)  # example computation: mean of each sample
print(result[:5])        # means of the first 5 samples
```

Use the following job script for both job arrays. Save it as `array_h5.sh`:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -a 0-3
#SBATCH -t 00:10:00

module load miniforge/26.7.2-0
conda activate hdf5
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
python $SLURM_SUBMIT_DIR/$1            # $1: the Python script to run
```

Submit the write job array:

```bash
sbatch array_h5.sh write_array_h5.py
```

After all write tasks finish, submit the read job array:

```bash
sbatch array_h5.sh read_array_h5.py
```

#### Merging Outputs of Large Job Array

One file per task works well when the job array has a small number of tasks. Some workloads, however, need a job array with many tasks, such as a parameter sweep or the processing of many independent inputs, and such a job array creates many output files. To avoid keeping too many files, merge the output files into one file in a follow-up job that runs after the job array finishes.

The following example shows how to merge the output files. For simplicity, it uses the 4 files from the write job array in the above example. The code merges them into one file and then deletes them. Save it as `merge_h5.py`:

```python
import os, h5py, numpy as np

names = ["array_" + str(t) + ".h5" for t in range(4)]  # one file per job array task
x = []
for name in names:
    with h5py.File(name, "r") as f:
        x.append(f["samples"][:])              # x: a Python list of 4 NumPy arrays, each 1000×100

with h5py.File("array_all.h5", "w") as f:
    f.create_dataset("samples", data=np.concatenate(x))  # NumPy joins the 4 arrays into one 4000×100 array

for name in names:
    os.remove(name)                            # delete the per-task files
```

Save the following job script for the merge job as `merge_h5.sh`:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -t 00:10:00

module load miniforge/26.7.2-0
conda activate hdf5
cd ~/orcd/scratch                      # the output files of the job array
python $SLURM_SUBMIT_DIR/merge_h5.py
```

Submit the write job array, then submit the merge job so that it starts only after all job array tasks succeed:

```bash
jid=$(sbatch --parsable array_h5.sh write_array_h5.py)  # job ID of the write job array
sbatch --dependency=afterok:$jid --kill-on-invalid-dep=yes merge_h5.sh  # start after all job array tasks succeed
```

Slurm also writes one log file for each job array task, named `slurm-<jobid>_<task>.out` by default. These log files are small files too, so delete them after you check them.

#### Parallel I/O with MPI

A job array writes one file per task, and a large job array needs a merge job, which reads and writes all the data a second time. With parallel HDF5, all processes of one MPI job write to one shared file directly, so no merge is needed. This suits programs that already use MPI, or workloads with too many tasks to merge efficiently. The trade-offs are that it requires the `hdf5mpi` environment built from source, and that the processes are no longer independent: if one rank fails, the whole job fails.

Parallel HDF5 uses MPI-IO, the parallel I/O layer of MPI. All MPI ranks of a job open the same file together, and each rank reads or writes only its own part of the file at the same time.

In this example, 4 MPI ranks write 4000 samples into one shared file, 1000 samples per rank. Then each rank reads its own samples back and computes the mean of each sample. Because the 4 ranks read and write at the same time, the job can handle these 4000 samples up to 4 times faster than a serial code.

The following code writes the file. Save it as `write_mpi_h5.py`:

```python
from mpi4py import MPI
import h5py, numpy as np

comm = MPI.COMM_WORLD
n = 4000              # total number of samples
m = n // comm.size    # samples per rank: 1000 with 4 ranks

with h5py.File("parallel.h5", "w", driver="mpio", comm=comm) as f:  # all ranks open the same file
    dset = f.create_dataset("samples", (n, 100), dtype="f8")  # collective: all ranks must call this
    dset[comm.rank * m:(comm.rank + 1) * m] = np.random.rand(m, 100)  # each rank writes its own samples
```

??? note "Why all ranks call `create_dataset`"
    The `create_dataset` call only declares the shape and data type of the dataset in the file. It does not allocate a 4000×100 array in memory. All ranks make the same call so that they agree on the file structure, and the file ends up with one dataset. In the last line of the code, each rank generates only its own 1000×100 array with `np.random.rand(m, 100)`, so each rank holds only that array in memory.

In the following code, each rank reads its own samples from the shared file and computes the mean of each sample. Save the code as `read_mpi_h5.py`:

```python
from mpi4py import MPI
import h5py

comm = MPI.COMM_WORLD
n = 4000              # total number of samples
m = n // comm.size    # samples per rank: 1000 with 4 ranks

with h5py.File("parallel.h5", "r", driver="mpio", comm=comm) as f:  # all ranks open the same file
    x = f["samples"][comm.rank * m:(comm.rank + 1) * m]             # each rank reads its own samples

result = x.mean(axis=1)         # example computation: mean of each sample
print(comm.rank, result[:5])    # means of the first 5 samples of this rank
```

Submit both with the following job script:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -n 4
#SBATCH -t 00:10:00

module load openmpi/4.1.4 hdf5/1.14.3
module load miniforge/26.7.2-0
conda activate hdf5mpi
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
mpirun -n $SLURM_NTASKS python $SLURM_SUBMIT_DIR/write_mpi_h5.py   # write the file
mpirun -n $SLURM_NTASKS python $SLURM_SUBMIT_DIR/read_mpi_h5.py    # read the file
```

### WebDataset Example

PyTorch is widely used for deep learning, and its training datasets often consist of a large number of small files, such as images or text samples. [WebDataset](https://github.com/webdataset/webdataset) is a dataset format designed to avoid storing many small files. It packs many samples into a few large tar files, called shards. Each data loader worker reads its shards sequentially, and multiple workers read different shards in parallel.

Create a Conda environment with PyTorch and WebDataset:

```bash
module load miniforge/26.7.2-0
conda create -n pytorch -c conda-forge pytorch
conda activate pytorch
pip install webdataset
```

??? note "Installing PyTorch on GPUs"
    On a node without a GPU, this installs a CPU build of PyTorch, which is sufficient for this example. To install PyTorch for GPUs, see [Deep Learning with PyTorch on GPUs](torch-gpu.md#installing-pytorch).

Write 4000 samples into 4 shards. In this example, a sample is a small NumPy array of 100 values with a class label. Save the code as `write_wds.py`:

```python
import numpy as np, webdataset as wds

# A new shard starts after every 1000 samples: shard-00.tar, shard-01.tar, ...
with wds.ShardWriter("shard-%02d.tar", maxcount=1000) as writer:  # %02d: 2-digit shard number
    for i in range(4000):  # 4000 samples in total
        writer.write({"__key__": "sample" + str(i),                  # unique name of the sample
                      "npy": np.random.rand(100).astype("float32"),  # saved as sample<i>.npy: 100 values
                      "cls": i % 10})                                # saved as sample<i>.cls: label 0 to 9
```

??? note "How samples are stored in a shard"
    A shard is a tar file. Each field of a sample is stored in the shard as a separate member file named `key.extension`, for example `sample0.npy` and `sample0.cls`. The extension tells WebDataset how to decode the member: `.npy` is a NumPy array, and `.cls` is an integer class label.

Put many samples in each shard, so that the dataset has only a small number of shards. In this example, 1000 samples per shard give 4 shards for 4000 samples, instead of 4000 files. A typical shard size is 100 MB to 1 GB. The shards in this example are smaller, only for demonstration. Use at least as many shards as data loader workers, so that every worker has a shard to read.

Read the shards with a PyTorch `DataLoader`. Save the code as `read_wds.py`:

```python
import torch, webdataset as wds

dataset = (wds.WebDataset("shard-{00..03}.tar", shardshuffle=False)  # the 4 shards, in this order
           .decode()                  # decode the "npy" and "cls" fields
           .to_tuple("npy", "cls"))   # yield each sample as a pair: ("npy", "cls")

if __name__ == "__main__":  # run this block only in the main process, not in the workers
    loader = torch.utils.data.DataLoader(
        dataset,
        batch_size=64,   # up to 64 samples per batch
        num_workers=4)   # 4 workers read in parallel, one shard each
    count = 0
    for x, y in loader:  # x: a batch of "npy" arrays, y: their "cls" labels; loop through all samples
        count += len(y)  # count the samples; a real job would train here
    print(count)         # 4000
```

??? note "How the shards are read and the batches are formed"
    The `DataLoader` reads the shards in three steps:

    1. **Assign shards to workers.** The `DataLoader` starts 4 worker processes (`num_workers=4`), and WebDataset gives each worker one shard: worker 0 reads `shard-00.tar`, worker 1 reads `shard-01.tar`, and so on.
    2. **Decode and form batches in each worker.** Each worker reads its shard from start to end, decodes each sample into a NumPy array and a label, and groups every 64 consecutive samples into a batch, so a batch contains samples from only one shard. The 4 workers do this at the same time.
    3. **Collect batches in the main process.** The main process takes one batch from each worker in turn, so the loop receives the batches in this order:

    | Batch | Worker | Shard | Samples |
    |-------|--------|-------|---------|
    | 1 | 0 | `shard-00.tar` | 0-63 |
    | 2 | 1 | `shard-01.tar` | 1000-1063 |
    | 3 | 2 | `shard-02.tar` | 2000-2063 |
    | 4 | 3 | `shard-03.tar` | 3000-3063 |
    | 5 | 0 | `shard-00.tar` | 64-127 |

    Each shard has 1000 samples, so each worker forms 15 batches of 64 samples and one last batch of 40 samples. The loop ends after 64 batches (16 from each worker), when all 4000 samples are read. This example does not shuffle the samples, but a real training process should shuffle them.

    In real training, step 2 takes most of the time: workers read large amounts of data from storage, decode compressed data such as images or audio, and apply transforms such as cropping and resizing. Running several workers in parallel speeds up this step. Steps 1 and 3 are cheap: step 1 assigns the shards once at the start, and in step 3 the main process only receives finished batches, one at a time.

Run both scripts with the following job script. It requests 4 CPU cores, one for each worker:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -c 4  # 4 CPU cores, one for each worker
#SBATCH -t 00:10:00

module load miniforge/26.7.2-0
conda activate pytorch
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
python $SLURM_SUBMIT_DIR/write_wds.py  # write the shards
python $SLURM_SUBMIT_DIR/read_wds.py   # read the shards
```

Save the job script as `wds.sh` and submit it:

```bash
sbatch wds.sh
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

For data that is already compressed (such as images or `.gz` files), omit `-z` to save time: pack with `tar -cf` and extract with `tar -xf`.
