nextflow.enable.dsl=2

process anvio_kofam_db_download {

    publishDir "${params.outdir}/dbs" , mode: 'copy'

    output:
    path 'anvio_kofam_db', type: 'dir', emit: anvio_kofam_db

    script:
    """
    anvi-setup-kegg-kofams --kegg-data-dir ./anvio_kofam_db
    """
}

process anvio_kofam {
    tag "${id}"

    publishDir "${params.outdir}/anvio/${id}" , mode: 'copy'

    input:
    tuple val(id), path(genome)
    path(anvio_kofam_db)
   
    output:
    path "${id}.*"
   
    script:
    """
    anvi-script-reformat-fasta \
        ${genome} \
        -o contigs.fa \
        -l 0 \
        --simplify-names \
        --seq-type NT

    anvi-gen-contigs-database \
        -f contigs.fa \
        -o contigs.db

    anvi-get-sequences-for-gene-calls \
        -c contigs.db \
        -o ${id}.gene_calls.fa

    anvi-export-gene-calls \
        -c contigs.db \
        --gene-caller prodigal \
        -o ${id}.gene_calls.txt

    anvi-run-kegg-kofams \
        -c contigs.db \
        --kegg-data-dir ${anvio_kofam_db} \
        -T ${task.cpus}

    anvi-estimate-metabolism \
        -c contigs.db \
        --kegg-data-dir ${anvio_kofam_db} \
        -O ${id}. \
        --kegg-output-modes kofam_hits,modules

    rm -rf contigs.fa contigs.db 
    """
}