library(Biostrings)
library(tidyverse)
library(ggplot2)

#TODO: inputs should be provided by command line

get_contig_counts <- function(fasta_file) {
  dna_seqs <- readDNAStringSet(fasta_file)
  lengths <- width(dna_seqs)
  return(data.frame(lengths=lengths, file=basename(fasta_file)))
}

file_paths <- c(
  "./results/assembler/M_D_PF_002c_S5/ingap-cdg_contigs.fa",
  "./results/assembler/M_D_PF_002c_S5/rnabloom_contigs.fa",
  "./results/assembler/M_D_PF_002c_S5/megahit_contigs.fa",
  "./results/assembler/M_D_PF_002c_S5/soap-denovo-trans_contigs.fa",
  "./results/assembler/M_D_PF_002c_S5/transabyss_contigs.fa",
  "./results/assembler/M_D_PF_002c_S5/rnaspades_contigs.fa",
  "./results/assembler/M_D_PF_002c_S5/trans-lig_contigs.fa",
  "./results/assembler/M_D_PF_002c_S5/trinity_contigs.fa"
)

df <- bind_rows(lapply(file_paths, get_contig_counts))

p <- ggplot(df, aes(x=lengths)) + 
    scale_y_log10() +
  geom_histogram(binwidth=100, fill="#fd7f6f", alpha=0.9) + 
  facet_wrap(~ file, scales = "fixed") +
  theme_minimal() +
  labs(title="Contig Length Distribution",
       subtitle="Faceted by assembler",
       x="Contig Length",
       y="Frequency") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

ggsave(filename="/vol/jlab/tlin/all_project/analysis/assembler/transcript_histogram_byassembler.png", plot=p, width=10, height=6, dpi=900)