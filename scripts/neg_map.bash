#!/bin/bash
#SBATCH --job-name=time_2_map_neg
#SBATCH --account=ac_kvkallow
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
module load bwa
module load samtools

#name directories 
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/neg_control
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/neg_control
REF_GENOME=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa

cd $INPUT_DIR
#initialize files 

bwa mem -t $SLURM_NTASKS $REF_GENOME $INPUT_DIR/all_1.fastq $INPUT_DIR/all_2.fastq > $OUTPUT_DIR/all_aln.sam
samtools view -b -@ $SLURM_NTASKS -o all_aln.bam all_aln.sam
 