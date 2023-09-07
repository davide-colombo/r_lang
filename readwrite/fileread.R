# Example of using fread() function to read a big file

library(ggplot2)
library(data.table)
library(yaml)

# cat(sprintf("number of threads used: %d\n", getDTthreads(verbose=TRUE)))
# Set the number of threads used by data.table as the total number of cores
# https://rdatatable.gitlab.io/data.table/reference/openmp-utils.html
setDTthreads(threads=0)

configpath = './config/genstream.yml'
if(!file.exists(configpath)){
    stop("Cannot find configuration file at: ", configpath)
}

config = yaml.load_file(configpath)
output = config$output
ifpath = file.path(output$dirname, output$fname)
if(!file.exists(ifpath)){
    # Generate data
    source("gendata_stream.R")
}

# Read the entire CSV file into a data frame structure
rawdata = fread(ifpath, colClasses=list(character=c(2, 4), integer=c(1, 3, 5)))
cat(sprintf("mode(rawdata) = %s\n", mode(rawdata)))
cat(sprintf("class(rawdata) = %s\n", class(rawdata)))
cat(sprintf("size = %s\n", format(object.size(rawdata), units='auto')))
cat(sprintf("rows = %d, columns = %d\n", nrow(rawdata), ncol(rawdata)))
head(rawdata)

# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html
# DT [i,        j,          by      ]
# DT [where,    select,     group by]

print("Compute the sample mean of #reads grouped by chromosome name")
stat1 <- rawdata[, mean(read_count), by = chromosome_name]
print(stat1)

stat2 <- rawdata[chromosome_id == 1, mean(read_count), by = gene_name]
print("Compute the sample mean of #reads from chromosome 1 grouped by gene name")
print(stat2)

genesubset <- c(33, 56, 767, 331)
stat3 <- rawdata[gene_id %in% genesubset,
                 .("mean"=mean(read_count), .N),
                 by = gene_name]
print("Compute the sample mean of #reads for a subset of genes grouped by gene name")
print(stat3)

stat4 <- rawdata[chromosome_id == 3 & gene_id %in% genesubset,
                 .("mean"=mean(read_count), "sd"=sd(read_count), .N),
                 by = gene_id][order(mean)]
print("Compute the sample mean of #reads for a subset of genes on chromosome3 grouped by gene id, ordered by mean values")
print(stat4)

# NOTE: I need to use 'chaining' because the column 'mean' does not exist
#       before the expression is evaluated!
print("============================================================")
stat5 <- rawdata[chromosome_id == 3 & gene_id %in% genesubset, .(total_reads = sum(read_count)), by = gene_id][order(total_reads)]
print(stat5)

# ===================================================================
# Draw barplots with 'ggplot2'
# ===================================================================
graphconfig <- config$graphs
ographdir <- graphconfig$dirname
ographpath <- file.path(ographdir, 'barplot_stats5.pdf')

# Create and store the plot object
bars_stat5 <- ggplot(stat5, aes(x = gene_id, y = total_reads)) +
    geom_bar(stat = 'identity')

pdf(ographpath, onefile=TRUE)

# Display the plot
plot(bars_stat5)
