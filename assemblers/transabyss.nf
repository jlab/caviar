process TransABySS {
    //container 'quay.io/biocontainers/transabyss:1.5.5--1'
    tag "$sample"
    cache false


    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "transabyss_contigs.fa"            , emit: contig
    path(time_log_fl)                       , emit: time_log

    //TODO doesnt seem to take all the cores, runs abyss on one core 😥
    script:
    //export PATH="/homes/tlin/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/homes/tlin/software/cli_links:/homes/tlin/homebrew/bin:/vol/jlab/bin:/vol/jlab/tlin/software/sratoolkit.3.1.0-ubuntu64/bin:/homes/tlin/edirect:/vol/slurm/bin:/homes/tlin/Projects/jlab-assemblertraining/bin:/vol/software/bin"
    def args = task.ext.args ?: ''
    process_name = "TransABySS"
    time_log_fl = "${sample}_transabyss_time_log.txt"
    """
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate transabyss
    
    /usr/bin/time -v transabyss --pe $reads_left $reads_right --threads ${task.cpus} --outdir transabyss_results ${args}  > $time_log_fl
    mv transabyss_results/transabyss-final.fa transabyss_contigs.fa

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}
