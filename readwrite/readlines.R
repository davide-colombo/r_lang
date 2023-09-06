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
ff <- file(fn, 'r')
if(ff){
    print("Connection successfully opened")
}

print("Demonstrate readLines() on the file connection")
print("readLines(ff)")
readLines(ff)

print("Closing file connection")
close(ff)
ff

# close(ff)     ERROR!

print("Using a temporary file")
ft <- tempfile("test")
ft

cat("123\nabc", file=ft)
readLines(ft)

# NOTE: the last line is incomplete,
#       this generates a warning

print("Demonstrate non-blocking connection")
ff <- file(ft, blocking=FALSE)
cat(sprintf("line: '%s'\n", readLines(ff)))
close(ff)

# NOTE: readLines() stops because of the blocking behavior

print("Demonstrate usage of writeLines() function")
tmp <- file.path(odir, 'cheers.data')
fw <- file(tmp, 'wt')
writeLines(
    c("Hello", "Hola", "Ciao"),
    fw
)

# cat("Hello", "Hola", "Ciao", file=fw, sep='\n')
close(fw)

# ================================================================
# READ FILE THROUGH REPEAT STATEMENT
# ================================================================
print("Demonstrate how to cycle through file using repeat{}")
nlines <- 0
fr <- file(tmp, "rt")
repeat{
    ll <- readLines(fr, n=1)
    if(length(ll) == 0){
        break
    }
    nlines <- nlines+1
    cat(sprintf("ll: %s\tnlines = %d\tlength(ll) = %d\n",
                ll, nlines, length(ll)))
}
close(fr)
cat(sprintf("nlines: %d\n", nlines))

# NOTE: removing the the "rt" flag from file() function call
#       generates an infinite loop!!

# ================================================================
# READ FILE THROUGH WHILE LOOP
# ================================================================
print("Demonstrate how to loop over a file with while()")
nlines <- 0
fr <- file(tmp, "rt")
while(length(ll <- readLines(fr, n=1)) > 0){
    nlines <- nlines+1
    cat(sprintf("ll: %s\tnlines = %d\tlength(ll) = %d\n",
                ll, nlines, length(ll)))
}
close(fr)
cat(sprintf("nlines: %d\n", nlines))

# NOTE: it is crucial to specify always the open=""
#       parameter in the file() function

# ================================================================
# READ FILE BINARY MODE AS BLOCKS
# ================================================================
print("Demonstrate how to count lines using readBin()")
fb <- file(tmp, open="rb")
nlines <- 0L
while(length(chunk <- readBin(fb, "raw", 1024)) > 0){
    nlines <- nlines + sum(chunk == as.raw(10L))
}
cat(sprintf("nlines = %d\n", nlines))
