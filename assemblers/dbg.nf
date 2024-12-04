process DBG {
    tag "$sample"
    label 'process_high_memory'

    conda "${moduleDir}/environment.yml"
    //TODO add conda environment
    //TODO add podman container
    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(reads_left), path(reads_right)

    output:
    path "dbg_contigs.fa"         , emit: contigs
    path "dbg_graph.gfa"        , emit: graph
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${sample}"

    //TODO Should -g and kmer be a parameter for config in args?
    """
    /homes/tlin/software/bin/dbg -i ${reads_left} ${reads_right}  \\
        -t test test \\
        -r ${task.memory.toGiga()} \\
        -g \\
        -k kmer64 \\
        --format gfa \\
        -p \\
        --paths \\
        --threads ${task.cpus} \\
        ${args}  
    
    mv dbg_out.fasta dbg_contigs.fa
    sed -i "s/ //g" dbg_contigs.fa

    mv dbg_out.gfa dbg_graph.gfa

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dbg: \$(echo \$(dbg -V 2>&1 | head -n 1 | sed 's/dbg: de bruijn graph builder, version v//;s/ ".*"//' ))
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${sample}"


    """
    touch ${prefix}.vg

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        vg: \$(echo \$(vg 2>&1 | head -n 1 | sed 's/vg: variation graph tool, version v//;s/ ".*"//' ))
    END_VERSIONS
    """
}
