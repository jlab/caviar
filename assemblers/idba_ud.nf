workflow IdbaUdPipeline {
    take:
    left_reads
    right_reads

    main:
    UnzipReads( left_reads, right_reads )
    MergeAndConvert( UnzipReads.out.left_unzipped, UnzipReads.out.right_unzipped )
    IDBA_UD( MergeAndConvert.out.merged_fa )

    emit:
    IDBA_UD.out.idba_ud_results
}

process UnzipReads {
    cpus = 2
    memory = '2G'

    input:
    path left_reads_gz
    path right_reads_gz

    output:
    path "left_reads.fq", emit: left_unzipped
    path "right_reads.fq", emit: right_unzipped

    script:
    """
    gunzip -c $left_reads_gz > left_reads.fq
    gunzip -c $right_reads_gz > right_reads.fq
    """
}


process MergeAndConvert {
    cpus = 1
    memory = '1G'

    input:
    path left_reads
    path right_reads

    output:
    path "merged.fa", emit: merged_fa

    script:
//TODO: for deployment with container change path
    """
    /vol/jlab/tlin/software/assemblers/idba/bin/fq2fa --merge $left_reads $right_reads merged.fa
    """
}

process IDBA_UD {
    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path merged_fa
    val sampleName

    output:
    path "idba_ud_contigs.fa", emit: idba_ud_results

    script:
    """
    idba_ud \\
        -l $merged_fa \\
        -o idba_ud \\
        --num_threads ${task.cpus}
    mv idba_ud/contig.fa idba_ud_contigs.fa
    """
}

