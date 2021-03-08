nextflow.enable.dsl=2

process eggnog_db_download {

    publishDir "${params.outdir}/dbs" , mode: 'copy'

    output:
    path 'eggnog_db', type: 'dir', emit: eggnog_db

    script:
    """
    mkdir eggnog_db
    python /eggnog_mapper/download_eggnog_data.py -y --data_dir eggnog_db
    """
}

process eggnog_mapper {
    tag "${id}"

    publishDir "${params.outdir}/eggnog/${id}" , mode: 'copy'

    input:
    tuple val(id), path(seqs)
    path(eggnog_db)
   
    output:
    path "eggnog*"
   
    script:
    """  
    python /eggnog_mapper/emapper.py \
        -i ${seqs} \
        --output eggnog \
        -m diamond \
        --data_dir ${eggnog_db} \
        --cpu ${task.cpus}
    """
}
