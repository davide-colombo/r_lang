# Demonstrate how to use the readLines() function

odir = './ioexamples'

if(!dir.exists(odir)){
    dir.create(odir)
}

fn <- file.path(odir, 'ex.data')
cat("TITLE extra line", "2 3 5 7", "", "11 13 17", file=fn)
