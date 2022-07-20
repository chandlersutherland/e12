#!/bin/bash
#SBATCH --job-name=markdup_rg
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load samtools

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/marked_rg

#with our sorted happy files, it's time to run samtools fixmate to prep and then samtools markdup to mark pcr duplicates 

cd $INPUT_DIR 
for f in *_rg.bam
do 
	echo "beginning ${f}"
	#name sort then fixmate 
	samtools sort -n -T $INPUT_DIR/temp -@ $SLURM_NTASKS $INPUT_DIR/"${f}"|\
	samtools fixmate -m -@ $SLURM_NTASKS - - |\
	samtools sort -T $INPUT_DIR/temp2 -@ $SLURM_NTASKS - |\
	samtools markdup -r -T $INPUT_DIR/temp3 -s -@ $SLURM_NTASKS - $OUTPUT_DIR/"${f}"
	echo "finished ${f}"
done
