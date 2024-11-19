

process PLOT_ALIGNMENT_RATES {
    publishDir "${params.result_dir}/plots", mode: 'copy'

    input:
    val flatList
    
    output:
    path "alignment_rates.png"

    script:
    """
    Rscript /homes/tlin/Projects/assembler_benchmark_pipeline/RScripts/plot_alignment_rates.R '$flatList' alignment_rates.png
    """
}