---
tags:
 - MPI
 - Install Recipe
---

# Installing RELION on Engaging

RELION (REgularised LIkelihood OptimisatioN, pronounced rely-on) is a software package that employs an empirical Bayesian approach for electron cryo-microscopy (cryo-EM) structure determination. This recipe describes how to install RELION 5.0 on Engaging, and is adapted from [this installation guide](https://relion.readthedocs.io/en/release-5.0/Installation.html).

First, request an interactive job on Engaging so the installation can run more quickly:
```bash
salloc -p mit_normal -N 1 -n 4 --mem-per-cpu=4G
```

## Environment Configuration

Set working directory (feel free to change this to a directory of your choice):
```bash
WORKDIR=$HOME/software
mkdir -p $WORKDIR
```

Load modules:
```bash
module load openmpi/5.0.8
module load cuda/12.4.0
module load cmake/3.27.9
module load miniforge/24.3.0-0
```

### Install Prerequisites

RELION requires several libraries to be installed: `libtiff`, `libpng`, and `libjpeg`. Install these as follows:

**`libtiff`**:
```bash
cd $WORKDIR
wget https://download.osgeo.org/libtiff/tiff-4.7.1rc1.tar.gz
tar -xf tiff-4.7.1rc1.tar.gz
mkdir tiff-4.7.1/install
cd tiff-4.7.1/build
cmake .. -DCMAKE_INSTALL_PREFIX=$WORKDIR/tiff-4.7.1/install
```

**`libpng`**:
```bash
cd $WORKDIR
wget https://download.sourceforge.net/libpng/libpng-1.6.50.tar.gz
tar -xf libpng-1.6.50.tar.gz
cd libpng-1.6.50
mkdir install
./configure --prefix=$PWD/install
make -j $SLURM_NPROCS
make install
```

**`libjpeg`**:
```bash
cd $WORKDIR
wget http://www.ijg.org/files/jpegsrc.v9e.tar.gz
tar -xf jpegsrc.v9e.tar.gz
cd jpeg-9e
mkdir install
./configure --prefix=$PWD/install
make -j $SLURM_NPROCS
make install
```

## Install RELION

Clone repository:
```bash
cd $WORKDIR
git clone https://github.com/3dem/relion.git
cd relion
git checkout ver5.0
git pull
```

RELION uses a Conda environment during the installation process. The Conda environment you use depends on whether you are using Blackwell GPUs (e.g., B200, RTX 6000 series) or not (e.g., A100, L40S, H100, H200). You can visit [this page](../running-jobs/available-resources.md) to check which GPUs we have available on the public partitions on Engaging.

=== "Non-Blackwell GPUs"

    ```bash
    conda env create -f environment.yml
    ```

=== "Blackwell GPUs"

    ```bash
    conda env create -f environment_blackwell.yml
    ```

!!! note
    Do not activate the Conda environment.

Use `cmake` to build:

```bash
cd $WORKDIR/relion
mkdir -p build
cd build
cmake -DTIFF_LIBRARY=$WORKDIR/tiff-4.7.1/install/lib64/libtiff.so \
      -DTIFF_INCLUDE_DIR=$WORKDIR/tiff-4.7.1/install/include \
      -DPNG_LIBRARY=$WORKDIR/libpng-1.6.50/install/lib/libpng.so \
      -DPNG_PNG_INCLUDE_DIR=$WORKDIR/libpng-1.6.50/install/include \
      -DJPEG_LIBRARY=$WORKDIR/jpeg-9e/install/lib/libjpeg.so \
      -DJPEG_INCLUDE_DIR=$WORKDIR/jpeg-9e/install/include \
      -DCUDA_ARCH="89" \
      ..
```

Install with multiple processes:

```bash
make -j $SLURM_NPROCS
```

## Using RELION

We now present some examples for running RELION on Engaging.

### RELION GUI

To interact with the RELION GUI, you can use X11 forwarding. First, log in to Engaging (in a new session) with X11 forwarding enabled:

```bash
ssh -X <username>@orcd-login.mit.edu
```

Then, request an interactive job with X11 support:

```bash
salloc -p mit_normal -N 1 -n 4 --mem-per-cpu=4G --x11
```

Set up environment:

```bash
module load openmpi/5.0.8
module load cuda/12.4.0 
module load miniforge/24.3.0-0

export RELION_HOME=$HOME/software/relion/build
export PATH=$RELION_HOME/bin:$PATH
export LD_LIBRARY_PATH=$RELION_HOME/lib:$LD_LIBRARY_PATH
```

Start RELION in the background:
```bash
relion &
```

The RELION GUI should now appear on your local machine.

### Batch Job

This more advanced example runs a RELION 3D refinement job on Engaging using MPI and a GPU. This example uses a benchmark dataset that can be freely downloaded.

Download and extract the benchmark dataset (the dataset is quite large, so you might want to do this in a [batch job](../running-jobs/overview.md#batch-jobs)):

```bash
cd $HOME
wget ftp://ftp.mrc-lmb.cam.ac.uk/pub/scheres/relion_benchmark.tar.gz
tar -xf relion_benchmark.tar.gz
```

Run the benchmark in a batch job with a GPU:

<!-- need to fix the output of this script -->

```bash title="relion_refine_mpi.sbatch"
#!/bin/bash

#SBATCH --partition=mit_normal_gpu
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-core=1
#SBATCH --mem-per-cpu=16G
#SBATCH -G 1

module load openmpi/5.0.8
module load cuda/12.4.0 
module load miniforge/24.3.0-0

export RELION_HOME=$HOME/software/relion/build
export PATH=$RELION_HOME/bin:$PATH
export LD_LIBRARY_PATH=$RELION_HOME/lib:$LD_LIBRARY_PATH

export WORKDIR=$HOME/relion_benchmark
export SCRATCHDIR=/scratch/$USER/relion

mkdir -p $WORKDIR/output
mkdir -p $SCRATCHDIR

cd $WORKDIR

mpirun -np $SLURM_NPROCS relion_refine_mpi \
  --i $WORKDIR/Particles/shiny_2sets.star \
  --o $WORKDIR/output/$SLURM_JOB_ID \
  --ref $WORKDIR/emd_2660.map:mrc \
  --ini_high 60 \
  --pool 100 \
  --pad 2  \
  --ctf \
  --iter 25 \
  --tau2_fudge 4 \
  --particle_diameter 360 \
  --K 4 \
  --flatten_solvent \
  --zero_mask \
  --oversampling 1 \
  --healpix_order 2 \
  --offset_range 5 \
  --offset_step 2 \
  --sym C1 \
  --norm \
  --scale \
  --j 1   \
  --gpu $CUDA_VISIBLE_DEVICES \
  --dont_combine_weights_via_disc \
  --scratch_dir $SCRATCHDIR
```

Submit your job:

```bash
sbatch relion_refine_mpi.sbatch
```
