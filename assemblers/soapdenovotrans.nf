include { UnzipReads } from './idba_ud.nf'

workflow SoapDeNovoTransPipeline {
    take:
    triplet
    
    main:
    UnzipReads( triplet)
    CreateSOAPdenovoConfig( UnzipReads.out )
    SOAPdenovoTrans( CreateSOAPdenovoConfig.out )
}

process SOAPdenovoTrans {
    tag "$sample"

    publishDir "${params.result_dir}/assembler/$sample", mode: 'copy'

    input:
    tuple val(sample), path(soap_config), path(left_reads), path(right_reads)

    output:
    path "soap-denovo-trans_contigs.fa", emit: contigs

    script:
    """
    OUTDIR=soapdenovo_trans_results
    mkdir \$OUTDIR
    SOAPdenovo-Trans-127mer all -s $soap_config -o \${OUTDIR}/soap_denovo_trans -p ${task.cpus}
    mv soapdenovo_trans_results/soap_denovo_trans.contig soap-denovo-trans_contigs.fa
    """
}

//TODO the soap denovo assembler will  use a config file which is created during a process, this should be adjustested, especially avg_ins (insert size between paired end) and max_rd_len/ rd_len_cutoff (length of max read)
process CreateSOAPdenovoConfig {
    tag "$sample"

    cpus = 1
    memory = '1G'

    input:
    tuple val(sample), path(left_reads), path(right_reads)


    output:
    tuple val(sample), path("soap.config"), path(left_reads), path(right_reads)

    script:
    """
    echo "#maximal read length" > soap.config
    echo "max_rd_len=300" >> soap.config
    echo "[LIB]" >> soap.config
    echo "#maximal read length in this lib" >> soap.config
    echo "rd_len_cutof=300" >> soap.config
    echo "#average insert size" >> soap.config
    echo "avg_ins=190" >> soap.config
    echo "#if sequence needs to be reversed" >> soap.config
    echo "reverse_seq=0" >> soap.config
    echo "#in which part(s) the reads are used" >> soap.config
    echo "asm_flags=3" >> soap.config
    echo "#minimum aligned length to contigs for a reliable read location (at least 32 for short insert size)" >> soap.config
    echo "map_len=64" >> soap.config
    echo "#fastq file for read 1" >> soap.config
    echo "q1=$left_reads" >> soap.config
    echo "#fastq file for read 2" >> soap.config
    echo "q2=$right_reads" >> soap.config
    """
}
