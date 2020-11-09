# metashot/prok-annotate

## Introduction
metashot/prok-annotate is a workflow for functional annotation of prokaryotic
contigs/genomes.

## Main features

- Input: prokaryotic contig/genomes in FASTA format;
- Protein-coding gene prediction using
  [Prodigal](https://github.com/hyattpd/Prodigal);
- Functional annotation through orthology assignment by
  [eggNOG-mapper](https://github.com/eggnogdb/eggnog-mapper) v2 and the [eggNOG
  v5.0](http://eggnog-mapper.embl.de/) database.

## Quick start
1. Install [Nextflow](https://www.nextflow.io/) and
   [Docker](https://www.docker.com/);
1. Fetch the eggNOG database:

   ```bash
   docker run --rm -v /path/eggnog_data:/eggnog_data eggnog-mapper \
   python /eggnog_mapper/download_eggnog_data.py -y --data_dir /eggnog_data
   ```
1. Start running the analysis:

  ```bash
  nextflow run metashot/prok-annotate \
    --genomes "data/*.fa" \
    --eggnog_db /path/eggnog_data \
    --outdir results
  ```

See the file [`nextflow.config`](nextflow.config) for the complete list of
parameters.

## Output
Several files and directories will be created in the `results` folder.

### Main outputs
- `prodigal`: the output of eggNOG-mapper
  [documentation](https://github.com/hyattpd/prodigal/wiki/understanding-the-prodigal-output).
- `eggnog`: the output of Prodigal
  [documentation](https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2).
 
## System requirements
Each step in the pipeline has a default set of requirements for number of CPUs,
memory and time. For some of the steps in the pipeline, if the job exits with an
error it will automatically resubmit with higher requests (see
[`process.config`](process.config)).

You can customize the compute resources that the pipeline requests by either:
- setting the global parameters `--max_cpus`, `--max_memory` and
  `--max_time`, or
- creating a [custom config
  file](https://www.nextflow.io/docs/latest/config.html#configuration-file)
  (`-c` or `-C` parameters), or
- modifying the [`process.config`](process.config) file.

## Reproducibility
We recommend to specify a pipeline version when running the pipeline on your
data with the `-r` parameter:

```bash
  nextflow run metashot/kraken2 -r 1.0.0
    ...
```

Moreover, this workflow uses the docker images available at
https://hub.docker.com/u/metashot/ for reproducibility. You can check the
version of the software used in the workflow by opening the file
[`process.config`](process.config). For example `container =
metashot/kraken2:2.0.9-beta-6` means that the version of kraken2 is the
`2.0.9-beta` (the last number, 6, is the metashot release of this container).

## Singularity
If you want to use [Singularity](https://singularity.lbl.gov/) instead of Docker,
comment the Docker lines in [`nextflow.config`](nextflow.config) and add the following:

```nextflow
singularity.enabled = true
singularity.autoMounts = true
```

## Credits
This workflow is maintained by Davide Albanese and Claudio Donati at the [FEM's
Unit of Computational
Biology](https://www.fmach.it/eng/CRI/general-info/organisation/Chief-scientific-office/Computational-biology).
