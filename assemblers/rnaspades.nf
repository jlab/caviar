process rnaspades {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "rnaspades_contigs.fa", emit: contigs

    script:
    """
    rnaspades.py -1 $reads_left -2 $reads_right -o rnaspades -t ${task.cpus} -m ${task.memory.toGiga()}
    mv rnaspades/transcripts.fasta rnaspades_contigs.fa
    """
}
