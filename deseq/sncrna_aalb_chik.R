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
library(data.table)     # Efficient manipulation of data
library(stringr)        # str_count() function
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
    # print(head(fastq_raw))

    # Reads
    reads_raw <- sread(fastq_raw)

    # Length of sequences
    reads_length <- width(fastq_raw)

    # GC content
    gc_freq <- rowSums( letterFrequency(reads_raw, letters = c("G", "C")) )
    gc_perc <- gc_freq / reads_length * 100

    # Data.table much better to do computations
    dt <- data.table(Reads = as.character(reads_raw),
                     Length = reads_length,
                     GCFreq = gc_freq,
                     GCPerc = gc_perc)

    # Filter out duplicates after grouping by sequence
    dt_dups <- unique(dt[, .(Length, GCFreq, GCPerc, NCopies = .N), by = Reads][order(-NCopies)])

    # Count number of sequences longer than 30 nucleotides
    dt_longer <- dt[Length > 30, .(Count = .N, Perc = .N / nrow(dt) * 100)]
    print(dt_longer)

    # These occupy just a small fraction of the reads, it can be due to artifacts in the library
    # for example capturing or purification

    # Filter out sequences longer than 30 nucleotides
    dt_filtered <- dt[Length < 31]
    print(dt_filtered)

    # Small interfering RNAs
    dt_sirna <- dt[Length > 18 & Length < 24]
    print(dt_sirna)

    # PIWI-interacting RNAs
    dt_pirna <- dt[Length > 23 & Length < 31]
    print(dt_pirna)

    # ==========================================================================
    # Draw read length distribution...
    # ==========================================================================

    # siRNAs
    nbins <- nrow(dt_sirna[, .N, by = Length])
    hist_sirna <- ggplot(dt_sirna, aes(x = Length)) +
        geom_histogram(bins = nbins, color = "black", fill = "blue") +
        labs(x = "Read Length", y = "Frequency", title = "Frequency Distribution of Read Lengths - small interfering RNAs") +
        theme_minimal()

    # histogram <- hist(read_lengths, breaks = 20, col = "blue", main = "Frequency Distribution of Read Lengths", xlab = "Read Length", ylab = "Frequency")
    pdf( file.path("./plots", "sirna_length_distribution.pdf"), onefile = TRUE)
    print(hist_sirna)
    dev.off()

    # piRNAs
    nbins <- nrow(dt_pirna[, .N, by = Length])
    hist_pirna <- ggplot(dt_pirna, aes(x = Length)) +
        geom_histogram(bins = nbins, color = "black", fill = "blue") +
        labs(x = "Read Length", y = "Frequency", title = "Frequency Distribution of Read Lengths - PIWI-interacting RNAs") +
        theme_minimal()

    # histogram <- hist(read_lengths, breaks = 20, col = "blue", main = "Frequency Distribution of Read Lengths", xlab = "Read Length", ylab = "Frequency")
    pdf( file.path("./plots", "pirna_length_distribution.pdf"), onefile = TRUE)
    print(hist_pirna)
    dev.off()

    # ==========================================================================
    # Compute GC content
    # ==========================================================================


    # ==========================================================================
    # Draw the distribution of GC content...
    # ==========================================================================
    hist_pirna_gc <- ggplot(dt_pirna, aes(x=GCPerc)) +
        geom_histogram(bins = 20, fill="steelblue", color="black") +
        labs(title="Frequency Distribution of GC Content, PIWI-interacting RNAs", x="GC Content (%)", y="Frequency") +
        theme_minimal()

    pdf( file.path("./plots", "pirna_gc_distribution.pdf"), onefile = TRUE )
    print(hist_pirna_gc)
    dev.off()

    # ==========================================================================
    # Write content to a file
    # ==========================================================================
    # fn_split <- strsplit(fn, "\\.")
    # fp_out <- file.path(dir_in, paste0(fn_split[[1]][1], "_filtered.", fn_split[[1]][2]))

    # NOTE: need to set compress to FALSE!!!
    # writeFastq(filtered_reads, file = fp_out, full = TRUE, compress = FALSE, mode = "w")
}
