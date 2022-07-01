#!/bin/bash
#SBATCH --job-name=markdup
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=04:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load samtools

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/marked

#with our sorted happy files, it's time to run samtools fixmate to prep and then samtools markdup to mark pcr duplicates 
 
for ((i = 185; i <= 248; i++))
do 
	echo "beginning SRR8367${i}"
	#name sort then fixmate 
	samtools sort -n -T $INPUT_DIR/temp -@ $SLURM_NTASKS $INPUT_DIR/aln_SRR8367"${i}".bam|\
	samtools fixmate -m -@ $SLURM_NTASKS - - |\
	samtools sort -T $INPUT_DIR/temp2 -@ $SLURM_NTASKS - |\
	samtools markdup -T $INPUT_DIR/temp3 -s -@ $SLURM_NTASKS - $OUTPUT_DIR/markdup_SRR8367"${i}".bam
	echo "finished SRR8367${i}"
done
