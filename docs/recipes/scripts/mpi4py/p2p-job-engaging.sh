#!/bin/bash -l
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p mit_normal

module load miniforge
module load openmpi/4.1.4

mpirun -np $SLURM_NTASKS python p2p-send-recv.py

mpirun -np $SLURM_NTASKS python p2p-array.py