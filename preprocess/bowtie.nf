process Bowtie2Align {

    input:
    tuple val(sample), path(r1), path(r2)
    tuple val(index_base_name), path(bowtie2_index)


    output:
    tuple val(sample), path("alignment_rate_value.txt")

    script: 
    """
    bowtie2 -p ${task.cpus} -x ${index_base_name} -1 $r1 -2 $r2 > ${sample}.sam 2> ${sample}.log
    awk '/overall alignment rate/ { gsub("%",""); print \$1 }' ${sample}.log > alignment_rate_value.txt
    """
}

process Bowtie2Build {
    input:
    file reference

    output:
    tuple val("${reference.baseName}_bowtie2"), path("${reference.baseName}_bowtie2*")

    script:
    """
    bowtie2-build-2.5.1 --threads ${task.cpus} $reference ${reference.baseName}_bowtie2
    """
}
