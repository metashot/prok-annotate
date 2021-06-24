#!/usr/bin/env python3

import argparse
import os.path

import pandas as pd


parser = argparse.ArgumentParser()
parser.add_argument('-i', '--input', metavar='input', nargs='+',
                    required=True, help='input files', )
parser.add_argument('-s', '--suffix', dest='suffix', required=False,
                    help='filename suffix', default='.emapper.annotations')              
args = parser.parse_args()


def count(input_df, input_id, col):
    output_df = input_df[["#query", col]].copy()
    output_df[col] = output_df.apply(lambda row: row[col].split(','), axis=1)
    output_df = output_df.explode(col).reset_index(drop=True)
    output_df = output_df.groupby([col])[["#query"]].nunique()
    output_df = output_df.rename(columns = {"#query": input_id})
    return output_df


cols = {
    'GOs': 'eggnog_GOs.tsv',
    'EC':  'eggnog_EC.tsv',
    'KEGG_ko': 'eggnog_KEGG_ko.tsv',
    'KEGG_Pathway': 'eggnog_KEGG_Pathway.tsv',
    'KEGG_Module': 'eggnog_KEGG_Module.tsv',
    'KEGG_Reaction': 'eggnog_KEGG_Reaction.tsv',
    'KEGG_rclass': 'eggnog_KEGG_rclass.tsv',
    'BRITE': 'eggnog_BRITE.tsv',
    'KEGG_TC': 'eggnog_KEGG_TC.tsv',
    'CAZy': 'eggnog_CAZy.tsv',
    'BiGG_Reaction': 'eggnog_BiGG_Reaction.tsv',
    'PFAMs': 'eggnog_PFAMs.tsv'
}

seed_ortholog_df = pd.DataFrame()
count_dfs = {}
for col in cols:
    count_dfs[col] = pd.DataFrame()

for input_fn in args.input:
    input_bn = os.path.basename(input_fn)
    input_id = input_bn.split(args.suffix)[0]
    input_df = pd.read_table(input_fn, sep='\t', skiprows=4, skipfooter=3,
        engine='python')
    
    tmp_df = input_df.groupby(["seed_ortholog", "eggNOG_OGs", "max_annot_lvl",
        "COG_category", "Description", "Preferred_name"])[["#query"]].nunique()
    tmp_df = tmp_df.rename(columns = {"#query": input_id})
    seed_ortholog_df = pd.concat([seed_ortholog_df, tmp_df], axis=1,
        join='outer')

    for col in cols:
        tmp_df = count(input_df, input_id, col)
        count_dfs[col] = pd.concat([count_dfs[col], tmp_df], axis=1,
            join='outer')

seed_ortholog_df.fillna(0, inplace=True)
seed_ortholog_df.to_csv('eggnog_seed.tsv', sep='\t', float_format='%.d')

for col in cols:
    count_dfs[col].fillna(0, inplace=True)
    count_dfs[col].to_csv(cols[col], sep='\t', float_format='%.d')