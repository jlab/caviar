process Trinity {
    tag "$sample"
    container 'quay.io/biocontainers/trinity:2.15.2--pl5321hdcf5f25_0'

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "trinity_contigs.fa"               , emit: contigs
    path(time_log_fl)                       , emit: time_log

    //TODO: find out why i need to swap left and right reads
    //Todo: if i want to spend the effort i could convert the conda environment to native nextflow
    
    //legacy source /vol/jlab/tlin/software/pythonenvs/trinity_dependencies/bin/activate

    script:
    def args = task.ext.args ?: ''
    process_name = "Trinity"
    time_log_fl = "${sample}_trinity_time_log.txt"
    """
    export PATH="/homes/tlin/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/homes/tlin/software/cli_links:/homes/tlin/homebrew/bin:/vol/jlab/bin:/vol/jlab/tlin/software/sratoolkit.3.1.0-ubuntu64/bin:/homes/tlin/edirect:/vol/slurm/bin:/homes/tlin/Projects/jlab-assemblertraining/bin:/vol/software/bin"
    /usr/bin/time -v Trinity --seqType fq --max_memory ${task.memory.toGiga()}G --left $reads_left --right $reads_right \
            --CPU ${task.cpus} --output trinity_out --workdir /var/tmp/trinity_tmp ${args} 2> $time_log_fl
    mv trinity_out.Trinity.fasta trinity_contigs.fa

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}

