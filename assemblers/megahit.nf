process megahit {

    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    tuple val(sampleName), path(left_reads), path(right_reads)
    
    output:
    path "megahit_contigs.fa", emit: contigs

    script:
    """
    megahit -1 $left_reads -2 $right_reads -o megahit -t ${task.cpus}
    mv megahit/final.contigs.fa megahit_contigs.fa
    """
}
