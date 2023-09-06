# Demonstrate how to use the readLines() function

odir = './ioexamples'

if(!dir.exists(odir)){
    cat(sprintf("Creating directory: %s\n", odir))
    dir.create(odir)
}

fn <- file.path(odir, 'ex.data')
if(!file.exists(fn)){
    cat(sprintf("Creating file %s\n", fn))

    ff <- file(fn, 'w')     # open the file in write mode
    cat("TITLE extra line", "2 3 5 7", "", "11 13 17", file=ff, sep='\n')
    cat("One more line\n", file=ff)
    close(ff)
}

# Read the entire file
cat("Demonstrate how to use readLines()\n")
readLines(fn, n = -1)   # read the whole file

# NOTE: readLines() throws an error if the last line
#       does not contain a '\n'!!!

print("Demonstrate how to open a file connection")
con <- file(fn, 'r')

if(con){
    print("Connection successfully opened")
}

close(con)
