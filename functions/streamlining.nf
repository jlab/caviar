process CollectContigsForSample {
    input:
    val sample 
    
    script:
    """
    mkdir ${baseDir}/results/transcripts/$sample
    mv ${baseDir}/results/assembler/*.fa ${baseDir}/results/transcripts/$sample
    """
}

process MKDIR {
    input:
    directory_name

    script:
    """
    mkdir $direcotry_name
    """
}

