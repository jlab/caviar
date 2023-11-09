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
include { Bowtie2Align; Bowtie2Build } from './preprocess/bowtie.nf'
include { SORTMERNA } from './preprocess/sortmerna.nf' 
include { PLOT_ALIGNMENT_RATES } from './functions/plotting.nf'
include { OasesPipeline } from './assemblers/oases.nf'

//sample_dir = '/vol/jlab/Analyses/metaTall/tmp/demultiplex/'
//sample_dir = '/vol/jlab/tlin/all_project/fastq/subset_rna/'
//sample_dir = '/homes/tlin/Projects/jlab-mtpreprocess/result/sortmerna/'
sample_dir = params.sample_dir
reference = Channel.fromPath('/vol/jlab/tlin/all_project/references/ncbi_GRCH38/GRCh38_latest_genomic.fna')
rrna_databse = Channel.fromPath('/vol/jlab/tlin/all_project/references/no_backup/rrna_db/smr_v4.3_default_db.fasta')
print(sample_dir)
print(params.pattern)
workflow {
    ch = Channel.fromFilePairs("${sample_dir}/${params.pattern}").map{tuple -> [tuple[0], tuple[1].sort()].flatten()} //for debugging: .view()
    ASSEMBLE(ch)

    """
    //works
    Bowtie2Build(reference)
    Bowtie2Align(ch, Bowtie2Build.out)
    Bowtie2Align.out.view().map { s, file -> 
        def content = file.text.trim()
        tuple(s, content)
    }.collect().set { alignment_rates_bowie }
    PLOT_ALIGNMENT_RATES(alignme   Otherwise, names are kept untouched in the given output directory.
nt_rates_bowie)
    """
 
    //works
    //TrimmomaticPE(ch)
}


workflow ASSEMBLE {
    take:
    triplet

    main:
    IdbaPipeline(triplet) //idba_ud doesnt work
    megahit(triplet)
    OasesPipeline(triplet)
    ingapCdgPipeline(triplet)
    rnabloom(triplet)
    rnaspades(triplet)
    SoapDeNovoTransPipeline(triplet)
    TransABySS(triplet)
    TransLiG(triplet)
    Trinity(triplet)

 }