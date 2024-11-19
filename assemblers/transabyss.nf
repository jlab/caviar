process TransABySS {
    //conda '/vol/jlab/tlin/software/condaenvs/transabyss_dependencies'
    container 'quay.io/biocontainers/transabyss:2.0.1--pyh864c0ab_7'
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "transabyss_contigs.fa", emit: contig

    //TODO doesnt seem to take all the cores, runs abyss on one core 😥
    script:
    """
    export PATH="/homes/tlin/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/homes/tlin/software/cli_links:/homes/tlin/homebrew/bin:/vol/jlab/bin:/vol/jlab/tlin/software/sratoolkit.3.1.0-ubuntu64/bin:/homes/tlin/edirect:/vol/slurm/bin:/homes/tlin/Projects/jlab-assemblertraining/bin:/vol/software/bin"
    transabyss --pe $reads_left $reads_right --threads ${task.cpus} --outdir transabyss_results
    mv transabyss_results/transabyss-final.fa transabyss_contigs.fa
    """
}
