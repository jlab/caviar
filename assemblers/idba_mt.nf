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
    tuple val(sample), path("left_reads.fa"), path("right_reads.fa")  , emit: fasta
    path(time_log_fl)                                                 , emit: time_log

    script:
    process_name = "ConvertToFASTA"
    time_log_fl = "${sample}_convert_to_fasta_time_log.txt"

    """
    /usr/bin/time -v convert_to_fasta.sh $left_reads $right_reads left_reads.fa right_reads.fa \
      2> $time_log_fl

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}

process IDBA_MT {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(hard_filtered_transcripts), path(left_fasta), path(right_fasta), val(read_length), val(insert_size)

    output:
    path "idba_mt_contigs.fa"                        , emit: contigs
    path(time_log_fl)                                , emit: time_log


    script:
    process_name = "IDBA_MT"
    time_log_fl= "${sample}_idba_mt_fasta_time_log.txt"

    """
    /usr/bin/time -v idba-mt \\
        -t $left_fasta \\
        -f $right_fasta \\
        -r ${read_length} \\
        -i ${insert_size} \\
        -c $hard_filtered_transcripts \\
        -O idba_mt_contigs.fa 2> $time_log_fl
    
    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tProcess: \\"$sample\\"" >> $time_log_fl
    """
}



