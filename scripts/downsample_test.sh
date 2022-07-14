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
singularity run $HOME/programs/gatk_latest.sif gatk DownsampleSam -I all_aln.bam -O neg_1.bam -P .015625

#time for some qc 
#With the bam file, I can compute summary statistics and save them in a .csv file 

cd $DIR
echo "rep,mean_read_depth,breadth" > $DIR/downsample_mapping_stats.csv
echo "beginning qc" 

MEAN_READ_DEPTH=$(samtools depth -a neg_1.bam | awk '{c++;s+=$3}END{print s/c}')
BREADTH=$(samtools depth -a neg_1.bam | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}')
echo "neg_1,${MEAN_READ_DEPTH},${BREADTH}" >> $DIR/downsample_mapping_stats.csv
echo "$neg_1 mapping statistics written to downsample_mapping_stats.csv"
