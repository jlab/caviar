include { UnzipReads; MergeAndConvert } from './idba_ud.nf'
 
workflow ingapCdgPipeline {
    take:
    triplet

    main:
    //these processes need to take tuples
    UnzipReads( triplet )
    MergeAndConvert( UnzipReads.out )
    ingapCdg( MergeAndConvert.out )

}

process ingapCdg {
    tag "$sample"

    publishDir "results/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(merged_fa)

    output:
    path "ingap-cdg_contigs.fa", emit: contigs

    //Todo threads can be doubled
    script:
    """
    ingap-cdg -i $merged_fa -o ingap_cdg_results -n ${task.cpus}
    mv ingap_cdg_results/OutputCDSs/cds.nuc.fas ingap-cdg_contigs.fa
    """
}
