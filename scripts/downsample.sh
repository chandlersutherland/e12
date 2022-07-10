#!/bin/bash
#SBATCH --job-name=downsample
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

cd $SCRATCH
singularity run $HOME/programs/gatk_latest.sif for ((i = 1; i <= 5; i++)); do gatk DownsampleSam -I all_aln.bam -O neg_"${i}".bam -P .015625; done

#time for some qc 
DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/neg_control
#first, convert from sam to bam file using samtools view. Then, sort and index each file. 
#With the bam file, I can compute summary statistics and save them in a .csv file 

cd $DIR
echo "sra,mean_read_depth,breadth" > $DIR/mapping_stats.csv

for f in *.bam
do 
	basename=$(basename $f .bam)
	OUTPUT_BAM=$DIR/"${basename}".bam
	echo "beginning ${f}"
	#convert to bam, sort, and index 
	samtools sort -@ $SLURM_NTASKS -T $DIR/temp_stat > $OUTPUT_BAM
	samtools index -@ $SLURM_NTASKS $OUTPUT_BAM
	
	#generate mapping statistics 
	name=$basename
	MEAN_READ_DEPTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++;s+=$3}END{print s/c}')
	BREADTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}')
	echo "${name},${MEAN_READ_DEPTH},${BREADTH}" >> $DIR/mapping_stats.csv
	echo "${name} converted and mapping statistics written to mapping_stats.csv"
done
