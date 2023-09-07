# Generate synthetic data
# Store into a data frame object
# Write to a file

library(logger)
library(yaml)

# Load the configuration file
conf_path = './config/conf.yml'
if(!file.exists(conf_path)){
    stop("Missing configuration file at: ", conf_path)
}

# Take configuration for generator script
cf = yaml.load_file(conf_path)$gen

# Setting up the logger
cf_log = cf$logger
ns_log = cf_log$namespace

logpath = file.path(cf_log$dirname, cf_log$fname)
log_appender(
    appender=appender_file(logpath, append=TRUE, max_files=5L)
)

log_threshold(
    level=cf_log$level,
    namespace=ns_log
)

# IMPORTANT INSIGHT: if I pass the proper namespace, the level is properly set
# log_threshold(namespace=lognamespace)

log_info("======================= START RUN =======================", namespace=ns_log)

# Output configuration
cf_out = cf$output
tokensep = cf_out$sep

# Output directory
odir = cf_out$dirname
if(!dir.exists(odir)){
    log_info("creating directory '{odir}'", namespace=ns_log)
    dir.create(odir)
}

# Output file
fn = cf_out$fname
opath = file.path(odir, fn)
log_info("output file: {opath}", namespace=ns_log)
if(!file.exists(opath)){
    log_info("creating file '{opath}'", namespace=ns_log)
    file.create(opath)
}

# Setting up the generator parameters
cf_p = cf$param
set.seed(cf_p$seed)
howmany = cf_p$howmany
max_gene_num = cf_p$max_gene_num
max_chro_num = cf_p$max_chro_num
max_gene_exp = cf_p$max_gene_exp

# File connection
fw <- file(opath, "wt")
log_info("file '{opath}' successfully opened", namespace=ns_log)

# Header
myheader <- paste(
    'chromosome_id', 'chromosome_name',
    'gene_id', 'gene_name', 'read_count',
    sep=tokensep
)
writeLines(myheader, fw)

# Generate rows
for(i in 1:howmany){
    explevel <- sample(0:max_gene_exp, 1)
    genenum <- sample(1:max_gene_num, 1)
    chronum <- sample(1:max_chro_num, 1)
    genename <- paste0('g_', genenum)
    chroname <- paste0('c_', chronum)

    oline <- paste(chronum, chroname, genenum, genename, explevel, sep=tokensep)
    writeLines(oline, fw)
}
log_info("successfully written {howmany} lines", namespace=ns_log)

close(fw)
log_info("file '{opath}' successfully closed", namespace=ns_log)
log_info("======================= END RUN =======================", namespace=ns_log)
