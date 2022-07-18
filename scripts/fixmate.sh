#!/bin/bash

cd /gatk 

RG1=FCH7NHMBBXX_L1_wHAXPI032499-26
RG2=FCHC2V5BBXX_L2_wHAXPI032499-26

INPUT_DIR=/global/scratch/users/chandlersutherland/e12/wang_athaliana/rg_map_test2

#run fixmate 
for rg in $RG1 $RG2
do 
	echo "fixmating ${rg}" date +%T
	#name sort then fixmate 
	gatk FixMateInformation \
	-I $INPUT_DIR/markdup_"${rg}".bam \
	-O $INPUT_DIR/fixmate_"${rg}".bam 
	echo "fixed mate! ${rg}" date +%T
done

#merge the files 
java -jar picard.jar MergeSamFiles \
      I=$INPUT_DIR/fixmate_"${RG1}".bam \
      I=$INPUT_DIR/fixmate_"${RG2}".bam \
      O=$INPUT_DIR/SRR8367185_merge.bam


gatk ValidateSamFile -I $INPUT_DIR/SRR8367185_merge.bam 

