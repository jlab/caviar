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
    tag "$sample"

    publishDir "results/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(merged_fa)

    output:
    tuple val(sample), path("ibda_tran_contigs.fa")

    script:
    """
    idba_tran -l $merged_fa -o idba_tran_results --num_threads ${task.cpus}
    mv idba_tran_results/contig.fa ibda_tran_contigs.fa
    """
}
