nextflow.enable.dsl=2


process kofamscan {
    tag "${id}"

    publishDir "${params.outdir}/kofamscan/${id}" , mode: 'copy'

    input:
    tuple val(id), path(seqs)
    path(kofamscan_db)

    output:
    path "${id}.detail.txt"

    script:
    """
    exec_annotation \
        -f detail \
        --cpu ${task.cpus} \
        --tmp-dir tmp \
        -o ${id}.detail.txt \
        -p ${kofamscan_db}/profiles/prokaryote.hal \
        -k ${kofamscan_db}/ko_list \
        ${seqs}

    rm -rf tmp
    """
}

