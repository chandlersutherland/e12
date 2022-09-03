#!/bin/bash

cd
cd /gatk 

gatk ValidateSamFile -I $INPUT_FILE --MODE SUMMARY 
