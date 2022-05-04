#!/usr/bin/env python3
__title__="tpm_fpkm_normalization.py"
__purpose__="TMP and FPKM normalization for RNA-seq data."
__author__="Luigui Gallardo-Becerra (bfllg77@gmail.com)"
__date__="23.11.2021"

# Import libraries
import argparse
from io import FileIO
import pandas as pd
from bioinfokit.analys import norm, get_data

# Arguments input:
parser=argparse.ArgumentParser()
parser.add_argument('-i', '--input',
    required=True,
    type=argparse.FileType('r'),
    help="Input file.")
parser.add_argument('-o', '--output',
    required=True,
    help="Output file prefix.")  

args=parser.parse_args()

# Beginning of the script
class Normalization:
    def __init__(self, input, output):
        self.input = input
        self.output = output
        self.table = pd.read_csv(self.input, sep='\t')

    # TPM method
    def tpm(self):
        # Make 'gene' column as index column. Note: gene length must be in bp
        table = self.table.set_index('gene')
        
        # TMP normalization
        nm = norm()
        nm.tpm(df=table, gl='length')
        tpm_table = nm.tpm_norm
        
        # Write output FPKM table
        output_table = str(self.output) + "_tpm.txt"
        tpm_table.to_csv(output_table, sep='\t')

    # FPKM method
    def fpkm(self):
        # Make 'gene' column as index column. Note: gene length must be in bp
        table = self.table.set_index('gene')
        
        # FPKM normalization
        nm = norm()
        nm.rpkm(df=table, gl='length')
        fpkm_table = nm.rpkm_norm
        
        # Write output FPKM table
        output_table = str(self.output) + "_fpkm.txt"
        fpkm_table.to_csv(output_table, sep='\t')

# Execution of script
normalization=Normalization(args.input, args.output)
normalization.tpm()
normalization.fpkm()

# The end!