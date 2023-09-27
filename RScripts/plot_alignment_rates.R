# Load required libraries
library(ggplot2)
library(tidyr)

# Command-line arguments
args <- commandArgs(trailingOnly = TRUE)
args[1] <- gsub("'", "", args[1])
args[1] <- gsub("\\[", "", args[1])
args[1] <- gsub("\\]", "", args[1])
flatList <- strsplit(args[1], split = ",")[[1]]
output_file <- args[2]
    ch = Channel.fromFilePairs("${sample_dir}/*_R{1,2}_001.fastq.gz").map{tuple -> [tuple[0], tuple[1].sort()].flatten()} //for debugging: .view()
    ch.view()
    Bowtie2Build(reference)
# Convert the flat list to a data frame
data <- data.frame(
  Sample = flatList[seq(1, length(flatList), by = 2)],
  AlignmentRate = as.numeric(flatList[seq(2, length(flatList), by = 2)])
)

# Plot the data using ggplot2
p <- ggplot(data, aes(x = Sample, y = AlignmentRate, fill = Sample)) +
    geom_bar(stat = "identity") +
    labs(
        title = "Alignment Rate per Sample",
        x = "Sample",
        y = "Alignment Rate"
    ) +
    theme_minimal()

# Save the plot to a file
ggsave(output_file, plot = p, width = 10, height = 6, dpi = 300)
