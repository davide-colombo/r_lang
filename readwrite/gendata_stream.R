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
cf_gendata_stream = yaml.load_file(conf_path)$gen

# Setting up the logger
cf_l_genstream = cf_gendata_stream$logger
ns_l_genstream = cf_l_genstream$namespace
lpath_genstream = file.path(cf_l_genstream$dirname, cf_l_genstream$fname)
log_appender(appender=appender_file(lpath_genstream, append=TRUE))
log_threshold(level=cf_l_genstream$level, namespace=ns_l_genstream)

# IMPORTANT INSIGHT: if I pass the proper namespace, the level is properly set
# log_threshold(namespace=lognamespace)

log_info("======================= START RUN =======================", namespace=ns_l_genstream)

# Output configuration
cf_o_genstream = cf_gendata_stream$output
tokensep = cf_o_genstream$sep

# Output directory
odir_genstream = cf_o_genstream$dirname
if(!dir.exists(odir_genstream)){
    log_info("creating directory '{odir_genstream}'", namespace=ns_l_genstream)
    dir.create(odir_genstream)
}

# Output file
ofname_genstream = cf_o_genstream$fname
opath_genstream = file.path(odir_genstream, ofname_genstream)
log_info("output file: {opath_genstream}", namespace=ns_l_genstream)
if(!file.exists(opath_genstream)){
    log_info("creating file '{opath_genstream}'", namespace=ns_l_genstream)
    file.create(opath_genstream)
}

# Setting up the generator parameters
cf_p_genstream = cf_gendata_stream$param
set.seed(cf_p_genstream$seed)
howmany = cf_p_genstream$howmany
max_gene_num = cf_p_genstream$max_gene_num
max_chro_num = cf_p_genstream$max_chro_num
max_gene_exp = cf_p_genstream$max_gene_exp

# File connection
con_w_genstream <- file(opath_genstream, "wt")
log_info("file '{opath_genstream}' successfully opened", namespace=ns_l_genstream)

# Header
myheader <- paste(
    'chromosome_id', 'chromosome_name',
    'gene_id', 'gene_name', 'read_count',
    sep=tokensep
)
writeLines(myheader, con_w_genstream)

# Generate rows
for(i in 1:howmany){
    explevel <- sample(0:max_gene_exp, 1)
    genenum <- sample(1:max_gene_num, 1)
    chronum <- sample(1:max_chro_num, 1)
    genename <- paste0('g_', genenum)
    chroname <- paste0('c_', chronum)

    oline <- paste(chronum, chroname, genenum, genename, explevel, sep=tokensep)
    writeLines(oline, con_w_genstream)
}
log_info("successfully written {howmany} lines", namespace=ns_l_genstream)

close(con_w_genstream)
log_info("file '{opath_genstream}' successfully closed", namespace=ns_l_genstream)
log_info("======================= END RUN =======================", namespace=ns_l_genstream)
