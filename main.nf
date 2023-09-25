nextflow.enable.dsl=2

//TODO: the idbatran and ibda ud pipeline has an option -l and -r parameter which would need to be set dynamocaööys
// TODO: many assembler can use multiple seeds for kmers, shall i adjust this parameter or maybe run a kmer array?

include { IdbaPipeline } from './assemblers/idba_pipeline.nf'
include { ingapCdgPipeline } from './assemblers/ingap_cdg.nf'
include { megahit } from './assemblers/megahit.nf'
include { rnabloom } from './assemblers/rnabloom.nf'
include { rnaspades } from './assemblers/rnaspades.nf'
include { SoapDeNovoTransPipeline } from './assemblers/soapdenovotrans.nf'
include { TransABySS } from './assemblers/transabyss.nf' 
include { TransLiG } from './assemblers/translig.nf'
include { Trinity } from './assemblers/trinity.nf' 
include { CollectContigsForSample } from './functions/streamlining.nf'
include { TrimmomaticPE } from './preprocess/trimmomatic.nf'

//sample_dir = '/vol/jlab/Analyses/metaTall/tmp/demultiplex/'
sample_dir = '/vol/jlab/Analyses/metaTall/tmp/demultiplex/test/'

workflow {
    ch = Channel.fromFilePairs("data/*_R{1,2}.dat").map{tuple -> [tuple[0], tuple[1].sort()].flatten()}.view()
    TrimmomaticPE(samples)
    """
    sample_channel = Channel.fromList(samples)
    input_sample_channel = Channel.fromList(samples).flatMap(sample ->sample[0])
    left_read_channel = Channel.fromList(samples).flatMap(sample ->sample[1])
    right_read_channel = Channel.fromList(samples).flatMap(sample ->sample[2])
    ASSEMBLE(left_read_channel, right_read_channel, input_sample_channel)
    """
}


workflow ASSEMBLE {
    take:
    left_reads
    right_reads
    sampleName

    main:
    //this will run three assemblers
    IdbaPipeline(left_reads, right_reads, sampleName)
    """
    ingapCdgPipeline(left_reads, right_reads, sampleName)
    megahit(left_reads, right_reads, sampleName)
    rnabloom(left_reads, right_reads, sampleName)
    rnaspades(left_reads, right_reads, sampleName)
    SoapDeNovoTransPipeline( left_reads, right_reads, sampleName )
    TransABySS( left_reads, right_reads, sampleName )
    //not paralized 😣
    TransLiG( left_reads, right_reads, sampleName )
    Trinity( left_reads, right_reads, sampleName )
    """
 }