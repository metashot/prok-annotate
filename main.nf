#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { prokka } from './modules/prokka'
include { eggnog_mapper } from './modules/eggnog_mapper'
include { kofamscan } from './modules/kofamscan'

workflow {
    
    Channel
        .fromPath( params.genomes )
        .map { file -> tuple(file.baseName, file) }
        .set { genomes_ch }

    prokka(genomes_ch)

    if ( params.run_eggnog ) {
        eggnog_db = file(params.eggnog_db, type: 'dir', checkIfExists: true)
        eggnog_mapper(prokka.out.faa, eggnog_db)
    }
    
    if ( params.run_kofamscan ) {
        kofamscan_profile = file(params.kofamscan_profile, type: 'any',
            checkIfExists: true)
        kofamscan_ko_list = file(params.kofamscan_ko_list, type: 'file',
            checkIfExists: true)
        kofamscan(prokka.out.faa, kofamscan_profile, kofamscan_ko_list)
    }
}
