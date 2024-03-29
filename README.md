# metashot/prok-annotate workflow

A Nextflow pipeline for the functional annotation of prokaryotic genomes and metagenomes.

Cite as: [![DOI](https://zenodo.org/badge/311277400.svg)](https://zenodo.org/badge/latestdoi/311277400)

[MetaShot Home](https://metashot.github.io/)

## Main features

- Input: prokaryotic contig/genomes in FASTA format;
- Functional annotation using [Prokka](https://github.com/tseemann/prokka);
- Functional annotation through orthology assignment by
  [eggNOG-mapper](https://github.com/eggnogdb/eggnog-mapper) v2 and the [eggNOG
  v5.0](http://eggnog-mapper.embl.de/) database (optional);
- KEGG ortholog assignment by [KofamScan](https://github.com/takaram/kofam_scan)
  and the KOfam database (https://www.genome.jp/tools/kofamkoala/) (optional);
- Estimates KEGG pathway completeness using Anvi'o
  (https://merenlab.org/software/anvio/) (optional);
- Automatic database download.

## Quick start

### Prokka only

1. Install Docker (or Singulariry) and Nextflow (see
   [Dependences](https://metashot.github.io/#dependencies));
2. Start running the analysis (Prokka only, bacteria mode):

   ```bash
   nextflow run metashot/prok-annotate \
     --genomes "data/*.fa" \
     --outdir results
   ```

## Documentation

### Run eggNOG, KofamScan and Anvi'o Kofam
eggNOG, KofamScan and Anvi'o Kofam annotations can be performed by setting
`--run_eggnog`, `--run_kofamscan` and `--run_anvio_kofam` options:

```bash
  nextflow run metashot/prok-annotate \
    --genomes "data/*.fa" \
    --run_eggnog \
    --run_kofamscan \
    --run_anvio_kofam \
    --outdir results
```

EggNOG, KofamScan and Anvi'o Kofam databases will be automatically downloaded
from the Internet and and they will be put in the `dbs` directory in the
`results` folder. If you want to download the databases manually, run the
following lines:

- EggNOG:

  ```bash
  docker run --rm -v /path/to/eggnog_db:/eggnog_db metashot/eggnog-mapper:2.0.1-3 \
    python /eggnog_mapper/download_eggnog_data.py -y --data_dir /eggnog_db
  ```

  Add `--eggnog_db /path/to/eggnog_db` option to the `nextflow run` command.

- KofamScan

  Download KOfam database from ftp://ftp.genome.jp/pub/db/kofam/ and decompress
  it (e.g. into the `/path/to/kofamscan_db` folder:

  ```bash
  mkdir /path/to/kofamscan_db
  curl -s -L ftp://ftp.genome.jp/pub/db/kofam/profiles.tar.gz | \
    tar -zxf - -C /path/to/kofamscan_db
  curl -s -L ftp://ftp.genome.jp/pub/db/kofam/ko_list.gz -o ko_list.gz && \
    gunzip -c ko_list.gz > /path/to/kofamscan_db/ko_list
  ```

  Add `--kofamscan_db /path/to/kofamscan_db` option to the `nextflow run`
  command.

- Anvi'o Kofam

  ```bash
  docker run --rm -v /path/to/anvio_kofam_db:/anvio_kofam_db metashot/metashot/anvio:7-2 \
    anvi-setup-kegg-kofams --kegg-data-dir /anvio_kofam_db
  ```

  Add `--anvio_kofam_db /path/to/anvio_kofam_db` option to the `nextflow run`
  command.

## Metagenomes
For metagenomes, we suggest to run the pipeline using the `--metagenome` option using
EggNOG mapper only: 

```bash
  nextflow run metashot/prok-annotate \
    --genomes "contigs/*.fa" \
    --metagenome \
    --skip_prokka \
    --run_eggnog \
    --eggnog_db_mem \
    --outdir results
```

## Parameters
See the file [`nextflow.config`](nextflow.config) for the complete list of
parameters.

## Output
The files and directories listed below will be created in the output directory
after the pipeline has finished.

### Main
- `prokka`: Prokka outputs ([documentation](https://github.com/tseemann/prokka#output-files));
- `eggnog_*.tsv`: count matrix for each transferred annotation;
- `kofamscan_hits.tsv`: count matrix for KofamScan hits;
- `anvio_kofam_hits.tsv`: count matrix for Anvio Kofam hits;
- `anvio_modules.tsv`: module completeness matrix.

### Secondary
- `eggnog` (if `--run_eggnog`): eggNOG outputs
  ([documentation](https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2));
- `kofamscan` (if `--run_kofamscan`): KofamScan output (`detail` format);
- `anvio` (if `--run_anvio_kofam`): `anvi-estimate-metabolism`
  (https://merenlab.org/software/anvio/help/main/programs/anvi-estimate-metabolism/)
  outputs  for each input genome (`kofam_hits` and `modules` formats). Moreover
  gene calls in FASTA and text format are reported
  (`anvi-get-sequences-for-gene-calls` and `anvi-export-gene-calls`).

## System requirements
Please refer to [System
requirements](https://metashot.github.io/#system-requirements) for the complete
list of system requirements options.
