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

    IDBA_MT( IDBA_TRAN.out.join(ConvertToFASTA.out))
    
}