#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=2:00:00
#SBATCH --output=output/%x.%j.out


module purge 
module load julia/1.11.1 

julia gamma_run.jl examples 13001 14000
