#!/bin/bash
#SBATCH --job-name=tester_rg
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
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/rg_map_test2
INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/raw_files/SRR8367185
REF_GENOME=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa

RG1=FCH7NHMBBXX_L1_wHAXPI032499-26
RG2=FCHC2V5BBXX_L2_wHAXPI032499-26

for rg in $RG1 $RG2
do 
	#map with bwa mem. I am going to save intermediate files this round just because who knows what will crash 
	bwa mem -t $SLURM_NTASKS $REF_GENOME $INPUT_DIR/"${rg}"_1.fq $INPUT_DIR/"${rg}"_2.fq > $OUTPUT_DIR/aln_"${rg}".sam

	echo "aligned ${rg}, beginning samtools journey"
	#convert to bam, sort, and index 
	samtools view -@ $SLURM_NTASKS -b $OUTPUT_DIR/aln_"${rg}".sam |\
	samtools sort -@ $SLURM_NTASKS -T $OUTPUT_DIR/temp > $OUTPUT_DIR/sort_"${rg}".bam
	samtools index -@ $SLURM_NTASKS $OUTPUT_DIR/sort_"${rg}".bam

	echo "fixmating ${rg}"
	#name sort then fixmate, sort again, then markdup  
	samtools sort -n -T $INPUT_DIR/temp -@ $SLURM_NTASKS $OUTPUT_DIR/sort_"${rg}".bam |\
	samtools fixmate -m -@ $SLURM_NTASKS - - |\
	samtools sort -T $INPUT_DIR/temp2 -@ $SLURM_NTASKS - |\
	samtools markdup -T $INPUT_DIR/temp3 -s -@ $SLURM_NTASKS - $OUTPUT_DIR/markdup_"${rg}".bam
	
	echo "validate"
	export INPUT_FILE='${OUTPUT_DIR}/markdup_${rg}.bam'
	singularity run $HOME/programs/gatk_latest.sif $HOME/e12/scripts/validate_sam.bash
	echo "${rg} is ready for gatk!"
done 

echo "finished"