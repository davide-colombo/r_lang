# Generate synthetic data
# Store into a data frame object
# Write to a file

library(logger)
library(yaml)

# Load the configuration file
conf_path = './config/genstream.yml'
if(!file.exists(conf_path)){
    stop("Missing configuration file at: ", conf_path)
}
config = yaml.load_file(conf_path)

# Setting up the logger
conf_log = config$logger
lognamespace = conf_log$namespace

logpath = file.path(conf_log$dirname, conf_log$fname)
log_appender(
    appender=appender_file(logpath, append=TRUE, max_files=5L)
)

log_threshold(
    level=conf_log$level,
    namespace=lognamespace
)

log_info("======================= START RUN =======================")

# Setting up the output file
output = config$output
tokensep = output$sep
odir = output$dirname
if(!dir.exists(odir)){
    log_info("creating directory '{odir}'")
    dir.create(odir)
}

fname = output$fname
opath = file.path(odir, fname)
log_info("output file: {opath}")
if(!file.exists(opath)){
    log_info("creating file '{opath}'")
    file.create(opath)
}

# Setting up the generator parameters
param = config$param
set.seed(param$seed)
howmany = param$howmany
max_gene_num = param$max_gene_num
max_chro_num = param$max_chro_num
max_gene_exp = param$max_gene_exp

# Main loop
fw <- file(opath, "wt")
log_info("file '{opath}' successfully opened")
for(i in 1:howmany){
    explevel <- sample(0:max_gene_exp, 1)
    genenum <- sample(1:max_gene_num, 1)
    chronum <- sample(1:max_chro_num, 1)
    genename <- paste0('g_', genenum)
    chroname <- paste0('c_', chronum)

    oline <- paste(chronum, chroname, genenum, genename, explevel, sep=tokensep)
    writeLines(oline, fw)
}
log_info("successfully written {howmany} lines")

close(fw)
log_info("file '{opath}' successfully closed")
log_info("======================= END RUN =======================")
