#!/bin/bash
#SBATCH --job-name=downsample_test
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=4:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
module load samtools

DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/neg_control

cd $DIR
singularity run $HOME/programs/gatk_latest.sif gatk DownsampleSam -I all_aln.bam -O neg_2.bam -P .015625
echo "neg 2 complete" 
singularity run $HOME/programs/gatk_latest.sif gatk DownsampleSam -I all_aln.bam -O neg_3.bam -P .015625
echo "neg 3 complete"
singularity run $HOME/programs/gatk_latest.sif gatk DownsampleSam -I all_aln.bam -O neg_4.bam -P .015625
echo "neg 4 complete"
singularity run $HOME/programs/gatk_latest.sif gatk DownsampleSam -I all_aln.bam -O neg_5.bam -P .015625
echo "neg 5 complete" 

#time for some qc 
#With the bam file, I can compute summary statistics and save them in a .csv file 

cd $DIR
for f in neg_*.bam
do 
	basename=$(basename $f .bam)
	OUTPUT_BAM=$DIR/"${basename}".bam
	echo "beginning ${f}"
	#generate mapping statistics 
	name=$basename
	MEAN_READ_DEPTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++;s+=$3}END{print s/c}')
	BREADTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}')
	echo "${name},${MEAN_READ_DEPTH},${BREADTH}" >> $DIR/mapping_stats.csv
	echo "${name} converted and mapping statistics written to mapping_stats.csv"
done
