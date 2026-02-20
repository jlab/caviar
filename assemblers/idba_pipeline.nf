include { UnzipReads; IDBA_UD; MergeAndConvert } from './idba_ud.nf'
include { IDBA_MT; ConvertToFASTA } from './idba_mt.nf'
include { IDBA_TRAN } from './idba_tran.nf'

workflow IdbaPipeline {
    take:
    triplet

    main:
    UnzipReads( triplet )
    MergeAndConvert( UnzipReads.out.unzipped )
    IDBA_UD( MergeAndConvert.out.merged )
    IDBA_TRAN(  MergeAndConvert.out.merged )

    ConvertToFASTA( UnzipReads.out.unzipped )
    IDBA_UD.out.contigs.join(
        ConvertToFASTA.out.fasta
    ).combine(
        Channel.of(params.read_length)
    ).combine(
       Channel.of(params.insert_size)
    ).set { idba_mt_input }
    
    IDBA_MT( idba_mt_input )
    
}
