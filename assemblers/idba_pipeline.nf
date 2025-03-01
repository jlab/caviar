include { UnzipReads; IDBA_UD; MergeAndConvert } from './idba_ud.nf'
include { IDBA_MT; ConvertToFASTA } from './idba_mt.nf'
include { IDBA_TRAN } from './idba_tran.nf'

workflow IdbaPipeline {
    take:
    triplet

    main:

    UnzipReads( triplet )
    MergeAndConvert( UnzipReads.out )
    //IDBA_UD( MergeAndConvert.out )
    IDBA_TRAN(  MergeAndConvert.out )

    ConvertToFASTA( UnzipReads.out )
    IDBA_TRAN.out.join(
        ConvertToFASTA.out
    ).combine(
        Channel.of(params.read_length, params.insert_size)
    ).set { idba_mt_input }
    
    IDBA_MT( idba_mt_input )
    
}