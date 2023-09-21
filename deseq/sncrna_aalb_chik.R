# Differential gene expression analysis of short non-coding RNAs
# from Aedes albopictus mosquitoes.
#
# Source: ENA database
# Project Accession: PRJNA293817
# Sample Accession: SAMN04010069
# Experiment Accession: SRX1163797
# Run Accession: SRR2182471

library(ShortRead)      # FastQ files manipulation
library(Biostrings)     # DNASequence manipulation
library(ggplot2)        # Graphs

# Input directory
dir_in <- "./fastq"

# Input files
files_in <- list.files(dir_in, pattern = "\\.fastq")

# Error
if(length(files_in) == 0){
    stop(sprintf("Error: no file found in %s\n", dir_in))
}

# Process each file
for(fn in files_in){
    fp = file.path(dir_in, fn)

    # ==========================================================================
    # Read raw fastq file
    # ==========================================================================
    fastq_raw <- readFastq(fp)
    print(head(fastq_raw))

    # ==========================================================================
    # Read length
    # ==========================================================================
    read_lengths <- width(fastq_raw)

    # Percent duplicates
    dup_perc <- length(unique(sread(fastq_raw))) / length(sread(fastq_raw)) * 100
    cat(sprintf("percentage duplicate = %.3f %%", dup_perc))

    # ==========================================================================
    # Draw read length distribution...
    # ==========================================================================
    # Create a data frame
    df <- data.frame(Length = read_lengths)
    nbins <- length(unique(df$Length))

    # Create the histogram
    histogram <- ggplot(df, aes(x = Length)) +
        geom_histogram(bins = nbins, color = "black", fill = "blue") +
        labs(x = "Read Length", y = "Frequency", title = "Frequency Distribution of Read Lengths") +
        theme_minimal()

    # histogram <- hist(read_lengths, breaks = 20, col = "blue", main = "Frequency Distribution of Read Lengths", xlab = "Read Length", ylab = "Frequency")
    pdf( file.path("./plots", "histogram_read_lengths.pdf"), onefile = TRUE)
    print(histogram)
    dev.off()

    # ==========================================================================
    # Compute GC content
    # ==========================================================================
    gc_perc <- rowSums( letterFrequency(sread(fastq_raw), letters = c("G", "C")) ) / read_lengths * 100

    # ==========================================================================
    # Draw the distribution of GC content...
    # ==========================================================================
    # Convert to data frame
    df <- data.frame(Sequence = sread(fastq_raw))
    df$GCPerc <- gc_perc
    print(head(df))

    histogram <- ggplot(df, aes(x=GCPerc)) +
        geom_histogram(binwidth = 3, fill="steelblue", color="black") +
        labs(title="Frequency Distribution of GC Content", x="GC Content (%)", y="Frequency") +
        theme_minimal()

    pdf( file.path("./plots", "barplot_gc_perc.pdf"), onefile = TRUE )
    print(histogram)
    dev.off()

    # ==========================================================================
    # Write content to a file
    # ==========================================================================
    # fn_split <- strsplit(fn, "\\.")
    # fp_out <- file.path(dir_in, paste0(fn_split[[1]][1], "_filtered.", fn_split[[1]][2]))

    # NOTE: need to set compress to FALSE!!!
    # writeFastq(filtered_reads, file = fp_out, full = TRUE, compress = FALSE, mode = "w")
}
