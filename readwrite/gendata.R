# Generate synthetic data
# Store into a data frame object
# Write to a file

odir = './ioexamples'
if(!dir.exists(odir))
    dir.create(odir)

fname = 'synthetic_genes.csv'
opath = file.path(odir, fname)
if(!file.exists(opath))
    file.create(opath)

# TODO: read from arguments
howmany <- 554
max_gene_number <- 1000
max_chro_number <- 3
max_expl_number <- 200

# Generate random values
set.seed(123456)
explevels = sample(0:max_expl_number, howmany, replace=TRUE)

prefix_genename = 'g_'
prefix_chroname = 'c_'

chronum <- sample(1:max_chro_number, howmany, replace=TRUE)
genenum <- sample(1:max_gene_number, howmany, replace=TRUE)

chroname <- paste0(prefix_chroname, chronum)
genename <- paste0(prefix_genename, genenum)

# Data frame
dt <- data.frame(chroname, chronum, genename, genenum)
cat(sprintf("size: %s\n", format(object.size(dt), units='auto')))
cat(sprintf("colnames: %s\n", colnames(dt)))
cat(sprintf("nrow = %d\tncol = %d\tlength = %d\n",
            nrow(dt), ncol(dt), length(dt)))
# cat(sprintf("rownames: %s\n", rownames(dt))) from 1 to 554

library(data.table)

# Write a data.frame object to a file
fwrite(dt, file=opath)
