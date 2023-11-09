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
    tag "$sample"

    cpus = 2
    memory = '2G'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    tuple val(sample), path("left_reads.fq"), path("right_reads.fq")

    script:
    """
    gunzip -c $reads_left > left_reads.fq
    gunzip -c $reads_right > right_reads.fq
    """
}


process MergeAndConvert {
    tag "$sample"

    cpus = 1
    memory = '1G'

    input:
    tuple val(sample), path(left_reads), path(right_reads)

    output:
    tuple val(sample), path("merged.fa")

    script:
//TODO: for deployment with container change path
    """
    /vol/jlab/tlin/software/assemblers/idba/bin/fq2fa --merge $left_reads $right_reads merged.fa
    """
}

process IDBA_UD {
    publishDir "results/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(merged_fa)

    output:
    tuple val(sample), path("idba_ud_contigs.fa")

    script:
    """
    idba_ud \\
        -l $merged_fa \\
        -o idba_ud \\
        --num_threads ${task.cpus}
    mv idba_ud/contig.fa idba_ud_contigs.fa
    """
}

