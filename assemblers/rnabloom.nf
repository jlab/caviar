process rnabloom {

    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path left_reads
    path right_reads
    val sampleName

    output:
    path "rnabloom_contigs.fa", emit: contigs

    script:
    """
    rnabloom \\
        -left $left_reads \\
        -right $right_reads \\
        --revcomp-left \\
        -t ${task.cpus} rnabloom.transcripts.fa\\
        -outdir rnabloom
    mv rnabloom/rnabloom.transcripts.fa rnabloom_contigs.fa
    """
}
