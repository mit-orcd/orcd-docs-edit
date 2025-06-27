-8<-- [start:module]
module load miniforge
-8<-- [end:module]

-8<-- [start:install]
conda create -n mpi
source activate mpi
conda install mpi4py numpy
-8<-- [end:install]