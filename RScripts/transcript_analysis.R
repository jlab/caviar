install.packages("BiocManager")
BiocManager::install("Biostrings")

library(Biostrings)

get_contig_counts <- function(fasta_file) {
  dna_seqs <- readDNAStringSet(fasta_file)
  lengths <- width(dna_seqs)
  table(lengths)
}

file_paths <- c('./transabyss_contigs.fa', './trans-lig_contigs.fa')
for (file_path in file_paths) {
  print(paste("File:", file_path))
  counts <- get_contig_counts(file_path)
  print(counts)
  cat("\n")
}
