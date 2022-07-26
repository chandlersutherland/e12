#!/bin/bash

cd
cd /gatk 

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/pre_processed

for f in $INPUT_DIR/*.bam
do 
	gatk ValidateSamFile -I $f --MODE SUMMARY 
	echo "${f} validated"
done 
