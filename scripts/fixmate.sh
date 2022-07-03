#!/bin/bash
#SBATCH --job-name=FixMate
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=08:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

cd

singularity run gatk_latest.sif
cd /gatk 

for ((i = 185; i <= 248; i++))
do 
	echo "beginning SRR8367${i} %T"
	#name sort then fixmate 
	gatk FixMateInformation \
	-I $SCRATCH/e12/wang_athaliana/marked/markdup_SRR8367'${i}'.bam \
	-O $SCRATCH/e12/wang_athaliana/fix_mate/fixmate_SRR8367'${i}'.bam \
	-ADD_MATE_CIGAR true
	echo "fixed mate! SRR8367${i} %T"
done
