nextflow.enable.dsl=2


process kofamscan {
    tag "${id}"

    publishDir "${params.outdir}/kofamscan/${id}" , mode: 'copy'

    input:
    tuple val(id), path(seqs)
    path(kofamscan_profile)
    path(kofamscan_ko_list)

    output:
    path "${id}.detail.txt"
    path "${id}.mapper.txt"

    script:
    """
    exec_annotation \
        -f detail \
        --cpu ${task.cpus} \
        --tmp-dir tmp \
        -o ${id}.detail.txt \
        -p ${kofamscan_profile} \
        -k ${kofamscan_ko_list} \
        ${seqs}

    exec_annotation \
        -f mapper \
        --cpu ${task.cpus} \
        --tmp-dir tmp \
        --reannotation \
        -o ${id}.mapper.txt \
        -p ${kofamscan_profile} \
        -k ${kofamscan_ko_list} \
        ${seqs}

    rm -rf tmp
    """
}

