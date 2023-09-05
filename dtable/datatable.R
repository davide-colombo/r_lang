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
