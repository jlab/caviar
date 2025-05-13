process megahit {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(left_reads), path(right_reads)
    
    output:
    path "megahit_contigs.fa", emit: contigs
    path(time_log_fl)                       , emit: time_log

    script:
    process_name = "megahit"
    time_log_fl = "${sample}_megahit_time_log.txt"
    
    """
    /usr/bin/time -v  megahit -1 $left_reads -2 $right_reads -o megahit -t ${task.cpus}  2> $time_log_fl
    mv megahit/final.contigs.fa megahit_contigs.fa

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}
