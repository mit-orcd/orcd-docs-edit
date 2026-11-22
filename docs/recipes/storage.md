---
tags:
 - Engaging
 - Howto Recipes
---

# Best Practices for Using Storage

Engaging provides several types of storage. Each type is designed for a specific purpose and I/O pattern. Choosing the right storage keeps your jobs running efficiently and prevents your jobs from slowing down other users' jobs.

This page has three parts. First, it describes the storage types on Engaging (home, data, scratch, compute, and archive storage) and the purpose of each type. Second, it explains the small-files problem: why a large number of small files slows down the filesystem, and how to avoid it. Third, it gives examples of three formats: HDF5 files, which store large datasets efficiently; WebDataset shards, which pack datasets for PyTorch; and tar archives, which pack many files into one.

## Storage Types

To choose a storage type, first determine the I/O load of your job. The sections below use two levels of I/O load:

- **Heavy I/O**: reading or writing large volumes of data, or many files, repeatedly during a job. Examples: reading a large dataset repeatedly, writing large checkpoints frequently, many small writes, or many tasks accessing files at the same time.
- **Light I/O**: occasional reads and writes. Examples: loading input data once at the start of a job, or writing final results at the end.

### Home Directory

Path: `/home/<username>`

Your home directory is the place for documents, source code, software installations, and small test data. Its I/O performance is the same as that of compute storage. Do not store large datasets in your home directory; use data or compute storage instead.

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

Compute storage is designed for running heavy I/O jobs, and it can also be used for long-term storage. It is useful when jobs use the same data frequently over a long period, for example daily for several months, because repeatedly copying large datasets to and from scratch storage is inconvenient and may slow down your jobs. However, it costs much more than data storage. Keep only data that needs high I/O performance on compute storage, and keep other data on data storage.

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

Keep your data files larger than 1 MB; larger files are better. As a guideline, keep no more than 1 million files per TB of data.

Typical cases that create many small files, and how to avoid them:

- Saving output in a loop, with one file per step, iteration, or output array (see the [Bad Example](#bad-example-many-small-files)). **Solution:** Write all results into one file, such as an HDF5 file (see the [HDF5 Example](#hdf5-example)).
- Writing many output files from each task in a job array, such as one file per output array. **Solution:** Write all results of a task into one HDF5 file, so that the job array creates one file per task (see [Parallel I/O with Job Array](#parallel-io-with-job-array)).
- Running a job array with many tasks, which creates many output files even with one file per task. **Solution:** Merge the output files into one file after the array finishes (see [Merging Outputs of Large Job Array](#merging-outputs-of-large-job-array)).
- Writing a separate output file from each MPI rank. **Solution:** Write the data of all ranks into one shared HDF5 file with parallel HDF5 (see [Parallel I/O with MPI](#parallel-io-with-mpi)).
- Saving a checkpoint file at every step and keeping all of them. **Solution:** Save a checkpoint every *n* steps, keep only the latest one, and delete the previous ones.
- Storing a dataset as many individual files, such as images, text documents, or training samples. **Solution:** Pack the files into HDF5 files (see the [HDF5 Example](#hdf5-example)), WebDataset shards for PyTorch (see the [WebDataset Example](#webdataset-example)), or tar archives (see the [Archive Example](#archive-example)).
- Extracting a large archive into many small files and keeping them. **Solution:** Extract it to scratch storage only when a job needs the files, and delete them when the job is done (see the [Archive Example](#archive-example)).
- Creating Conda environments or installing Python packages, which creates tens of thousands of files that cannot be avoided. **Solution:** Install them in your home directory, remove environments you no longer use (`conda env remove -n <name>`), and delete cached package files (`conda clean --all`).

To check the number of files in a directory, run:

```bash
find <dir> -type f | wc -l
```

## Examples: HDF5, WebDataset, and Archives

### Bad Example: Many Small Files

This code saves each small array of 100 values to its own file, so 1000 arrays create 1000 small files. It is the first case in [Tips to Reduce the Number of Files](#tips-to-reduce-the-number-of-files):

```python
import numpy as np

for i in range(1000):
    np.save(f"array_{i}.npy", np.random.rand(100))  # one small array per file
```

Each file uses one inode and needs its own metadata operations to create, open, and delete. With more arrays, this overloads the metadata server.

### HDF5 Example

HDF5 is a file format for numerical data, such as NumPy arrays. Use HDF5 for two purposes:

- **Replace many small files with one file.** One HDF5 file holds many arrays, so thousands of small outputs fit in one file. This reduces the load on the metadata server.
- **Store a large array efficiently.** A program can read part of an array without loading the whole file, and many MPI processes can write to the same file in parallel.

Create Conda environments for the examples. The `h5mpi` environment uses the Open MPI module on Engaging (`external_*` build) instead of installing its own Open MPI:

```bash
module load miniforge/26.7.2-0
conda create -n h5 -c conda-forge h5py   # serial h5py

module load openmpi/5.0.8
conda create -n h5mpi -c conda-forge "h5py=*=mpi_openmpi*" mpi4py "openmpi=5.*=external_*"   # h5py built with MPI
```

#### Serial I/O

This code stores the same 1000 arrays as the rows of one 2-D dataset in one file. Only one file is created, and a program can read a single row without reading the others. Save the code as `serial_h5.py`:

```python
import h5py
import numpy as np

with h5py.File("arrays.h5", "w") as f:
    f.create_dataset("data", data=np.random.rand(1000, 100))  # 1000 arrays of 100 values, stored as rows of one dataset

with h5py.File("arrays.h5", "r") as f:
    x = f["data"][32]  # read only row 32 from disk
```

Run it:

```bash
module load miniforge/26.7.2-0
conda activate h5
python serial_h5.py
```

In the example above, one process reads and writes all the data. This serial I/O works well for small data, but it becomes a limitation when:

- The data is large, and one process reads or writes it too slowly.
- The data is too large to fit in the memory of one node.
- The computation runs in parallel, and collecting all the data in one process for I/O is slow.

In these cases, use parallel I/O, in which multiple processes read and write data at the same time. Each process handles only its own part of the data, and together the processes use more of the bandwidth of the parallel filesystem. The next sections show parallel I/O with a job array, how to merge the outputs of a large job array, and parallel I/O with MPI.

#### Parallel I/O with Job Array

Each task of a job array reads its own rows from one shared input file and writes its results into its own output file. Each task is an independent process that uses serial HDF5, the same `h5` environment as in the serial I/O example. Serial HDF5 does not support writing to one file from independent processes, so each task writes its own output file. This creates one file per task instead of one file per output array. In this example, the job array has only 4 tasks, so it creates 4 output files. This works well when the array has a small number of tasks.

This code reads `arrays.h5` from the [Serial I/O](#serial-io) example. Save it as `array_h5.py`:

```python
import os
import h5py

task = int(os.environ["SLURM_ARRAY_TASK_ID"])  # 0, 1, 2, or 3
n = 250                                         # rows per task

with h5py.File("arrays.h5", "r") as f:          # all tasks read the same file
    x = f["data"][task * n:(task + 1) * n]       # read only this task's rows

result = x.mean(axis=1)                          # example computation: mean of each row

with h5py.File(f"result_{task}.h5", "w") as f:   # one output file per task
    f.create_dataset("result", data=result)      # all results of the task in one dataset
```

Copy `arrays.h5` to `~/orcd/scratch`, and use this job script for the job array:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -a 0-3
#SBATCH -t 00:10:00

module load miniforge/26.7.2-0
conda activate h5
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
python $SLURM_SUBMIT_DIR/array_h5.py
```

Save the job script as `array_h5.sh` and submit it:

```bash
sbatch array_h5.sh
```

#### Merging Outputs of Large Job Array

Some workloads need a job array with many tasks, such as a parameter sweep or the processing of many independent inputs. Such a job array creates many output files. To avoid keeping too many files, merge the output files into one file in a follow-up job that runs after the array finishes.

The following example shows how to merge the output files. For simplicity, it uses the 4 output files from the [job array](#parallel-io-with-job-array) example. The code merges them into one file and then deletes them. Save it as `merge_h5.py`:

```python
import os
import h5py
import numpy as np

names = [f"result_{t}.h5" for t in range(4)]   # one file per array task
x = []
for name in names:
    with h5py.File(name, "r") as f:
        x.append(f["result"][:])               # read the result of each task

with h5py.File("merged.h5", "w") as f:
    f.create_dataset("result", data=np.concatenate(x))  # all results in one dataset

for name in names:
    os.remove(name)                            # delete the per-task files
```

Save this job script for the merge job as `merge_h5.sh`:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -t 00:10:00

module load miniforge/26.7.2-0
conda activate h5
cd ~/orcd/scratch                      # the output files of the job array
python $SLURM_SUBMIT_DIR/merge_h5.py
```

Submit the job array, then submit the merge job so that it starts only after all array tasks succeed:

```bash
jid=$(sbatch --parsable array_h5.sh)          # job ID of the array
sbatch --dependency=afterok:$jid --kill-on-invalid-dep=yes merge_h5.sh  # start after all array tasks succeed
```

If any array task fails, the option `--kill-on-invalid-dep=yes` cancels the merge job automatically.

Slurm also writes one log file for each array task, named `slurm-<jobid>_<task>.out` by default. These log files are small files too, so delete them after you check them.

#### Parallel I/O with MPI

Parallel HDF5 uses MPI-IO, the parallel I/O layer of MPI. All MPI ranks of a job open the same file together, and each rank reads or writes only its own part of the file at the same time. Operations that change the file structure, such as creating a dataset, are collective: all ranks must call them. Unlike the job array examples, MPI-IO creates one output file, no matter how many ranks the job uses. It requires h5py built with parallel HDF5, which the `h5mpi` environment provides.

In this example, each MPI rank writes its own rows into one shared file, and then reads them back.

This code writes the file. Save it as `write_mpi_h5.py`:

```python
from mpi4py import MPI
import h5py

comm = MPI.COMM_WORLD
n = 100  # rows per rank

with h5py.File("parallel.h5", "w", driver="mpio", comm=comm) as f:  # all ranks open the same file
    dset = f.create_dataset("data", (comm.size * n, 10))           # collective: all ranks create it
    dset[comm.rank * n:(comm.rank + 1) * n] = comm.rank             # each rank writes its own rows
```

This code reads the file. Save it as `read_mpi_h5.py`:

```python
from mpi4py import MPI
import h5py

comm = MPI.COMM_WORLD
n = 100  # rows per rank

with h5py.File("parallel.h5", "r", driver="mpio", comm=comm) as f:  # all ranks open the same file
    x = f["data"][comm.rank * n:(comm.rank + 1) * n]                # each rank reads its own rows

# do some computation on x here
```

Submit both with this job script:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -n 4
#SBATCH -t 00:10:00

module load openmpi/5.0.8
module load miniforge/26.7.2-0
conda activate h5mpi
cd ~/orcd/scratch                      # run heavy I/O on scratch storage
mpirun -n $SLURM_NTASKS python $SLURM_SUBMIT_DIR/write_mpi_h5.py   # write the file
mpirun -n $SLURM_NTASKS python $SLURM_SUBMIT_DIR/read_mpi_h5.py    # read the file
```

### WebDataset Example

PyTorch is widely used for deep learning, and its training datasets often consist of a large number of small files, such as images or text samples. [WebDataset](https://github.com/webdataset/webdataset) is a dataset format designed for this case. It packs many samples into a few large tar files, called shards, and PyTorch reads the samples from the shards sequentially. Use it instead of storing a PyTorch dataset as many individual files.

Create a Conda environment with PyTorch and WebDataset:

```bash
module load miniforge/26.7.2-0
conda create -n pytorch -c conda-forge pytorch
conda activate pytorch
pip install webdataset
```

On a node without a GPU, this installs a CPU build of PyTorch, which is sufficient for this example. To install PyTorch for GPUs, see [Deep Learning with PyTorch on GPUs](torch-gpu.md#installing-pytorch).

Write 10,000 samples into 10 shards. Save the code as `write_wds.py`:

```python
import numpy as np
import webdataset as wds

# 1000 samples per shard; %03d is a 3-digit shard number: shard-000.tar, shard-001.tar, ...
with wds.ShardWriter("shard-%03d.tar", maxcount=1000) as sink:
    for i in range(10000):
        sink.write({"__key__": f"sample{i:06d}",              # unique name of the sample
                    "npy": np.random.rand(100).astype("float32"),  # input array
                    "cls": i % 10})                            # class label
```

Put many samples in each shard, so that the dataset has only a small number of shards. Too many shards create a large number of files again. A typical shard size is 100 MB to 1 GB. The shards in this example are smaller, only for demonstration.

Read the shards with a PyTorch `DataLoader`. Save the code as `read_wds.py`:

```python
import torch
import webdataset as wds

dataset = (wds.WebDataset("shard-{000..009}.tar", shardshuffle=False)  # the 10 shards
           .decode()                  # decode .npy and .cls files
           .to_tuple("npy", "cls"))   # yield (input, label) pairs
loader = torch.utils.data.DataLoader(dataset, batch_size=64, num_workers=2)  # 2 workers, 5 shards each

for x, y in loader:
    print(x.shape, y.shape)  # torch.Size([64, 100]) torch.Size([64])
    break
```

Run both scripts with this job script. It requests 2 CPU cores, one for each worker:

```bash
#!/bin/bash
#SBATCH -p mit_normal
#SBATCH -c 2
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
