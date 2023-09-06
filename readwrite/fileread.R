# Example of using fread() function to read a big file

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
cat(sprintf("size = %s\n", format(object.size(rawdata), units='auto')))
cat(sprintf("rows = %d, columns = %d\n", nrow(rawdata), ncol(rawdata)))
head(rawdata)
