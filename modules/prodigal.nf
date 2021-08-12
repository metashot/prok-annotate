nextflow.enable.dsl=2

process prodigal {
    tag "${id}"

    publishDir "${params.outdir}/prodigal" , mode: 'copy'

    input:
    tuple val(id), path(genome)

    output:
    path "${id}/*"
    tuple val(id), path ("${id}.faa"), emit: faa

    script:
    param_metagenome = params.metagenome ? 'meta' : 'single'
    """
    prodigal \
        -i genome \
        -o ${id}.gbk \
        -a ${id}.faa \
        -p $param_metagenome
    """
}

