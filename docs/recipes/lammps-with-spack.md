---
tags:
 - Engaging
 - Howto Recipes
 - spack
 - LAMMPS
 - Rocky Linux
---

# Example of building custom LAMMPS configuration using spack

## About LAMMPS
LAMMPS is a fully open-source molecular dynamics simulator. 
Its name is an acronym from [Large-scale Atomic/Molecular Massively Parallel Simulator](https://www.lammps.org).
It is widely used in materials research. LAMMPS is actively developed
[here](https://github.com/lammps) by a team of collaborators led by researchers from Sandia National Laboratory and 
Temple University. LAMMPS has many different compilation options that can be used to activate different technical and scientific features.

## Compiling and running a custom LAMMPS using Spack

In this recipe we look at setting up a custom configuration of LAMMPS using the [Spack](https://github.com/spack/spack) system. The recipe shows
how to compile LAMMPS in a way that uses an existing Spack install of core tools like MPI and GPU CUDA libraries and tools. The recipe
The detailed steps, that can be executed in an interactive Slurm session, are explained 
below. 

!!! note "Prerequisites"

    This example assumes you have access to a Slurm partition and are working with a Rocky Linux environment.

#### 1. Configure an instance of Spack in a directory under your account

Spack is a tool for compiling programs in a uniform away. It is designed for use by regular accounts on a computer. It does not need any administrative privileges.
Here it will be used to compile the LAMMPS software. 

A first step to using Spack is to download the software from its Github repository using the following command.

```bash
git clone https://github.com/spack/spack.git
```

Next we configure Spack, setting the it ot use standard tools that have already been built from a pre-exisiting location.

??? note
    The compilation example shows using Spack in a way that uses pre-existing _upstream_ Spack built software 
    from another location. This can be useful on a cluster computer where a central team may have already installed and configured some standard foundation software tools, 
    such as a compiler and high-performance tools for using GPUs and/or for parallel communication. Configuring these foundation software tools can involve seaprate
    testing and performance settings, so using a pre-installed foundation is generally useful. To make a Spack _upstream_ work reliably we need to use the same tag of 
    Spack as used in the upstream and provide a path name to the upstream isntallation.

To configure Spack use the following sequence of commands.

```bash
# Switch to build location
mkdir -p /nobackup1/users/${USER}/lammps-testing
cd /nobackup1/users/${USER}/lammps-testing

# Set any .spack files to be local to this test
export SPACK_USER_CONFIG_PATH=`pwd`/user_config

# Download spack and set version to match upstream Spack
git clone https://github.com/spack/spack.git
(
 cd spack
 git checkout -b v0.19.1 v0.19.1
)

# Set upstream and cp reference config files for upstream
mkdir -p `pwd`/user_config
cp /software/spack/etc/spack/*yaml user_config
cat  > user_config/upstreams.yaml << EOF
upstreams:
  orcd-rcf-2023:
   install_tree: /software/spack-20230328/opt/spack
EOF

source spack/share/spack/setup-env.sh
```


#### 2. Check what extra software Spack will build for our LAMMPS install 

Spack will download and compile extra software that it needs to compile LAMMPS. 
It is good to check what software Spack selects to build to make sure that 
the _upstream_ libraries are being used as epxected.

To check the software Spack will build use the commad.

```bash
spack spec -I -L lammps%gcc@12.2.0 fftw_precision=single +intel ~kim +asphere +class2 +kspace +manybody +molecule +opt +replica +rigid +granular +openmp-package +openmp ^openmpi
```

this command produces a large amount of output that is described below.


??? example "Output from spack spec -I -L query"
    The`spack spec -I -L` command produces a series of lines that show the versions of all the software packages that
    are needed for some software. The first column in these lines show symbols that denote whether an existing 
    version will be used ( [^], or [e] ) or a new version needs to be downloaded and installed ( [+] ). 

    If there are many packages marked with the [+] it can be useful to check what options you have selected for the software
    you are trying to build. Changing these options can affect how Spack decides which packages needs to be
    built frm scratch.
    ```
    Input spec
    --------------------------------
     -   lammps%gcc@12.2.0+asphere+class2+granular+intel~kim+kspace+manybody+molecule+openmp+openmp-package+opt+replica+rigid fftw_precision=single
     -       ^openmpi

    Concretized
    --------------------------------
    [+]  murlzo54sqte5xacqcusa6pdmuv7lbju  lammps@20220623%gcc@12.2.0~adios+asphere~atc~awpmd~bocs~body~bpm~brownian~cg-sdk+class2~colloid~colvars~compress~coreshell~cuda~cuda_mps~dielectric~diffraction~dipole~dpd-basic~dpd-meso~dpd-react~dpd-smooth~drude~eff~electrode~exceptions~extra-compute~extra-dump~extra-fix~extra-molecule~extra-pair~fep+ffmpeg+granular~h5md+intel~interlayer~ipo+jpeg~kim~kokkos+kspace~latboltz~latte+lib~machdyn~manifold+manybody~mc~meam~mesont~mgpt~misc~ml-iap~ml-snap~mliap~mofff+molecule~molfile+mpi~mpiio~netcdf~opencl+openmp+openmp-package+opt~orient~peri~phonon~plugin~plumed+png~poems~ptm~python~qeq~qtb~reaction~reaxff+replica+rigid~shock~smtbq~snap~sph~spin~srd~tally~uef~user-adios~user-atc~user-awpmd~user-bocs~user-brownian~user-cgsdk~user-colvars~user-diffraction~user-dpd~user-drude~user-eff~user-fep~user-h5md~user-intel~user-lb~user-manifold~user-meamc~user-mesodpd~user-mesont~user-mgpt~user-misc~user-mofff~user-molfile~user-netcdf~user-omp~user-phonon~user-plumed~user-ptm~user-qtb~user-reaction~user-reaxc~user-sdpd~user-smd~user-smtbq~user-sph~user-tally~user-uef~user-yaff~voronoi~yaff build_system=cmake build_type=RelWithDebInfo fftw_precision=single lammps_sizes=smallbig arch=linux-rocky8-x86_64
    [^]  7kayesehfqsqbz3anbeuesrhg7jivrh7      ^cmake@3.24.3%gcc@12.2.0~doc+ncurses+ownlibs~qt build_system=generic build_type=Release arch=linux-rocky8-x86_64
    [^]  c5ckfq5br4hzxtjpinax3wmblpxcwccq          ^ncurses@6.3%gcc@12.2.0~symlinks+termlib abi=none build_system=autotools arch=linux-rocky8-x86_64
    [^]  teeyrkysydy6st2gjgmlilsqhdvhytxg          ^openssl@1.1.1s%gcc@12.2.0~docs~shared build_system=generic certs=mozilla arch=linux-rocky8-x86_64
    [^]  acak7eo66b264d5tnlrgdsqquriqzikw              ^ca-certificates-mozilla@2022-10-11%gcc@12.2.0 build_system=generic arch=linux-rocky8-x86_64
    [+]  o2bzn3dn2oxv3z2gxmjdbqdrg2cujdub      ^ffmpeg@4.4.1%gcc@12.2.0~X~avresample+bzlib~drawtext+gpl~libaom~libmp3lame~libopenjpeg~libopus~libsnappy~libspeex~libssh~libvorbis~libvpx~libwebp~libx264~libzmq~lzma~nonfree~openssl~sdl2+shared+version3 build_system=autotools arch=linux-rocky8-x86_64
    [+]  da4dhnudfslxlganozpe6kgegttb5wqt          ^alsa-lib@1.2.3.2%gcc@12.2.0~python build_system=autotools arch=linux-rocky8-x86_64
    [^]  y2uodljjpotqgdgf4ync654ow6zq3yui          ^bzip2@1.0.8%gcc@12.2.0~debug~pic+shared build_system=generic arch=linux-rocky8-x86_64
    [^]  lmmbcwxrpcrrdzfv46acihazdbchects              ^diffutils@3.6%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  y7hkdyocmeei7gipuzq6dauwoscds65d          ^libiconv@1.16%gcc@12.2.0 build_system=autotools libs=shared,static arch=linux-rocky8-x86_64
    [+]  up3oys25bdxvv5n2cdvhyaodk4pjm46t          ^yasm@1.3.0%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  xzya3i6ni4zkbycrk2bnbwba3dtfjpag          ^zlib@1.2.13%gcc@12.2.0+optimize+pic+shared build_system=makefile arch=linux-rocky8-x86_64
    [^]  qiaruimvw6zu2h4f5eolqom7tixem6vk      ^fftw@3.3.10%gcc@12.2.0+mpi+openmp~pfft_patches build_system=autotools precision=double,float arch=linux-rocky8-x86_64
    [^]  ig3drj7aya7pibjynlbjdki4wj26nvq3      ^libjpeg-turbo@2.1.3%gcc@12.2.0 build_system=generic arch=linux-rocky8-x86_64
    [^]  t4dj6jrogzp26ylmy7meqdm5uerw2vou          ^nasm@2.15.05%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  bpm4irmoa3ly7mn2v2eezr4nvoxt57uz      ^libpng@1.6.37%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  3r4zaihkaqj2gmfvtzk4adiu3qxlzgj5      ^openmpi@4.1.4%gcc@12.2.0~atomics+cuda~cxx~cxx_exceptions~gpfs~internal-hwloc~java+legacylaunchers~lustre~memchecker+pmi+romio+rsh~singularity+static+vt+wrapper-rpath build_system=autotools cuda_arch=none fabrics=ucx schedulers=slurm arch=linux-rocky8-x86_64
    [^]  loulnd3xxa433rvdvtzu67nb4muiyxqt          ^cuda@12.1.0%gcc@12.2.0~allow-unsupported-compilers~dev build_system=generic arch=linux-rocky8-x86_64
    [^]  avncq4uc2k673jnoxdeqijalhwxfu452              ^libxml2@2.10.1%gcc@12.2.0~python build_system=autotools arch=linux-rocky8-x86_64
    [^]  a7ikzndwlj3et447m7ycfy3rjnllhr6c                  ^xz@5.2.7%gcc@12.2.0~pic build_system=autotools libs=shared,static arch=linux-rocky8-x86_64
    [^]  a56oj35bkhqi7rpsxyrzv2cvjhk6f4nl          ^hwloc@2.8.0%gcc@12.2.0~cairo+cuda~gl~libudev+libxml2~netloc+nvml~oneapi-level-zero~opencl+pci~rocm build_system=autotools cuda_arch=none libs=shared,static arch=linux-rocky8-x86_64
    [^]  id32hkaz34tj6rm436wmiaoes7jtjomj              ^libpciaccess@0.16%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  74pwk3n734nymhilw7fvcjhkdzr22xa5                  ^util-macros@1.19.3%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  n3atoewxkrcnzrv35ggcghde7uknwnc2          ^numactl@2.0.14%gcc@12.2.0 build_system=autotools patches=4e1d78c,62fc8a8,ff37630 arch=linux-rocky8-x86_64
    [^]  llmf6eoq46fjuega6mzjc6kjpeta2abx              ^autoconf@2.69%gcc@12.2.0 build_system=autotools patches=35c4492,7793209,a49dd5b arch=linux-rocky8-x86_64
    [^]  t3rctjlwqpmn5x433eeeusphmtypv6g7              ^automake@1.16.5%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  lmcpaypsio2xylqqkhyis36sem4q2uqx              ^libtool@2.4.7%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  fqwqfqqkhvsw7oklwjgsgfz5ksfantur              ^m4@1.4.18%gcc@12.2.0+sigsegv build_system=autotools patches=3877ab5,fc9b616 arch=linux-rocky8-x86_64
    [^]  o3v3w2aysw3bxl2ioig7bu4nl54xb6ln          ^openssh@8.0p1%gcc@12.2.0+gssapi build_system=autotools arch=linux-rocky8-x86_64
    [^]  d345fqycp52qf5jf35in4tkz3bg7en2t          ^perl@5.36.0%gcc@12.2.0+cpanm+shared+threads build_system=generic arch=linux-rocky8-x86_64
    [^]  ehlkmyphsdbfkgvt6wtznpvs6gpelo4a              ^berkeley-db@18.1.40%gcc@12.2.0+cxx~docs+stl build_system=autotools patches=26090f4,b231fcc arch=linux-rocky8-x86_64
    [^]  medv6udj2ovi3p7sjpffxzfl4t4yb6i2              ^gdbm@1.23%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  5zhrz242nlulabfgalogdv6vgxfnigae                  ^readline@8.1.2%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  wxuqfjdqv4bjudl2aixkqcowfz35q62u          ^pkgconf@1.8.0%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  d7f7fwzoomvmc6hwotduhlzmdoc6oz7o          ^pmix@4.1.2%gcc@12.2.0~docs+pmi_backwards_compatibility~restful build_system=autotools arch=linux-rocky8-x86_64
    [^]  dnasb7atyzwlagnyyrplzk5if6efrfbe              ^libevent@2.1.12%gcc@12.2.0+openssl build_system=autotools arch=linux-rocky8-x86_64
    [^]  w4bduhiz53fpkwuucvzayhpj7dquy6wa          ^slurm@22.05.6%gcc@12.2.0~gtk~hdf5~hwloc~mariadb+pmix+readline~restd build_system=autotools sysconfdir=PREFIX/etc arch=linux-rocky8-x86_64
    [^]  xxapazpv4rciyeuajxom5vfll4djhakq          ^ucx@1.13.1%gcc@12.2.0~assertions~backtrace_detail+cma+cuda+dc~debug+dm+examples+gdrcopy+ib_hw_tm~java+knem~logging+mlx5_dv+openmp+optimizations~parameter_checking+pic+rc+rdmacm~rocm+thread_multiple~ucg+ud+verbs~vfs+xpmem build_system=autotools cuda_arch=none libs=shared,static opt=3 patches=32fce32 simd=auto arch=linux-rocky8-x86_64
    [^]  6mhshpnmk5eluz3l7kkiiwaijetaugaz              ^gdrcopy@2.3%gcc@12.2.0 build_system=makefile patches=c5efec1 arch=linux-rocky8-x86_64
    [^]  lf6nroe2ungmj4jfktllyn3lb634phai              ^knem@1.1.4%gcc@12.2.0+hwloc build_system=autotools patches=78885a0 arch=linux-rocky8-x86_64
    [^]  y7we5jx3cbxrdetx4czervl3x5u6sw4d              ^rdma-core@41.0%gcc@12.2.0~ipo build_system=cmake build_type=RelWithDebInfo arch=linux-rocky8-x86_64
    [^]  tf5fu6kqufhtdnnt4v3xyzpyomqlod3x                  ^libnl@3.3.0%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  c4tgrq23hiatbdxkxdsvuzure2uu3igf                      ^bison@3.8.2%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  n4ex34zvvefzgb3kujwzymjcjx7bqy72                      ^flex@2.6.3%gcc@12.2.0+lex~nls build_system=autotools arch=linux-rocky8-x86_64
    [^]  jofcfnbajncj3a3ooylnkls4zrg2gd7u                          ^findutils@4.6.0%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  imomhs5czwwjpjwka3pchqoqmvhkybta                  ^py-docutils@0.19%gcc@12.2.0 build_system=python_pip arch=linux-rocky8-x86_64
    [^]  ru3kxolfjtu3dna4ou6ebnd34xxqdgug                      ^py-pip@22.2.2%gcc@12.2.0 build_system=generic arch=linux-rocky8-x86_64
    [^]  2ze2pnic7bshbeu635yejl6325b57bfh                      ^py-setuptools@65.5.0%gcc@12.2.0 build_system=generic arch=linux-rocky8-x86_64
    [^]  2fvi4pmz4mnqmufgbdusfg3jbxq2xkrn                      ^py-wheel@0.37.1%gcc@12.2.0 build_system=generic arch=linux-rocky8-x86_64
    [^]  flipoyygqdyq56ytifzzitgmb7x4bdno                      ^python@3.10.8%gcc@12.2.0+bz2+ctypes+dbm~debug+libxml2+lzma~nis~optimizations+pic+pyexpat+pythoncmd+readline+shared+sqlite3+ssl~tix~tkinter~ucs4+uuid+zlib build_system=generic patches=0d98e93,7d40923,f2fd060 arch=linux-rocky8-x86_64
    [^]  fw7viptexxob2jlhoimbbx2iuelorefg                          ^expat@2.4.8%gcc@12.2.0+libbsd build_system=autotools arch=linux-rocky8-x86_64
    [^]  wem5x2oesmhxmfp7x63sgdop57ribigd                              ^libbsd@0.11.5%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  jxvqhjl7uir2utgpdxzxho744wnbyicj                                  ^libmd@1.0.4%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  srssurbwe76knqj3m2a2g3yl6htki75r                          ^gettext@0.21.1%gcc@12.2.0+bzip2+curses+git~libunistring+libxml2+tar+xz build_system=autotools arch=linux-rocky8-x86_64
    [^]  4phps4fxpvnorsqhbbizp34nmxgcbhlv                              ^tar@1.30%gcc@12.2.0 build_system=autotools zip=pigz arch=linux-rocky8-x86_64
    [^]  ag3cenfsq7igpp33kkdgs5l6llm7mfaa                          ^libffi@3.4.2%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  uvuc44zwmae3ypmqvjrpymleierkahwj                          ^sqlite@3.39.4%gcc@12.2.0+column_metadata+dynamic_extensions+fts~functions+rtree build_system=autotools arch=linux-rocky8-x86_64
    [^]  f36megz6i272yo6gqj2h72byzupu2u3f                          ^util-linux-uuid@2.38.1%gcc@12.2.0 build_system=autotools arch=linux-rocky8-x86_64
    [^]  omne2gv2jqp4wmdqfnb6wfozhda6mznn              ^xpmem@2.6.5-36%gcc@12.2.0+kernel-module build_system=autotools patches=1a2660a,6be8c5f,7529939 arch=linux-rocky8-x86_64
    ```

Assuming the `spack spec` command does not show that a large number of unexpected dependencies will be 
built, then the command `spack install` can be used to build the software.

#### 3. Compile and install LAMMPS

To compile and build LAMMPS once the spack specification is 

```bash
spack spec install lammps%gcc@12.2.0 fftw_precision=single +intel ~kim +asphere +class2 +kspace +manybody +molecule +opt +replica +rigid +granular +openmp-package +openmp ^openmpi
```

this command will produce output showing progress and generate an executable `lmp` program file when it 
completes.

#### 4. Running LAMMPS

Once LAMMPS has been built, simulations can be carried out using the `lmp` program.
The following script shows an example Slurm job that executes a simulation using the Spack LAMMPS installation shown.

```bash
#!/bin/bash
#!/bin/bash
#SBATCH -N 1
#SBATCH -p sched_mit_orcd
#SBATCH --exclusive
#
#

echo "Start: "`date`
hostname
lscpu
cd /nobackup1c/users/${USER}/lammps-testing
export SPACK_USER_CONFIG_PATH=`pwd`/user_config

source spack/share/spack/setup-env.sh

spack load lammps
which lmp

/bin/rm in.rhodo.scaled
/bin/rm data.rhodo
wget https://raw.githubusercontent.com/lammps/lammps/develop/bench/in.rhodo.scaled
wget https://raw.githubusercontent.com/lammps/lammps/develop/bench/data.rhodo

export NP=$(nproc)
mpirun -np ${NP} --map-by core --bind-to core lmp -var x 8 -var y 8 -var z 8 -in in.rhodo.scaled -sf omp -pk omp 1

echo "End: "`date`
```

??? example Example LAMMPS output
     LAMMPS (23 Jun 2022)
     OMP_NUM_THREADS environment is not set. Defaulting to 1 thread. (src/src/comm.cpp:98)
       using 1 OpenMP thread(s) per MPI task
     using multi-threaded neighbor list subroutines
     using multi-threaded neighbor list subroutines
     Reading data file ...
       orthogonal box = (-27.5 -38.5 -36.3646) to (27.5 38.5 36.3615)
       4 by 8 by 4 MPI processor grid
       reading atoms ...
       32000 atoms
       reading velocities ...
       32000 velocities
       scanning bonds ...
       4 = max bonds/atom
       scanning angles ...
       8 = max angles/atom
       scanning dihedrals ...
       18 = max dihedrals/atom
       scanning impropers ...
       2 = max impropers/atom
       reading bonds ...
       27723 bonds
       reading angles ...
       40467 angles
       reading dihedrals ...
       56829 dihedrals
       reading impropers ...
       1034 impropers
     Finding 1-2 1-3 1-4 neighbors ...
       special bond factors lj:    0        0        0       
       special bond factors coul:  0        0        0       
          4 = max # of 1-2 neighbors
         12 = max # of 1-3 neighbors
         24 = max # of 1-4 neighbors
         26 = max # of special neighbors
       special bonds CPU = 0.011 seconds
       read_data CPU = 2.852 seconds
     Replicating atoms ...
       orthogonal box = (-27.5 -38.5 -36.3646) to (412.5 577.5 545.4442)
       4 by 8 by 4 MPI processor grid
       16384000 atoms
       14194176 bonds
       20719104 angles
       29096448 dihedrals
       529408 impropers
     Finding 1-2 1-3 1-4 neighbors ...
       special bond factors lj:    0        0        0       
       special bond factors coul:  0        0        0       
          4 = max # of 1-2 neighbors
         12 = max # of 1-3 neighbors
         24 = max # of 1-4 neighbors
         26 = max # of special neighbors
       special bonds CPU = 0.414 seconds
       replicate CPU = 1.160 seconds
     Finding SHAKE clusters ...
       827904 = # of size 2 clusters
      1860096 = # of size 3 clusters
       382464 = # of size 4 clusters
      2167296 = # of frozen angles
       find clusters CPU = 0.224 seconds
     PPPM initialization ...
       using 12-bit tables for long-range coulomb (src/src/kspace.cpp:342)
       G vector (1/distance) = 0.24521748
       grid = 192 250 240
       stencil order = 5
       estimated absolute RMS force accuracy = 0.042505564
       estimated relative force accuracy = 0.00012800424
       using single precision FFTW3
       3d grid and FFT values/proc = 127465 96000
     Generated 2278 of 2278 mixed pair_coeff terms from arithmetic mixing rule
     Last active /omp style is kspace_style pppm/omp
     Neighbor list info ...
       update every 1 steps, delay 5 steps, check yes
       max neighbors/atom: 2000, page size: 100000
       master list distance cutoff = 12
       ghost atom cutoff = 12
       binsize = 6, bins = 74 103 97
       1 neighbor lists, perpetual/occasional/extra = 1 0 0
       (1) pair lj/charmm/coul/long/omp, perpetual
           attributes: half, newton on, omp
           pair build: half/bin/newton/omp
           stencil: half/bin/3d
           bin: standard
     Setting up Verlet run ...
       Unit style    : real
       Current step  : 0
       Time step     : 2
     Per MPI rank memory allocation (min/avg/max) = 474.8 | 475.2 | 475.5 Mbytes
     ------------ Step              0 ----- CPU =            0 (sec) -------------
     TotEng   = -12982067.8140 KinEng   =  10979753.6175 Temp     =       299.0273 
     PotEng   = -23961821.4315 E_bond   =   1299452.9334 E_angle  =   5591743.5948 
     E_dihed  =   2668434.6878 E_impro  =    109317.9317 E_vdwl   =  -1181626.0687 
     E_coul   = 103991193.7841 E_long   = -136440338.2946 Press    =      -148.6868 
     Volume   = 157693457.1520
     ------------ Step             50 ----- CPU =      71.9645 (sec) -------------
     TotEng   = -12968333.4738 KinEng   =  11008585.3549 Temp     =       299.8125 
     PotEng   = -23976918.8287 E_bond   =   1265564.5807 E_angle  =   5548389.0103 
     E_dihed  =   2682753.7530 E_impro  =    116287.8102 E_vdwl   =  -1020413.6793 
     E_coul   = 103874278.6508 E_long   = -136443778.9543 Press    =       238.7597 
     Volume   = 157712315.3857
     ------------ Step            100 ----- CPU =     146.7313 (sec) -------------
     TotEng   = -12948011.3076 KinEng   =  11054762.8499 Temp     =       301.0701 
     PotEng   = -24002774.1575 E_bond   =   1314890.4683 E_angle  =   5520457.6514 
     E_dihed  =   2661664.1153 E_impro  =    110960.4410 E_vdwl   =   -972029.7085 
     E_coul   = 103802332.6863 E_long   = -136441049.8112 Press    =        11.4791 
     Volume   = 157765159.5585
     Loop time of 146.731 on 128 procs for 100 steps with 16384000 atoms
     
     Performance: 0.118 ns/day, 203.794 hours/ns, 0.682 timesteps/s
     98.5% CPU use with 128 MPI tasks x 1 OpenMP threads
     
     MPI task timing breakdown:
     Section |  min time  |  avg time  |  max time  |%varavg| %total
     ---------------------------------------------------------------
     Pair    | 95.91      | 97.23      | 99.421     |   8.9 | 66.26
     Bond    | 4.1898     | 4.4685     | 4.6336     |   3.5 |  3.05
     Kspace  | 11.902     | 14.256     | 15.701     |  24.0 |  9.72
     Neigh   | 19.24      | 19.289     | 19.34      |   0.5 | 13.15
     Comm    | 1.9089     | 2.2363     | 2.8188     |  12.9 |  1.52
     Output  | 0.0025599  | 0.0026735  | 0.0028835  |   0.1 |  0.00
     Modify  | 7.4504     | 8.648      | 9.5588     |  15.0 |  5.89
     Other   |            | 0.6015     |            |       |  0.41
     
     Nlocal:         128000 ave      128000 max      128000 min
     Histogram: 128 0 0 0 0 0 0 0 0 0
     Nghost:         109934 ave      109937 max      109930 min
     Histogram: 32 0 32 0 0 0 0 32 0 32
     Neighs:    4.81125e+07 ave 4.83216e+07 max  4.7899e+07 min
     Histogram: 8 8 12 18 16 20 16 12 10 8
     
     Total # of neighbors = 6.1583993e+09
     Ave neighs/atom = 375.87887
     Ave special neighs/atom = 7.431875
     Neighbor list builds = 11
     Dangerous builds = 0
     Total wall time: 0:02:36
     End: Thu Oct 26 15:16:19 EDT 2023
