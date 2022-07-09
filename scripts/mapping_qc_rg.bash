#!/bin/bash
#SBATCH --job-name=mapping_qc
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=06:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load samtools

#do it for the mapped read group reads 
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/mapped_reads_rg
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg
#first, convert from sam to bam file using samtools view. Then, sort and index each file. 
#With the bam file, I can compute summary statistics and save them in a .tsv file 

#echo "sra,mean_read_depth,breadth,prop" > $OUTPUT_DIR/mapping_stats.csv

diff=$(grep -Fxvf $OUTPUT_DIR/already_mapped.txt $INPUT_DIR/all_files.txt)
cd $INPUT_DIR 
for f in $diff
do 
	basename=$(basename $f .sam)
	OUTPUT_BAM=$OUTPUT_DIR/"${basename}".bam
	echo "beginning ${f}"
	#convert to bam, sort, and index 
	samtools view -@ $SLURM_NTASKS -b $INPUT_DIR/"${basename}".sam |\
	samtools sort -@ $SLURM_NTASKS -T $OUTPUT_DIR/temp > $OUTPUT_BAM
	samtools index -@ $SLURM_NTASKS $OUTPUT_BAM
	
	#generate mapping statistics 
	name=$basename
	MEAN_READ_DEPTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++;s+=$3}END{print s/c}')
	BREADTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}')
	PROP=$(samtools flagstat $OUTPUT_BAM | awk -F "[(|%]" 'NR == 3 {print $2}')
	echo "${name},${MEAN_READ_DEPTH},${BREADTH},${PROP}" >> $OUTPUT_DIR/mapping_stats.csv
	echo "${name} converted and mapping statistics written to mapping_stats.csv"
done

