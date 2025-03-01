include { UnzipReads; IDBA_UD; MergeAndConvert } from './idba_ud.nf'

workflow IdbaUdMTPipeline {
    take:
    left_reads
    right_reads

    main:
    UnzipReads( left_reads, right_reads )
    MergeAndConvert( UnzipReads.out.left_unzipped, UnzipReads.out.right_unzipped )
    IDBA_UD( MergeAndConvert.out.merged_fa )
    ConvertToFASTA( UnzipReads.out.left_unzipped, UnzipReads.out.right_unzipped )
    IDBA_MT( ConvertToFASTA.out.left_fasta, ConvertToFASTA.out.right_fasta, MergeAndConvert.out.merged_fa )

    emit:
    IDBA_MT.out.contigs
}



process ConvertToFASTA {
    tag "$sample"

    cpus = 1
    memory = '1G'

    input:
    tuple val(sample), path(left_reads), path(right_reads)

    output:
    tuple val(sample), path("left_reads.fa"), path("right_reads.fa")

    script:
    """
    awk 'NR%4 == 1{print ">" substr(\$0, 2)} NR%4 == 2{print}' $left_reads > left_reads.fa
    awk 'NR%4 == 1{print ">" substr(\$0, 2)} NR%4 == 2{print}' $right_reads > right_reads.fa
    """
}

process IDBA_MT {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(hard_filtered_transcripts), path(left_fasta), path(right_fasta), val(read_length), val(insert_size)

    output:
    path "idba_mt_contigs.fa", emit: contigs

    script:
    """
    idba-mt \\
        -t $left_fasta \\
        -f $right_fasta \\
        -r ${read_length} \\
        -r ${insert_size} \\
        -c $hard_filtered_transcripts \\
        -O idba_mt_contigs.fa
    """
}



