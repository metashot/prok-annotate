nextflow.enable.dsl=2

// Params:
//     - outdir
//     - prodigal_mode
process prodigal {
    tag "${id}"

    publishDir "${params.outdir}/prodigal/${id}" , mode: 'copy'

    input:
    tuple val(id), path(genome)
   
    output:
    path "gene.coords.gbk"
    tuple val(id), path ("protein.translations.faa"), emit: sequences

    script:
    """
    prodigal\
        -i $genome \
        -o gene.coords.gbk \
        -a protein.translations.faa \
        -p ${params.prodigal_mode}
    """
}

