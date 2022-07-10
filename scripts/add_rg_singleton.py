import os 
import pandas as pd 

rg=pd.read_csv('/global/home/users/chandlersutherland/e12/data/singleton_rg_3.tsv', sep='\t', header=None)

for i in range(0, len(rg)):
    accession=rg.iloc[i,0]
    read_group=str(rg.iloc[i,1])
    in_file_name=str('/global/scratch/users/chandlersutherland/e12/wang_athaliana/bam_sorted_rg/' + str(accession) + '.bam')
    out_file_name=str('/global/scratch/users/chandlersutherland/e12/wang_athaliana/mapped_reads_rg/' + str(accession) + '_rg.bam')
    os.system("samtools addreplacerg -@ 20 -r "+read_group+" -m orphan_only -o "+out_file_name+" "+in_file_name)
    
    