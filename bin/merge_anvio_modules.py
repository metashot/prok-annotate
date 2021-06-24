#!/usr/bin/env python3

import argparse
import os.path

import pandas as pd


parser = argparse.ArgumentParser()
parser.add_argument('-i', '--input', metavar='input', nargs='+',
                    required=True, help='input files', )
parser.add_argument('-s', '--suffix', dest='suffix', required=False,
                    help='filename suffix', default='._modules.txt')              
args = parser.parse_args()

compl_df = pd.DataFrame()
for input_fn in args.input:
    input_bn = os.path.basename(input_fn)
    input_id = input_bn.split(args.suffix)[0]
    input_df = pd.read_table(input_fn, sep='\t')
    input_df =  input_df \
        .set_index(["kegg_module",
                    "module_name",
                    "module_class",
                    "module_category",
                    "module_subcategory",
                    "module_definition"])[["module_completeness"]]
    input_df = input_df.rename(columns = {"module_completeness": input_id})
    compl_df = pd.concat([compl_df, input_df], axis=1, join='outer')
    
compl_df.fillna(0, inplace=True)
compl_df.to_csv('anvio_modules.tsv', sep='\t', float_format='%.3f')
