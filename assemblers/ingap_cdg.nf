include { UnzipReads; MergeAndConvert } from './idba_ud.nf'
 
workflow ingapCdgPipeline {
    take:
    triplet

    main:
    //these processes need to take tuples
    UnzipReads( triplet )
    MergeAndConvert( UnzipReads.out.unzipped )
    ingapCdg( MergeAndConvert.out.merged )

}

process ingapCdg {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(merged_fa)

    output:
    path "ingap-cdg_contigs.fa"             , emit: contigs
    path(time_log_fl)                       , emit: time_log

    //Todo threads can be doubled
    process_name = "ingapCdg"
    time_log_fl = "${sample}_ingap_cdg_time_log.txt"

    script:
    """
    /usr/bin/time -v /vol/jlab/tlin/software/ass_links/ingap-cdg -i $merged_fa -o ingap_cdg_results -n ${task.cpus} 2> $time_log_fl
    mv ingap_cdg_results/OutputCDSs/cds.nuc.fas ingap-cdg_contigs.fa

    echo -e "\\tProcess: \\"$process_name\\"" >> $time_log_fl
    echo -e "\\tEnvironment: \\"$sample\\"" >> $time_log_fl
    """
}
