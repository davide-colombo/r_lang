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

    # Convert to data.table
    fastq_dt <- as.data.table(fastq_raw)

    # fn_split <- strsplit(fn, "\\.")
    # fp_out <- file.path(dir_in, paste0(fn_split[[1]][1], "_filtered.", fn_split[[1]][2]))

    # NOTE: need to set compress to FALSE!!!
    # writeFastq(filtered_reads, file = fp_out, full = TRUE, compress = FALSE, mode = "w")
}
