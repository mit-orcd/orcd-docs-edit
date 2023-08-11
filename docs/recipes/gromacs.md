--
tags:
 - Engaging
 - Howto Recipes
---

# Installing and Using GROMACS

## GROMACS on Engaging

### Install GROMACS

Selet a version on the [GROMACS website](https://ftp.gromacs.org/pub/gromacs/). Then dowload and extract the tar ball.
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

Compile, check and install it,
```
make
make check
make install
```

Set up usage enviroenment,
```
source ~/gromacs/2019.6/install/bin/GMXRC
```

