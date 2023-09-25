include { UnzipReads; MergeAndConvert } from './idba_ud.nf'

workflow IdbaTranPipeline {
    take:
    left_reads
    right_reads

    main:
    UnzipReads( left_reads, right_reads )
    MergeAndConvert( UnzipReads.out.left_unzipped, UnzipReads.out.right_unzipped )
    IDBA_TRAN( MergeAndConvert.out.merged_fa )

    emit:
    IDBA_TRAN.out.contigs
}

process IDBA_TRAN {
    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path merged_fa
    val sampleName

    output:
    path "ibda_tran_contigs.fa", emit: contigs

    script:
    """
    idba_tran -l $merged_fa -o idba_tran_results
    mv idba_tran_results/contig.fa ibda_tran_contigs.fa
    """
}
