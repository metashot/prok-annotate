# prok-annotate

metashot/prok-annotate is a workflow for functional annotation of prokaryotic
contigs/genomes.

- [MetaShot Home](https://metashot.github.io/)

## Main features

- Input: prokaryotic contig/genomes in FASTA format;
- Functional annotation using [Prokka](https://github.com/tseemann/prokka);
- Functional annotation through orthology assignment by
  [eggNOG-mapper](https://github.com/eggnogdb/eggnog-mapper) v2 and the [eggNOG
  v5.0](http://eggnog-mapper.embl.de/) database (optional);
- KEGG ortholog assignment by [KofamScan](https://github.com/takaram/kofam_scan)
  and the KOfam database (https://www.genome.jp/tools/kofamkoala/) (optional).

## Quick start

1. Install Docker (or Singulariry) and Nextflow (see
   [Dependences](https://metashot.github.io/#dependencies));
2. Start running the analysis (Prokka only, bacteria mode):

   ```bash
   nextflow run metashot/prok-annotate \
     --genomes "data/*.fa" \
     --outdir results
   ```

### eggNOG

1. Fetch the eggNOG database:

   ```bash
   docker run --rm -v /path/to/eggnog_data:/eggnog_data metashot/eggnog-mapper:2.0.1-3 \
     python /eggnog_mapper/download_eggnog_data.py -y --data_dir /eggnog_data
   ```
1. Start running the analysis (Prokka + eggNOG):

   ```bash
   nextflow run metashot/prok-annotate \
     --genomes "data/*.fa" \
     --run_eggnog true \
     --eggnog_db /path/to/eggnog_data \
     --outdir results
   ```

### KofamScan

1. Download KOfam database from ftp://ftp.genome.jp/pub/db/kofam/ and decompress
   it (e.g. into the `./kofam_data` folder).

1. Start running the analysis (Prokka + KofamScan):

   ```bash
   nextflow run metashot/prok-annotate \
     --genomes "data/*.fa" \
     --run_kofamscan true \
     --kofamscan_profile ./kofam_data/profiles/prokaryote.hal \
     --kofamscan_ko_list ./kofam_data/ko_list \
     --outdir results
   ```

  Note that `kofamscan_profile` can be a directory (e.g.
  `./kofam_data/profiles/`), `.hmm` (e.g. `./kofam_data/profiles/K00001.hmm`)
  file, or a `.hal` (e.g. `./kofam_data/profiles/prokaryote.hal`) file (see
  https://github.com/takaram/kofam_scan/tree/v1.3.0#profiles).

### Prokka + eggNOG + KofamScan

1. Download the eggNOG and KOfam databases (see above).

1. Start running the analysis

  ```bash
   nextflow run metashot/prok-annotate \
     --genomes "data/*.fa" \
     --run_eggnog true \
     --run_kofamscan true \
     --eggnog_db eggnog_data \
     --kofamscan_profile ./kofam_data/profiles/prokaryote.hal \
     --kofamscan_ko_list ./kofam_data/ko_list \
     --outdir results
   ```

## Parameters
See the file [`nextflow.config`](nextflow.config) for the complete list of
parameters.

## Output
The files and directories listed below will be created in the `results` directory
after the pipeline has finished.

- `prokka`: Prokka outputs for each input genome
  [documentation](https://github.com/hyattpd/prodigal/wiki/understanding-the-prodigal-output).
- `eggnog` (if `--run_eggnog true`): eggNOG outputs for each input genome
  [documentation](https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2).
- `kofamscan (if `--run_kofamscan true`): KofamScan output for each input
  genome, both `detail` and `mapper` formats are reported.

## System requirements
Please refer to [System
requirements](https://metashot.github.io/#system-requirements) for the complete
list of system requirements options.
