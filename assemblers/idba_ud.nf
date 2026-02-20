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
    tuple val(sample), path("left_reads.fq"), path("right_reads.fq"), emit: unzipped


    script:

    """
    /usr/bin/time -v gunzip -c $reads_left > left_reads.fq
    /usr/bin/time -v gunzip -c $reads_right > right_reads.fq
    """
}


process MergeAndConvert {
    tag "$sample"

    cpus = 1
    memory = '1G'

    input:
    tuple val(sample), path(left_reads), path(right_reads)

    output:
    tuple val(sample), path("merged.fa")                    , emit: merged
    path(time_log_fl)                                       , emit: time_log

    script:
    process_name = "MergeAndConvert"
    time_log_fl = "${sample}_merge_and_convert_time_log.txt"
//TODO: for deployment with container change path
    """
    /usr/bin/time -v /vol/jlab/tlin/software/assemblers/idba/bin/fq2fa --merge $left_reads $right_reads merged.fa 2> $time_log_fl
    
    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}

process IDBA_UD {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(merged_fa)

    output:
    tuple val(sample), path("idba_ud_contigs.fa"), emit: contigs
    path(time_log_fl)                                , emit: time_log


    script:
    process_name = "IDBA_UD"
    time_log_fl = "${sample}_ibda_ud_time_log.txt"

    """
    source /homes/tlin/miniconda3/etc/profile.d/conda.sh
    conda activate idba_ud

    /usr/bin/time -v idba_ud \\
        -l $merged_fa \\
        -o idba_ud \\
        --num_threads ${task.cpus}
    
    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    
    mv idba_ud/contig.fa idba_ud_contigs.fa
    """
}

