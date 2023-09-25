process TransABySS {
    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path reads_left
    path reads_right
    val sampleName

    output:
    path "transabyss_contigs.fa", emit: contig

    //TODO doesnt seem to take all the cores, runs abyss on one core 😥
    script:
    """
    transabyss --pe $reads_left $reads_right --threads ${task.cpus} --outdir transabyss_results
    mv transabyss_results/transabyss-final.fa transabyss_contigs.fa
    """
}
