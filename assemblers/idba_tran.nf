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

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(merged_fa)

    output:
    tuple val(sample), path("ibda_tran_contigs.fa")  , emit: contigs
    path(time_log_fl)                                , emit: time_log


    script:
    process_name = "IDBA_TRAN"
    time_log_fl = "${sample}_ibda_tran_time_log.txt"

    """
    /usr/bin/time -v idba_tran -l $merged_fa -o idba_tran_results --num_threads ${task.cpus} 2> $time_log_fl

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    
    mv idba_tran_results/contig.fa ibda_tran_contigs.fa
    """
}
