#!/bin/bash
#SBATCH --job-name=merge
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
module load samtools

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/marked_rg
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/neg_control

#merge!

cd $INPUT_DIR 
FILES=$(ls)

samtools merge -@ $SLURM_NTASKS $OUTPUT_DIR/merged_marked_rg.bam $FILES