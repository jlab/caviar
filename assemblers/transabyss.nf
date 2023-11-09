process TransABySS {
    conda '/vol/jlab/tlin/software/condaenvs/transabyss_dependencies'

    tag "$sample"

    publishDir "results/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "transabyss_contigs.fa", emit: contig

    //TODO doesnt seem to take all the cores, runs abyss on one core 😥
    script:
    """
    source \$(conda info --json | awk '/conda_prefix/ { gsub(/"|,/, "", \$2); print \$2 }')/bin/activate /vol/jlab/tlin/software/condaenvs/transabyss_dependencies
    transabyss --pe $reads_left $reads_right --threads ${task.cpus} --outdir transabyss_results
    mv transabyss_results/transabyss-final.fa transabyss_contigs.fa
    """
}
