#!/bin/bash
#SBATCH --job-name=fastq_download
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=15:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

## download the sra files for wang 2019 recursively. This is about half but in total it took like 30 hours  

module load python
module load sra-tools
SCRATCH_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana

for ((i = 221; i <= 248; i++))
	do 
	fasterq-dump --threads $SLURM_NTASKS -O $SCRATCH_DIR -t $SCRATCH_DIR -p SRR8367$i
done 
