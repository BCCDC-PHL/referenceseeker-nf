#!/usr/bin/env nextflow

import java.time.LocalDateTime

nextflow.enable.dsl = 2

//include { hash_files } from './modules/hash_files.nf'
//include { pipeline_provenance } from './modules/provenance.nf'
//include { collect_provenance } from './modules/provenance.nf'
//include { quast } from './modules/quast.nf'
//include { parse_quast_report } from './modules/quast.nf'
include { referenceseeker } from './modules/referenceseeker.nf'


workflow {
  ch_start_time = Channel.of(LocalDateTime.now())
  ch_pipeline_name = Channel.of(workflow.manifest.name)
  ch_pipeline_version = Channel.of(workflow.manifest.version)
 
  // ch_pipeline_provenance = pipeline_provenance(ch_pipeline_name.combine(ch_pipeline_version).combine(ch_start_time))

  if (params.samplesheet_input != 'NO_FILE') {
    ch_assemblies = Channel.fromPath(params.samplesheet_input).splitCsv(header: true).map{ it -> [it['ID'], it['ASSEMBLY']] }
  } else {
    ch_assemblies = Channel.fromPath( params.assembly_search_path ).map{ it -> [it.baseName.split('_')[0], it] }.unique{ it -> it[0] }  
  }

  ch_db = Channel.fromPath(params.db)

  main:
  //hash_files(ch_assemblies.combine(Channel.of("assembly-input")))
  //quast(ch_assemblies)
  //parse_quast_report(quast.out.tsv)
  referenceseeker(ch_assemblies.combine(ch_db))

  ch_provenance = referenceseeker.out.provenance
  //ch_provenance = ch_provenance.join(hash_files.out.provenance).map{ it -> [it[0], [it[1]] << it[2]] }
  //ch_provenance = ch_provenance.join(quast.out.provenance).map{ it -> [it[0], it[1] << it[2]] }
  //ch_provenance = ch_provenance.join(ch_assemblies.map{ it -> it[0] }.combine(ch_pipeline_provenance)).map{ it -> [it[0], it[1] << it[2]] }
  //collect_provenance(ch_provenance)
  
}
