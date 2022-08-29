#!/bin/bash

cd /gatk 

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/pre_processed

#run fixmate 

for f in $INPUT_DIR/marked_neg_*.bam
do 
	echo "fixmating ${f} $(date +%T)" 
	#name sort then fixmate 
	gatk FixMateInformation \
	-I $f -ADD_MATE_CIGAR true
	#no output means it should overwrite, which is fine in this case since raw files are copied elsewhere
	echo "fixed mate! ${f} $(date +%T)"
done

#validate to be sure 
for f in $INPUT_DIR/*.bam
do 
	echo "validating ${f} $(date +%T)" 
	gatk ValidateSamFile -I $f --MODE SUMMARY
done



