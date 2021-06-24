nextflow.enable.dsl=2

process eggnog_db_download {

    publishDir "${params.outdir}/dbs" , mode: 'copy'

    output:
    path 'eggnog_db', type: 'dir', emit: eggnog_db

    script:
    """
    mkdir eggnog_db
    download_eggnog_data.py -y --data_dir eggnog_db
    """
}

process eggnog_mapper {
    tag "${id}"

    publishDir "${params.outdir}/eggnog/${id}" , mode: 'copy'

    input:
    tuple val(id), path(seqs)
    path(eggnog_db)
   
    output:
    path "${id}*"
    path "${id}.emapper.annotations", emit: annotations
   
    script:
    """
    mkdir temp
    emapper.py \
        -i ${seqs} \
        -o ${id} \
        -m diamond \
        --itype proteins \
        --temp_dir temp \
        --data_dir ${eggnog_db} \
        --cpu ${task.cpus}
    rm -rf temp
    """
}
