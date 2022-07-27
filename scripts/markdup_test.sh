#!/bin/bash
#SBATCH --job-name=markdup_rg_test
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=01:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

#try on the otherwise preprocessed data to see if removing -R flag from markdup fixes it 
echo "beginning /global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg/FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam"
#name sort then fixmate 
$INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg
$TEST_FILE=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg/FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam
$OUTPUT_DIR/global/scratch/users/chandlersutherland/e12/wang_athaliana/rg_map_test/markdup_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam

samtools sort -n -T $INPUT_DIR/temp -@ $SLURM_NTASKS $TEST_FILE|\
samtools fixmate -m -@ $SLURM_NTASKS - - |\
samtools sort -T $INPUT_DIR/temp2 -@ $SLURM_NTASKS - |\
samtools markdup -T $INPUT_DIR/temp3 -s -@ $SLURM_NTASKS - $OUTPUT_DIR/"${f}"
echo "finished"
done