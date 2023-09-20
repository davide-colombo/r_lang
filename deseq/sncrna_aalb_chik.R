# Differential gene expression analysis of short non-coding RNAs
# from Aedes albopictus mosquitoes.
#
# Source: ENA database
# Project Accession: PRJNA293817
# Sample Accession: SAMN04010069
# Experiment Accession: SRX1163797
# Run Accession: SRR2182471

library(microseq)
library(data.table)
library(ggplot2)

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

    nbins = length(unique(fastq_dt$ReadLen))
    hist_readlen <- ggplot(fastq_dt, aes(x = ReadLen)) +
        geom_histogram(bins = nbins, fill = "blue", color = "orange") +
        geom_density(aes(y = after_stat(density)), fill = "red", alpha = 0.5) +
        labs(title = "Read length distribution",
             x = "Read length",
             y = "Frequency")

    fp_oplot <- file.path("./plot", "hist_readlen.pdf")
    pdf(fp_oplot, onefile = TRUE)
    print(hist_readlen)
    dev.off()

    # fn_split <- strsplit(fn, "\\.")
    # fp_out <- file.path(dir_in, paste0(fn_split[[1]][1], "_filtered.", fn_split[[1]][2]))

    # NOTE: need to set compress to FALSE!!!
    # writeFastq(filtered_reads, file = fp_out, full = TRUE, compress = FALSE, mode = "w")
}
