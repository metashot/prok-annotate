nextflow.enable.dsl=2

process kofamscan_db_download {

    publishDir "${params.outdir}/dbs" , mode: 'copy'

    output:
    path 'kofamscan_db', type: 'dir', emit: kofamscan_db

    script:
    """
    mkdir kofamscan_db

    curl -s -L ftp://ftp.genome.jp/pub/db/kofam/profiles.tar.gz | \
        tar -zxf - -C kofamscan_db

    curl -s -L ftp://ftp.genome.jp/pub/db/kofam/ko_list.gz -o ko_list.gz && \
        gunzip -c ko_list.gz > kofamscan_db/ko_list
    """
}