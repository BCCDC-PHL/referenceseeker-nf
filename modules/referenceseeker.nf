process referenceseeker {

    tag { sample_id }

    publishDir params.versioned_outdir ? "${params.outdir}/${sample_id}/${params.pipeline_short_name}-v${params.pipeline_minor_version}-output" : "${params.outdir}/${sample_id}", mode: 'copy', pattern: "${sample_id}_referenceseeker.tsv"

    input:
    tuple val(sample_id), path(assembly), path(db)

    output:
    tuple val(sample_id), path("${sample_id}_referenceseeker.tsv"), emit: referenceseeker
    tuple val(sample_id), path("${sample_id}_referenceseeker_provenance.yml"), emit: provenance
    
    script:
    """
    printf -- "- process_name: referenceseeker\\n" > ${sample_id}_referenceseeker_provenance.yml
    printf -- "  tool_name: referenceseeker\\n  tool_version: \$(referenceseeker --version | cut -d ' ' -f 2)\\n" >> ${sample_id}_referenceseeker_provenance.yml
    referenceseeker \
      --threads ${task.cpus} \
      ${db} \
      ${assembly} > ${sample_id}_referenceseeker.tsv
    """
}

