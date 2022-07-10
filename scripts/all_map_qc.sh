#!/bin/bash
#SBATCH --job-name=all_map_qc
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

OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/neg_control
cd $INPUT_DIR

samtools view -b -@ $SLURM_NTASKS all_aln.sam |\
samtools sort -@ $SLURM_NTASKS -T $OUTPUT_DIR/temp > all_aln.bam
samtools index -@ $SLURM_NTASKS all_aln.bam

$OUTPUT_BAM=all_aln.bam

echo "sra,mean_read_depth,breadth" > $OUTPUT_DIR/mapping_stats.csv
MEAN_READ_DEPTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++;s+=$3}END{print s/c}')
BREADTH=$(samtools depth -a $OUTPUT_BAM | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}')

echo "all,${MEAN_READ_DEPTH},${BREADTH}" >> $OUTPUT_DIR/mapping_stats.csv
echo "all_aln.bam converted and mapping statistics written to mapping_stats.csv"