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
include { SORTMERNA } from './preprocess/sortmerna.nf' 
include { OasesPipeline } from './assemblers/oases.nf'
include { DBG } from './assemblers/dbg.nf'

sample_dir = params.sample_dir


workflow {
    ch = Channel.fromFilePairs("${sample_dir}/${params.pattern}").map{tuple -> [tuple[0], tuple[1].sort()].flatten()} //for debugging: .view()
    ASSEMBLE(ch)
}


workflow ASSEMBLE {
    take:
    triplet

    main:
    IdbaPipeline(triplet) //idba_ud doesnt work
    SoapDeNovoTransPipeline(triplet)
    megahit(triplet)
    OasesPipeline(triplet)
    rnaspades(triplet)
    Trinity(triplet)
    DBG(triplet)
    TransABySS(triplet)

    //TransLiG(triplet)
    //ingapCdgPipeline(triplet)
    //rnabloom(triplet)

 }