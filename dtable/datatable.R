# Demonstration of how to use the data.table package
# This is a much more efficient way to read file and
# manipulate the content.

library("data.table")

dt <- data.table(A=5:1, B=letters[5:1])
cat("Data table\n")
dt

cat("Demonstrate how to 'setkey' to sort a data table\n")
cat("setkey(dt, B)\n")
setkey(dt, B)

cat("Demonstrate data table sorted by B\n")
dt

cat("Demonstrate how to use 'tables()' to get a summary of a data table\n")
tables()

cat("Demonstrate assignment (not copy)\n")
dt2 = dt
setkey(dt2, B)

cat("Test whether or not the two data tables are identical\n")
identical(dt, dt2)

cat("Demonstrate copy()\n")
dt = data.table(A=5:1, B=letters[5:1])
dt3 = copy(dt)
setkey(dt3, B)

cat("Test whether or not the two data tables are identical\n")
identical(dt3, dt)

# ===================================================================
# DEMONSTRATE HOW TO USE 'fread()' FUNCTION TO EFFICIENTLY READ FILES
# ===================================================================

# https://rdatatable.gitlab.io/data.table/reference/fread.html

data = "A,B,C,D\n1,3,5,7\n2,4,6,8\n"
dt = fread(data, colClasses=list(character=2:4))

# NOTE: alternatively:
#       colClasses=c(B="character", ...)
#       colClasses=list(character=c("B", ...))

dt

cat("Demonstrate how to drop columns directly while reading\n")
dt = fread(data, drop=2:3)

# NOTE: alternatively
#       colClasses=c("B"="NULL", ...)
#       colClasses=list(NULL=c("B", ...))
#       drop=c("B", ...)
#
#       The third alternative may be useful if we read the configuration
#       from a file (e.g. yaml or json)

dt

cat("Demonstrate how to select columns directly while reading\n")
dt = fread(data, select=2:3)
dt

cat("Demonstrate how to skip blank lines\n")
data = "a,b\n1,a\n2,b\n\n3,c\n"
data

cat("... after reading data\n")
dt = fread(data, blank.lines.skip=TRUE)
dt
