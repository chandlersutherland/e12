#!/bin/bash
#SBATCH --job-name=time_2_map
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

module load python
#module load sra-tools
module load bwa

OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/mapped_reads_rg
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/fastq_rg
REF_GENOME=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa

#bwa index $REF_GENOME 

cd $INPUT_DIR
echo "" > basename.txt 
for f in *.fastq
	do basename=$(basename $f .fastq | sed 's/..$//')
	echo $basename>>basename.txt 
done 	

file_name=$(cat basename.txt | sort -u) 

for i in $file_name
	do bwa mem -t $SLURM_NTASKS $REF_GENOME $INPUT_DIR/"${i}"_1.fastq $INPUT_DIR/"${i}"_2.fastq > $OUTPUT_DIR/"${i}".sam
done	