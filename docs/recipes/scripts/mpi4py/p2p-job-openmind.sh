#!/bin/bash -l
#SBATCH -N 1
#SBATCH -n 8

module load openmind/anaconda/3-2022.05

mpirun -np $SLURM_NTASKS python p2p-send-recv.py
mpirun -np $SLURM_NTASKS python p2p-array.py