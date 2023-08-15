---
tags:
 - Engaging
 - SuperCloud
 - Howto Recipes
 - Gromacs
---

# Installing and Using GROMACS

GROMACS is a free and open-source software suite for high-performance molecular dynamics and output analysis.

You can learn about GROMACS here: [https://www.gromacs.org/](https://www.gromacs.org/).

## GROMACS on Engaging

### Install GROMACS with MPI

Select a version on the [GROMACS website](https://ftp.gromacs.org/pub/gromacs/), then dowload and extract the tar ball.
```
cd ~
mkdir gromacs
cd gromacs
wget --no-check-certificate http://ftp.gromacs.org/pub/gromacs/gromacs-2019.6.tar.gz
tar xvfz gromacs-2019.6.tar.gz
```

Load MPI and Cmake modules,
```
module load engaging/openmpi/2.0.3 cmake/3.17.3
```

Create build and isntall directories,
```
mkdir -p 2019.6/build
mkdir 2019.6/install
cd 2019.6/build
```

Use `cmake` to configure compiling options,
```
cmake ~/gromacs/gromacs-2019.6 -DGMX_MPI=ON -DCMAKE_INSTALL_PREFIX=~/gromacs/2019.6/install
```

Compile, check and install,
```
make
make check
make install
```

Set up usage enviroenment,
```
source ~/gromacs/2019.6/install/bin/GMXRC
```


## GROMACS on SuperCloud

### Install GROMACS with MPI and CUDA

Select a version on the [GROMACS website](https://ftp.gromacs.org/pub/gromacs/), then dowload and extract the tar ball.
```
cd ~
mkdir gromacs
cd gromacs
wget http://ftp.gromacs.org/pub/gromacs/gromacs-2023.2.tar.gz
tar xvfz gromacs-2023.2.tar.gz
```

Load CUDA, Anaconda and MPI modules,
```
module load cuda/11.8 anaconda/2023a
module load mpi/openmpi-4.1.5
```

Create build and isntall directories,
```
mkdir -p 2023.2/build
mkdir 2023.2/install
cd 2023.2/build
```

Use `cmake` to configure compiling options,
```
cmake ~/gromacs/gromacs-2023.2 -DGMX_MPI=ON -DGMX_GPU=CUDA -DCMAKE_INSTALL_PREFIX=~/gromacs/2023.2-gpu
```

Compile, check and install,
```
make
make check
make install
```

Set up usage enviroenment,
```
source ~/gromacs/2023.2/install/bin/GMXRC
```

