process rnaspades {
    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path reads_left
    path reads_right
    val sampleName

    output:
    path "rnaspades_contigs.fa", emit: contigs

    script:
    """
    rnaspades.py -1 $reads_left -2 $reads_right -o rnaspades -t ${task.cpus} -m ${task.memory.toGiga()}
    mv rnaspades/transcripts.fasta rnaspades_contigs.fa
    """
}
