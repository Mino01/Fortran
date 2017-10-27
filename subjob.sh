#!/bin/bash
#SBATCH  -N 1
#SBATCH  --tasks-per-node=4
#SBATCH  --exclusive
#SBATCH  -t 00:30:00
#SBATCH  -J jacobi
#SBATCH  -o jacobi_%j.out
#SBATCH  -e jacobi_%j.out

cat $0

mpirun -bind-to core jacobisolver