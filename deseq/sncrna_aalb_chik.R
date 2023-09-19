# Differential gene expression analysis of short non-coding RNAs
# from Aedes albopictus mosquitoes.
#
# Source: ENA database
# Project Accession: PRJNA293817
# Sample Accession: SAMN04010069
# Experiment Accession: SRX1163797
# Run Accession: SRR2182471

library(jsonlite)
library(curl)

dir_conf <- "./config"
if(!dir.exists(dir_conf)){
    stop("Error: missing configuration directory")
}

fn_jconf <- "conf.json"
fp_jconf <- file.path(dir_conf, fn_jconf)
if(!file.exists(fp_jconf)){
    stop("Error: missing configuration file")
}

# Read configuration from JSON file
jconf <- fromJSON(fp_jconf)

# URL for FTP transfer
fq_url <- paste("ftp:", jconf$fastq_ftp, sep = "//")
print(fq_url)

# # Open connection
# con <- curl(url = fq_url, "r", handle = new_handle())
#
# # Streaming lines
# for(i in 1:10){
#
#     # Read line
#     line <- readLines(con, n = 1)
#
#     # Process line
# }
#
# close(con)
