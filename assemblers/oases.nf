workflow OasesPipeline {
    take:
    tuple

    main:
    Velveth(tuple)
    Velvetg(Velveth.out.dir)
    Oases(Velvetg.out.graph)
}

process Velveth {
    tag "$sample"
    publishDir "${params.result_dir}/assembler/${sample}", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    tuple val(sample), path("Assem")                 , emit: dir
    path(time_log_fl)                                , emit: time_log

    script:
    process_name = "velveth"
    time_log_fl = "${sample}_velveth_time_log.txt"

    """
    /usr/bin/time -v velveth Assem 31 -shortPaired -fastq.gz -separate $reads_left $reads_right  2> $time_log_fl

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}

//TODO: check whether the contig is already the final velvet output 
process Velvetg {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/${sample}", mode: 'copy'

    input:
    tuple val(sample), path(assem_dir)

    output:
    tuple val(sample), path(assem_dir)               , emit: graph
    path(time_log_fl)                                , emit: time_log


    script:
    process_name = "velvetg"
    time_log_fl = "${sample}_velvetg_time_log.txt"

    """
    /usr/bin/time -v /vol/jlab/tlin/software/assemblers/oases/velvet/velvetg $assem_dir -read_trkg yes 2> $time_log_fl

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}

process Oases {
    tag "$sample"


    publishDir "${params.result_dir}/assembler/${sample}", mode: 'copy'

    input:
    tuple val(sample), path(assem_dir)

    output:
    tuple val(sample), path("oases_contigs.fa")      , emit: contigs
    path(time_log_fl)                                , emit: time_log


    script:
    process_name = "oases"
    time_log_fl = "${sample}_oases_time_log.txt"

    """
    /usr/bin/time -v /vol/jlab/tlin/software/assemblers/oases/oases $assem_dir 2> $time_log_fl
    mv Assem/transcripts.fa oases_contigs.fa

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}
