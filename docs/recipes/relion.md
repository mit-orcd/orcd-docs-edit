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

Set working directory:
```bash
WORKDIR=$HOME/software
mkdir -p $WORKDIR
```

Load modules:
```bash
module load openmpi/5.0.8
module load cuda/13.0.1
module load cmake/3.27.9
module load miniforge/24.3.0-0
```

### Install Prerequisites

RELION requires several libraries to be installed: `libtiff`, `libpng`, and `libjpeg`. Install these as follows:

libtiff:
```bash
cd $WORKDIR
wget https://download.osgeo.org/libtiff/tiff-4.7.1rc1.tar.gz
tar -xf tiff-4.7.1rc1.tar.gz
mkdir tiff-4.7.1/install
cd tiff-4.7.1/build
cmake .. -DCMAKE_INSTALL_PREFIX=$WORKDIR/tiff-4.7.1/install
```

libpng:
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

libjpeg:
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

If using non-Blackwell GPUs: (talk about which GPUS are blackwell)
```bash
conda env create -f environment.yml
```

If using Blackwell GPUs:
```bash
conda env create -f environment_blackwell.yml
```

```bash
mkdir -p build
cd build
```

Made changes here:
```bash
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

Start a new x11 session with a GPU and try it out:

request a job

Add RELION to your path:
```bash
export RELION_HOME=$HOME/software/relion/build
export PATH=$RELION_HOME/bin:$PATH
export LD_LIBRARY_PATH=$RELION_HOME/lib:$LD_LIBRARY_PATH
```

Test:
```bash
#!/bin/bash
#SBATCH --partition=mit_normal_gpu
#SBATCH --time=6:00:00
#SBATCH --nodes=1
#SBATCH -n 16
#SBATCH --cpus-per-task=2
#SBATCH --mem=64GB
#SBATCH --gres=gpu:1

module load openmpi/5.0.8
module load cuda/13.0.1
module load miniforge/24.3.0-0

export RELION_HOME=$HOME/software/relion/build
export PATH=$RELION_HOME/bin:$PATH
export LD_LIBRARY_PATH=$RELION_HOME/lib:$LD_LIBRARY_PATH

export WORKDIR=$HOME/test/relion_proj
export DATADIR=$HOME/orcd/pool/data/relion_benchmark
export SCRATCHDIR=/scratch/$USER/relion

#cd ~/relion/relion_benchmark
mkdir -p $WORKDIR/output
mkdir -p $SCRATCHDIR

mpirun -np $SLURM_NPROCS relion_refine_mpi \
  --i $DATADIR/Particles/shiny_2sets.star \
  --o $WORKDIR/output \
  --ref $DATADIR/emd_2660.map:mrc \
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
  --gpu "0" \
  --dont_combine_weights_via_disc \
  --scratch_dir $SCRATCHDIR
```

Got this:
```
ERROR: CUDA driver version is insufficient for CUDA runtime version in /home/secorey/software/relion/src/ml_optimiser_mpi.cpp at line 141 (error-code 35)
ERROR: CUDA driver version is insufficient for CUDA runtime version in /home/secorey/software/relion/src/ml_optimiser_mpi.cpp at line 141 (error-code 35)
ERROR: CUDA driver version is insufficient for CUDA runtime version in /home/secorey/software/relion/src/ml_optimiser_mpi.cpp at line 141 (error-code 35)
in: /home/secorey/software/relion/src/acc/cuda/cuda_settings.h, line in: /home/secorey/software/relion/src/acc/cuda/cuda_settings.h, line 65
ERROR: 

A GPU-function failed to execute.
```

