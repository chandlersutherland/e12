#!/bin/bash

cd /gatk 

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/pre_processed

#run fixmate 
for f in $INPUT_DIR/*.bam
do 
	echo "fixmating ${f} $(date +%T)" 
	#name sort then fixmate 
	gatk FixMateInformation \
	-I $f
	echo "fixed mate! ${f} $(date +%T)"
done

#validate to be sure 
for f in $INPUT_DIR/*.bam
do 
	echo "validating ${f} $(date +%T)" 
	gatk ValidateSamFile -I $f --MODE SUMMARY
done



