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
module load bwa

#name directories 
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/mapped_reads_rg
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/fastq_rg
REF_GENOME=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa

#already indexed, so shouldn't have to again 
#bwa index $REF_GENOME 

cd $INPUT_DIR
#initialize files 
#echo "" > basename.txt 
echo "" > rg_basename.txt

#because the raw files and the sra files have different codes, doing separately 
#for f in *.fastq
#	do basename=$(basename $f .fastq | sed 's/..$//')
#	echo $basename>>basename.txt 
#done 	

for f in *.fq
	do rg_basename=$(basename $f .fq | sed 's/..$//')
	echo $rg_basename>>rg_basename.txt

file_name=$(cat basename.txt | sort -u) 
done 

#for i in $file_name
#	do bwa mem -t $SLURM_NTASKS $REF_GENOME $INPUT_DIR/"${i}"_1.fastq $INPUT_DIR/"${i}"_2.fastq > $OUTPUT_DIR/"${i}".sam
#done	

rg_file_name=$(cat rg_basename.txt | sort -u) 

for i in $rg_file_name
	do bwa mem -t $SLURM_NTASKS $REF_GENOME $INPUT_DIR/"${i}"_1.fq $INPUT_DIR/"${i}"_2.fq > $OUTPUT_DIR/"${i}".sam
done
