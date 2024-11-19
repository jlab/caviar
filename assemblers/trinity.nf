process Trinity {
    tag "$sample"
    container 'quay.io/biocontainers/trinity:2.15.2--pl5321hdcf5f25_0'

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "trinity_contigs.fa", emit: contigs

    //TODO: find out why i need to swap left and right reads
    //Todo: if i want to spend the effort i could convert the conda environment to native nextflow
    
    //legacy source /vol/jlab/tlin/software/pythonenvs/trinity_dependencies/bin/activate

    script:
    """
    export PATH="/homes/tlin/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/homes/tlin/software/cli_links:/homes/tlin/homebrew/bin:/vol/jlab/bin:/vol/jlab/tlin/software/sratoolkit.3.1.0-ubuntu64/bin:/homes/tlin/edirect:/vol/slurm/bin:/homes/tlin/Projects/jlab-assemblertraining/bin:/vol/software/bin"
    Trinity --seqType fq --max_memory ${task.memory.toGiga()}G --left $reads_left --right $reads_right \
            --CPU ${task.cpus} --output trinity_out --workdir /var/tmp/trinity_tmp
    mv trinity_out.Trinity.fasta trinity_contigs.fa
    """
}

