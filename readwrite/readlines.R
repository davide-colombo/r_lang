# Demonstrate how to use the readLines() function

odir = './ioexamples'

if(!dir.exists(odir)){
    dir.create(odir)
}

fn <- file.path(odir, 'ex.data')
if(!file.exists(fn)){
    cat("wrote file: ", fn, "\n")
    cat("TITLE extra line", "2 3 5 7", "", "11 13 17\n", file=fn)
}

# Read the entire file
cat("Demonstrate how to use readLines()\n")
readLines(fn, n = -1)   # read the whole file

# NOTE: readLines() throws an error if the last line
#       does not contain a '\n'!!!

