#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { eggnog_mapper } from './modules/eggnog_mapper'
include { prodigal } from './modules/prodigal'

workflow {
    
    Channel
        .fromPath( params.genomes )
        .map { file -> tuple(file.baseName, file) }
        .set { genomes_ch }

    eggnog_db = file(params.eggnog_db, type: 'dir', checkIfExists: true)

    prodigal(genomes_ch)
    eggnog_mapper(prodigal.out.sequences, eggnog_db)
}
