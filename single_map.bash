#!/bin/bash
#SBATCH --job-name=time_2_map_test
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=5:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load bwa

OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/mapped_reads
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/fastq_files
REF_GENOME=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa

#bwa index $REF_GENOME 
 
bwa mem -n $SLURM_NTASKS $REF_GENOME $INPUT_DIR/SRR8367185_1.fastq $INPUT_DIR/SRR8367185_2.fastq > $OUTPUT_DIR/aln_SRR8367185.sam
