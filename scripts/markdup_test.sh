#!/bin/bash
#SBATCH --job-name=markdup_rg_test
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:10:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load samtools
module load python 
#try on the otherwise preprocessed data to see if removing -R flag from markdup fixes it 
echo "beginning /global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg/FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam"
#name sort then fixmate 
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg
TEST_FILE=/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg/FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/rg_map_test2

samtools sort -n -T $INPUT_DIR/temp -@ $SLURM_NTASKS $TEST_FILE|\
samtools fixmate -@ $SLURM_NTASKS - $OUTPUT_DIR/fixmate_nom_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam

#samtools sort -n -T $INPUT_DIR/temp -@ $SLURM_NTASKS $TEST_FILE|\
#samtools fixmate -m -r -@ $SLURM_NTASKS - $OUTPUT_DIR/fixmate_r_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam


samtools sort -T $INPUT_DIR/temp2 -@ $SLURM_NTASKS $OUTPUT_DIR/fixmate_nom_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam |\
samtools markdup -T $INPUT_DIR/temp3 -s -@ $SLURM_NTASKS - $OUTPUT_DIR/markdup_cr_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam

#samtools sort -T $INPUT_DIR/temp2 -@ $SLURM_NTASKS $OUTPUT_DIR/fixmate_r_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam |\
#samtools markdup -T $INPUT_DIR/temp3 -s -@ $SLURM_NTASKS - $OUTPUT_DIR/markdup_cr_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam

export INPUT_FILE='${OUTPUT_DIR}/markdup_cr_FCH7NHMBBXX_L1_wHAXPI032499-26_rg.bam'
singularity run $HOME/programs/gatk_latest.sif $HOME/e12/scripts/validate_sam.bash
echo "finished"