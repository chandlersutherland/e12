#!/bin/bash
#SBATCH --job-name=once_through_singleton
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --time=05:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load bwa
module load samtools

#document goal: pump the raw fastq files with rg info through the pipeline, try my darndest to get rid of the weird rg flags!
#also a good rough draft for future all inclusive pipelines 

#define some variables 
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/rg_map_test2/test_09082022
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/all_fastq/fastq_files
REF_GENOME=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa

#This test will be on the singleton SRR8367191, which is derived from the raw files FCHC2TWBBXX_L1_wHAXPI032572-47_1.fq.gz
#and FCHC2TWBBXX_L1_wHAXPI032572-47_2.fq.gz.
#according to my rg file, should have a header of '@RG\tID:HC2TWBBXX.1\tPL:ILLUMINA\tPU:HC2TWBBXX.1.Col17_SL4-2\tSM:SRR8367191\tLB:Col17_SL4-2'
RG=FCHC2TWBBXX_L1_wHAXPI032572-47
accession=SRR8367191

#map with bwa mem. I am not going to save intermediate files, so pipe through to sorted and indexed bam 
bwa mem -t 12 $REF_GENOME $INPUT_DIR/"${accession}"_1.fq $INPUT_DIR/"${accession}"_2.fq |
samtools view -@ $SLURM_NTASKS -b - |\
samtools sort -@ $SLURM_NTASKS -T $OUTPUT_DIR/temp > $OUTPUT_DIR/"${accession}".bam
samtools index -@ $SLURM_NTASKS $OUTPUT_DIR/"${accession}".bam

#add rg 
samtools addreplacerg -@ 20 -r '@RG\tID:HC2TWBBXX.1\tPL:ILLUMINA\tPU:HC2TWBBXX.1.Col17_SL4-2\tSM:SRR8367191\tLB:Col17_SL4-2' -m orphan_only $OUTPUT_DIR/"${accession}".bam > $OUTPUT_DIR/"${accession}".bam

echo "fixmating ${accession}"
#name sort then fixmate, sort again, then markdup  
samtools sort -n -T $INPUT_DIR/temp -@ $SLURM_NTASKS $OUTPUT_DIR/"${accession}".bam |\
samtools fixmate -m -@ $SLURM_NTASKS - - |\
samtools sort -T $INPUT_DIR/temp2 -@ $SLURM_NTASKS - |\
samtools markdup -T $INPUT_DIR/temp3 -s -@ $SLURM_NTASKS - $OUTPUT_DIR/"${accession}".bam

echo "gatk fixmate" 
singularity exec $HOME/programs/gatk_latest.sif gatk FixMateInformation -I $OUTPUT_DIR/"${accession}".bam -ADD_MATE_CIGAR true

echo "validate"
singularity exec $HOME/programs/gatk_latest.sif gatk ValidateSamFile -I $OUTPUT_DIR/"${accession}".bam -MODE SUMMARY

echo "finished"