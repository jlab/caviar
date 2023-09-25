include { UnzipReads; MergeAndConvert } from './idba_ud.nf'
 
workflow ingapCdgPipeline {
    take:
    left_reads
    right_reads
    sampleName

    main:
    UnzipReads( left_reads, right_reads )
    MergeAndConvert( UnzipReads.out.left_unzipped, UnzipReads.out.right_unzipped )
    ingapCdg( MergeAndConvert.out.merged_fa, sampleName )

}

process ingapCdg {
    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path merged_fa
    val sampleName

    output:
    path "ingap-cdg_contigs.fa", emit: contigs

    //Todo threads can be doubled
    script:
    """
    ingap-cdg -i $merged_fa -o ingap_cdg_results -n ${task.cpus}
    mv ingap_cdg_results/OutputCDSs/cds.nuc.fas ingap-cdg_contigs.fa
    """
}
