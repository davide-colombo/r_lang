# Example of using fread() function to read a big file

library(yaml)
library(logger)
library(ggplot2)
library(data.table)

# cat(sprintf("number of threads used: %d\n", getDTthreads(verbose=TRUE)))
# Set the number of threads used by data.table as the total number of cores
# https://rdatatable.gitlab.io/data.table/reference/openmp-utils.html
setDTthreads(threads=0)

cf_path = './config/conf.yml'
if(!file.exists(cf_path)){
    stop("Cannot find configuration file at: ", cf_path)
}

# Configuration of interest
cf_fileread = yaml.load_file(cf_path)$fileread

# Logger
cf_l_fileread = cf_fileread$logger
ns_l_fileread = cf_l_fileread$namespace
lpath_fileread = file.path(cf_l_fileread$dirname, cf_l_fileread$fname)
log_appender(appender = appender_file(lpath_fileread, append=TRUE))
log_threshold(level=cf_l_fileread$level, namespace=ns_l_fileread)

log_info("======================= START RUN =======================", namespace=ns_l_fileread)

# Input file
cf_i_fileread = cf_fileread$input
ifpath_fileread = file.path(cf_i_fileread$dirname, cf_i_fileread$fname)
if(!file.exists(ifpath_fileread)){
    # Generate data
    log_info("Generating data...", namespace=ns_l_fileread)
    source(file.path(cf_fileread$gen$fname))
    log_info("Data successfully generated", namespace=ns_l_fileread)
}

# Read the entire CSV file into a data frame structure
log_info("Try to read input file at: '{ifpath_fileread}'", namespace=ns_l_fileread)
rawdata = fread(ifpath_fileread, colClasses=list(character=c(2, 4), integer=c(1, 3, 5)))

# cat(sprintf("mode(rawdata) = %s\n", mode(rawdata)))
# cat(sprintf("class(rawdata) = %s\n", class(rawdata)))
# cat(sprintf("size = %s\n", format(object.size(rawdata), units='auto')))
# cat(sprintf("rows = %d, columns = %d\n", nrow(rawdata), ncol(rawdata)))
# head(rawdata)

# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html
# DT [i,        j,          by      ]
# DT [where,    select,     group by]

# ===================================================================
# STAT 1
# ===================================================================
log_info("STAT1: Compute the sample mean of #reads grouped by chromosome name", namespace=ns_l_fileread)
stat1 <- rawdata[, mean(read_count), by = chromosome_name]
# print(stat1)

# ===================================================================
# STAT 2
# ===================================================================
stat2 <- rawdata[chromosome_id == 1, mean(read_count), by = gene_name]
log_info("STAT2: Compute the sample mean of #reads from chromosome 1 grouped by gene name", namespace=ns_l_fileread)
# print(stat2)

# ===================================================================
# STAT 3
# ===================================================================
genesubset <- c(33, 56, 767, 331)
stat3 <- rawdata[gene_id %in% genesubset,
                 .("avg_read_count"=mean(read_count), .N),
                 by = .(chromosome_name, gene_name)]
log_info("STAT3: Compute the sample mean of #reads for a subset of genes grouped by gene and chromosome name", namespace=ns_l_fileread)
# print(stat3)

# ===================================================================
# Display a plot and color the columns based on the chromosome ID
# ===================================================================

# Graphics configuration parameters
cf_g_fileread <- cf_fileread$graph
odir_g_fileread <- cf_g_fileread$dirname

y_lim = stat3[,round(max(avg_read_count)) + 10]
y_bins = seq(0, y_lim, by=round(y_lim/10))
y_lim = y_bins[length(y_bins)]

barplot_stat3 <- ggplot(stat3, aes(x=gene_name, y=avg_read_count, fill=chromosome_name)) +
    geom_bar(stat = 'identity', position=position_dodge()) +
    ggplot2::scale_y_continuous(limits=c(0, y_lim), breaks=y_bins) +
    geom_text(aes(label=round(avg_read_count,2)),
                position=position_dodge(width=0.9), vjust=-0.3,
                family='Courier', size=2) +
    labs(title="Average #read count grouped by gene and chromosome name")

opath_g_fileread <- file.path(odir_g_fileread, "barplot_stat3.pdf")
pdf(opath_g_fileread, onefile=TRUE)
print(barplot_stat3)
dev.off()

# ===================================================================
# STAT 4
# ===================================================================

stat4 <- rawdata[chromosome_id == 3 & gene_id %in% genesubset,
                 .("mean"=mean(read_count), "sd"=sd(read_count), .N),
                 by = gene_id][order(mean)]
log_info("STAT4: Compute the sample mean of #reads for a subset of genes on chromosome 3 grouped by gene id", namespace=ns_l_fileread)
# print(stat4)

# NOTE: I need to use 'chaining' because the column 'mean' does not exist
#       before the expression is evaluated!

# ===================================================================
# STAT 5
# ===================================================================
log_info("STAT5: Compute the total read count for a subset of genes on chromosome 3 grouped by gene id", namespace=ns_l_fileread)
stat5 <- rawdata[chromosome_id == 3 & gene_id %in% genesubset,
                 .(total_reads = sum(read_count)),
                 by = gene_name][order(total_reads)]
# print(stat5)

# ===================================================================
# Draw barplots with 'ggplot2'
# ===================================================================

# Create and store the plot object
bars_stat5 <- ggplot(stat5, aes(x = gene_name, y = total_reads)) +
    geom_bar(stat = 'identity', fill='#FF6600')

# Store the graph
opath_g_fileread <- file.path(odir_g_fileread, "barplot_stats5.pdf")
pdf(opath_g_fileread, onefile=TRUE)
print(bars_stat5)
dev.off()

log_info("======================= END RUN =======================", namespace=ns_l_fileread)
