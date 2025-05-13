process rnaspades {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "rnaspades_contigs.fa"             , emit: contigs
    path(time_log_fl)                       , emit: time_log


    script:
    def args = task.ext.args ?: ''

    process_name = "rnaspades"
    time_log_fl = "${sample}_rnaspades_time_log.txt"

    """
    /usr/bin/time -v rnaspades.py -1 $reads_left -2 $reads_right -o rnaspades -t ${task.cpus} -m ${task.memory.toGiga()} ${args}  2> $time_log_fl
    mv rnaspades/transcripts.fasta rnaspades_contigs.fa

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}
