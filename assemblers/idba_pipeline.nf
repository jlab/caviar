include { UnzipReads; IDBA_UD; MergeAndConvert } from './idba_ud.nf'
include { IDBA_MT; ConvertToFASTA } from './idba_mt.nf'
include { IDBA_TRAN } from './idba_tran.nf'

workflow IdbaPipeline {
    take:
    left_reads
    right_reads
    sampleName

    main:
    UnzipReads( left_reads, right_reads )
    MergeAndConvert( UnzipReads.out.left_unzipped, UnzipReads.out.right_unzipped )
    IDBA_UD( MergeAndConvert.out.merged_fa, sampleName )
    ConvertToFASTA( UnzipReads.out.left_unzipped, UnzipReads.out.right_unzipped )
    IDBA_MT( ConvertToFASTA.out.left_fasta, ConvertToFASTA.out.right_fasta, MergeAndConvert.out.merged_fa, sampleName )
    IDBA_TRAN(  MergeAndConvert.out.merged_fa, sampleName )
    
}