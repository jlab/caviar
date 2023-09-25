workflow OasesPipeline {
    take:
    tuple

    main:
    Velveth(tuple)
    Velvetg(Velveth.out)
    Oases(Velvetg.out)
}

process Velveth {
    input:
    tuple val(sample), path(leftreads), path(rightreads)

    output:
    tuple val(sample), path("Assem")

    script:
    """
    velveth Assem 31 -shortPaired -fastq.gz -separate $reads_left $reads_right
    """
}

//TODO: check whether the contig is already the final velvet output 
process Velvetg {
    input:
    tuple val(sample), path(assem_dir)

    output:
    tuple val(sample), path(assem_dir)

    script:
    """
    /vol/jlab/tlin/software/assemblers/oases/velvet/velvetg $assem_dir -read_trkg yes
    """
}

process Oases {
    publishDir "results/assembler/${sample}", mode: 'copy'

    input:
    tuple val(sample), path(assem_dir)

    output:
    tuple val(sample), path("oases_contigs.fa")
    tuple val(sample), path("velvet_contigs.fa")

    script:
    """
    /vol/jlab/tlin/software/assemblers/oases/oases $assem_g_dir
    mv Assem/transcripts.fa oases_contigs.fa
    mv Assem/contigs.fa.fa velvet_contigs.fa
    """
}
