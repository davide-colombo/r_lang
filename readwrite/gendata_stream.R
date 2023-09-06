# Generate synthetic data
# Store into a data frame object
# Write to a file

odir = './ioexamples'
if(!dir.exists(odir))
    dir.create(odir)

fname = 'synthetic_genes2.csv'
opath = file.path(odir, fname)
if(!file.exists(opath))
    file.create(opath)

# TODO: these params can be read from a config file
set.seed(123456)

max_gene_number <- 1000
max_chro_number <- 3
max_expl_number <- 200

# TODO: read from arguments
howmany <- 554

fw <- file(opath, "wt")
for(i in 1:howmany){
    explevel <- sample(0:max_expl_number, 1)
    genenum <- sample(1:max_gene_number, 1)
    chronum <- sample(1:max_chro_number, 1)
    genename <- paste0('g_', genenum)
    chroname <- paste0('c_', chronum)
    writeLines(
        paste(chronum, chroname, genenum, genename, explevel, sep=','),
        fw
    )
}
close(fw)
