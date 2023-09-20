# Differential gene expression analysis of short non-coding RNAs
# from Aedes albopictus mosquitoes.
#
# Source: ENA database
# Project Accession: PRJNA293817
# Sample Accession: SAMN04010069
# Experiment Accession: SRX1163797
# Run Accession: SRR2182471

library(stringr)
library(microseq)
library(data.table)
library(ggplot2)

# Compute the GC percentage
get_gc_perc <- function(myseq){
    gc_count <- str_count(myseq, "C") + str_count(myseq, "G")
    gc_perc <- (gc_count / nchar(myseq)) * 100
    return(gc_perc)
}

# ==============================================================================
# CODE STARTS HERE
# ==============================================================================

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

    # Read raw fastq file
    fastq_raw <- microseq::readFastq(fp)
    print(head(fastq_raw))

    # Convert to data.table
    fastq_dt <- as.data.table(fastq_raw)

    # Add read length column
    fastq_dt[, ReadLen := nchar(Sequence)]
    print(head(fastq_dt))

    # Add GC content column
    fastq_dt[, GCPerc := get_gc_perc(Sequence), by = Sequence]
    print(head(fastq_dt))

    # # Sample mean of the read length
    # readlen_mean <- mean(fastq_dt$ReadLen)
    #
    # # Sample standard deviation of read lenght
    # readlen_sd <- sd(fastq_dt$ReadLen)
    #
    # readlen_min <- min(fastq_dt$ReadLen)
    #
    # readlen_max <- max(fastq_dt$ReadLen)
    #
    # readlen_sample_xdata <- seq(readlen_min, readlen_max, 1)
    # readlen_expected_normal_distribution_xdata <- rnorm(1000, mean = readlen_mean, sd = readlen_sd)
    # readlen_expected_normal_distribution_ydata <- dnorm(readlen_expected_normal_distribution_xdata, mean = readlen_mean, sd = readlen_sd)
    #
    # readlen_expected_normal_distribution_dt <- data.frame(x = readlen_expected_normal_distribution_xdata,
    #                                                       y = readlen_expected_normal_distribution_ydata)
    #
    # # Number of bins
    # readlen_hist_nbins = length(unique(fastq_dt$ReadLen))
    # readlen_hist <- ggplot(fastq_dt, aes(x = ReadLen)) +
    #     geom_line(data = readlen_expected_normal_distribution_dt, aes(x = x, y = y), color = "#FF6666", linewidth = 1) +
    #     # geom_histogram(bins = readlen_hist_nbins, fill = "blue", color = "black") +
    #     labs(title = "Read length distribution",
    #          x = "Read length",
    #          y = "Frequency")
    #
    # # readlen_hist <- readlen_hist +
    #
    #
    # fp_oplot <- file.path("./plots", "hist_readlen.pdf")
    # pdf(fp_oplot, onefile = TRUE)
    # print(readlen_hist)
    # dev.off()

    # fn_split <- strsplit(fn, "\\.")
    # fp_out <- file.path(dir_in, paste0(fn_split[[1]][1], "_filtered.", fn_split[[1]][2]))

    # NOTE: need to set compress to FALSE!!!
    # writeFastq(filtered_reads, file = fp_out, full = TRUE, compress = FALSE, mode = "w")
}
