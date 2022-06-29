#!/bin/bash
#SBATCH --job-name=mapping_qc
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
module load samtools

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/mapped_reads
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted
#first, convert from sam to bam file using samtools view. Then, sort and index each file. 
#With the bam file, I can compute summary statistics and save them in a .tsv file 

echo "sra,mean_read_depth,breadth,prop" > $OUTPUT_DIR/mapping_stats.csv
 
for ((i = 185; i <= 248; i++))
do 
	OUTPUT_BAM=$OUTPUT_DIR/aln_SRR8367"${i}".bam
	echo "beginning SRR8367${i}"
	#convert to bam, sort, and index 
	samtools view -@ $SLURM_NTASKS -b $INPUT_DIR/aln_SRR8367"${i}".sam |\
	samtools sort -@ $SLURM_NTASKS > $OUTPUT_BAM
	samtools index -@ $SLURM_NTASKS $OUTPUT_BAM
	
	#generate mapping statistics 
	SRA=SRR8367"${i}"
	MEAN_READ_DEPTH=samtools depth -a $OUTPUT_BAM | awk '{c++;s+=$3}END{print s/c}'
	BREADTH=samtools depth -a $OUTPUT_BAM | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}'
	PROP=samtools flagstat $OUTPUT_BAM | awk -F "[(|%]" 'NR == 3 {print $2}'
	echo "${SRA},${MEAN_READ_DEPTH},${BREADTH},${PROP}" >> $OUTPUT_DIR/mapping_stats.csv
	echo "SRR8367${i} converted and mapping statistics written to mapping_stats.csv"
done