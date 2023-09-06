# Generate synthetic data
# Store into a data frame object
# Write to a file
library(yaml)

conf_path = './config/genstream.yml'
if(!file.exists(conf_path)){
    # TODO: log info
    stop("Missing configuration file at: ", conf_path)
}

config = yaml.load_file(conf_path)

output = config$output
tokensep = output$sep
odir = output$dirname
if(!dir.exists(odir))
    dir.create(odir)

fname = output$fname
opath = file.path(odir, fname)
if(!file.exists(opath))
    file.create(opath)

param = config$param
set.seed(param$seed)
howmany = param$howmany
max_gene_num = param$max_gene_num
max_chro_num = param$max_chro_num
max_gene_exp = param$max_gene_exp

fw <- file(opath, "wt")
for(i in 1:howmany){
    explevel <- sample(0:max_gene_exp, 1)
    genenum <- sample(1:max_gene_num, 1)
    chronum <- sample(1:max_chro_num, 1)
    genename <- paste0('g_', genenum)
    chroname <- paste0('c_', chronum)

    oline <- paste(chronum, chroname, genenum, genename, explevel, sep=tokensep)
    writeLines(oline, fw)
}
close(fw)
