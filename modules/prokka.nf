nextflow.enable.dsl=2

process prokka {
    tag "${id}"

    publishDir "${params.outdir}/prokka" , mode: 'copy'

    input:
    tuple val(id), path(genome)

    output:
    path "${id}/*"
    tuple val(id), path ("${id}/${id}.faa"), emit: faa

    script:
    param_metagenome = params.metagenome ? '--metagenome' : ''
    """
    prokka \
        $genome \
        --outdir ${id} \
        --prefix ${id} \
        --kingdom ${params.prokka_kingdom} \
        $param_metagenome \
        --cpus ${task.cpus} \
        --centre X --compliant
    """
}

