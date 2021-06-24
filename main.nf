#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { prokka } from './modules/prokka'
include { eggnog_db_download; eggnog_mapper } from './modules/eggnog_mapper'
include { kofamscan } from './modules/kofamscan'
include { kofamscan_db_download; merge_anvio; merge_eggnog_mapper; merge_kofamscan } from './modules/utils'
include { anvio_kofam_db_download; anvio_kofam} from './modules/anvio'


workflow {
    
    Channel
        .fromPath( params.genomes )
        .map { file -> tuple(file.baseName, file) }
        .set { genomes_ch }

    // Prokka
    prokka(genomes_ch)

    // eggNOG
    if ( params.run_eggnog ) {
        if (params.eggnog_db == 'none') {
            eggnog_db_download()
            eggnog_db = eggnog_db_download.out.eggnog_db
        }
        else {
            eggnog_db = file(params.eggnog_db, type: 'dir', 
                checkIfExists: true)
        }

        eggnog_mapper(prokka.out.faa, eggnog_db)
        merge_eggnog_mapper(eggnog_mapper.out.annotations.collect())
    }
    
    // KofamScan 
    if ( params.run_kofamscan ) {
        if (params.kofamscan_db == 'none') {
            kofamscan_db_download()
            kofamscan_db = kofamscan_db_download.out.kofamscan_db
        }
        else {
            kofamscan_db = file(params.kofamscan_db, type: 'dir', 
                checkIfExists: true)
        }

        kofamscan(prokka.out.faa, kofamscan_db)
        merge_kofamscan_hits(kofamscan.out.hits.collect())
    }

    // Anvi'o kofam
    if ( params.run_anvio_kofam ) {
        if (params.anvio_kofam_db == 'none') {
            anvio_kofam_db_download()
            anvio_kofam_db = anvio_kofam_db_download.out.anvio_kofam_db
        }
        else {
            anvio_kofam_db = file(params.anvio_kofam_db, type: 'dir', 
                checkIfExists: true)
        }

        anvio_kofam(genomes_ch, anvio_kofam_db)
        merge_anvio(
            anvio_kofam.out.hits.collect(),
            anvio_kofam.out.modules.collect())
    }

}
