#!/bin/bash

cd /gatk 

for ((i = 185; i <= 248; i++))
do 
	echo "beginning SRR8367${i}" date +%T
	#name sort then fixmate 
	gatk FixMateInformation \
	-I $SCRATCH/e12/wang_athaliana/marked/markdup_SRR8367"${i}".bam \
	-O $SCRATCH/e12/wang_athaliana/fix_mate/fixmate_SRR8367"${i}".bam \
	-ADD_MATE_CIGAR true
	echo "fixed mate! SRR8367${i}" date +%T
done
