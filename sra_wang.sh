#!/bin/bash
#SBATCH --job-name=fastq_download
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=12:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load sra-tools
SCRATCH_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana

for ((i = 186; i <= 248; i++))
	do 
	fasterq-dump -O $SCRATCH_DIR -t $SCRATCH_DIR -p SRR8367$i
done 
case 
