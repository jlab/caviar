process Trinity {

    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path reads_left
    path reads_right
    val sampleName

    output:
    path "trinity_contigs.fa", emit: contigs

    //Todo: if i want to spend the effort i could convert the conda environment to native nextflow
    script:
    """
    source /vol/jlab/tlin/software/pythonenvs/trinity_dependencies/bin/activate
    Trinity --seqType fq --max_memory ${task.memory.toGiga()}G --left $reads_left --right $reads_right \
            --CPU ${task.cpus} --output trinity_out --workdir /var/tmp/trinity_tmp
    mv trinity_out.Trinity.fasta trinity_contigs.fa
    """
}

