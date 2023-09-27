process TrimmomaticPE {
    cpus = 10
    memory = '10G'

    input:
    tuple val(sample), path(r1), path(r2)

    output:
    path "*_Paired.fastq.gz", emit: paired
    path "*_Unpaired.fastq.gz", emit: unpaired

    script:
    """
    trimmomatic PE -threads ${task.cpus} $r1 $r2 \
    ${r1.baseName}_Paired.fastq.gz ${r1.baseName}_Unpaired.fastq.gz \
    ${r2.baseName}_Paired.fastq.gz ${r2.baseName}_Unpaired.fastq.gz \
    ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-PE-2.fa:2:30:10
    """
}
