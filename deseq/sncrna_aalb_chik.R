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
    dt_raw <- dt[, .(Length, GCFreq, GCPerc, NCopies = .N), by = Reads][order(-NCopies)]

    # Filter out duplicated rows
    dt_unique <- unique(dt_raw)
    print(dt_unique)

    # Unique reads
    # reads_unique <- unique(reads_raw)

    # Unique sequences
    # df <- data.frame(Reads = reads_unique,
    #                  Length = width(reads_unique))


    # Frequency distribution and cumulative distribution
    # tot_unique_reads = nrow(df)
    # seq_length <- seq(from = 21, to = 30, by = 1)
    # cumulative_nreads_per_len <- vector(mode = "integer", length = 0)
    # cum_sum <- 0
    # for(sl in seq_length){
    #     tmp <- sum(df$Length == sl)
    #     cum_sum <- cum_sum + tmp
    #     cumulative_nreads_per_len <- c(cumulative_nreads_per_len, cum_sum)
    #     cat(sprintf("#Number of unique sequences of length %d = %d (%.4f%% of total)\n", sl, tmp, tmp/tot_unique_reads*100))
    # }
    #
    # print(cumulative_nreads_per_len)
    #
    # # Percent duplicates
    # dup_perc <- length(reads_unique) / length(reads_raw) * 100
    # cat(sprintf("percentage duplicate = %.3f %%\n", dup_perc))

    # Percentage of duplication level for each unique sequence


    # ==========================================================================
    # Draw read length distribution...
    # ==========================================================================
    # Create a data frame

    # df <- data.frame(Length = read_lengths)
    # nbins <- length(unique(df$Length))
    #
    # # Create the histogram
    # histogram <- ggplot(df, aes(x = Length)) +
    #     geom_histogram(bins = nbins, color = "black", fill = "blue") +
    #     labs(x = "Read Length", y = "Frequency", title = "Frequency Distribution of Read Lengths") +
    #     theme_minimal()
    #
    # # histogram <- hist(read_lengths, breaks = 20, col = "blue", main = "Frequency Distribution of Read Lengths", xlab = "Read Length", ylab = "Frequency")
    # pdf( file.path("./plots", "histogram_read_lengths.pdf"), onefile = TRUE)
    # print(histogram)
    # dev.off()

    # ==========================================================================
    # Compute GC content
    # ==========================================================================


    # ==========================================================================
    # Draw the distribution of GC content...
    # ==========================================================================
    # Convert to data frame

    # df <- data.frame(Sequence = sread(fastq_raw))
    # df$GCPerc <- gc_perc
    # print(head(df))
    #
    # histogram <- ggplot(df, aes(x=GCPerc)) +
    #     geom_histogram(binwidth = 3, fill="steelblue", color="black") +
    #     labs(title="Frequency Distribution of GC Content", x="GC Content (%)", y="Frequency") +
    #     theme_minimal()
    #
    # pdf( file.path("./plots", "barplot_gc_perc.pdf"), onefile = TRUE )
    # print(histogram)
    # dev.off()

    # ==========================================================================
    # Write content to a file
    # ==========================================================================
    # fn_split <- strsplit(fn, "\\.")
    # fp_out <- file.path(dir_in, paste0(fn_split[[1]][1], "_filtered.", fn_split[[1]][2]))

    # NOTE: need to set compress to FALSE!!!
    # writeFastq(filtered_reads, file = fp_out, full = TRUE, compress = FALSE, mode = "w")
}
