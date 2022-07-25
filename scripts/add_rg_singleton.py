import os 
import pandas as pd 

rg=pd.read_csv('/global/home/users/chandlersutherland/e12/data/singleton_rg.tsv', sep='\t', header=None)

for i in range(0, len(rg)):
    accession=rg.iloc[i,0]
    read_group=rg.iloc[i,1]
    in_file_name=print('/global/scratch/users/chandlersutherland/e12/wang_athaliana/fastq_rg/' + str(accession) + '.sam')
    out_file_name=print('/global/scratch/users/chandlersutherland/e12/wang_athaliana/mapped_reads_rg/' + str(accession) + '_rg.sam')
    !samtools addreplacerg -@ 20 -r str(read_group) -m orphan_only -o out_file_name -i in_file_name
    
