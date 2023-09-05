# Demonstrate how to use list objects

l1 <- list(
        name="Fred",
        wife="Mary",
        no.childer=3,
        child.ages=c(4, 7, 9)
    )

cat("Demonstrate how to create a list")
cat(paste(l1, collapse = ', '), "\n")

cat(paste("length = ", length(l1)), "\n")
cat(paste("object.size(l1) = ", format(object.size(l1), units='auto')), "\n")

cat("List subsetting with items\n")
for (item in l1){
    cat(sprintf("item = %s\n", item))
}

# NOTE: the above print each item in the list AS IF IT IS A VECTOR!!

cat("List subsetting with [[index]]\n")
for(i in 1:length(l1)){
    cat(sprintf("l1[[%d]] = %s\n", i, l1[[i]]))
}

# NOTE: cycling through a list by using the index 'i' gives much a better
#       sense of the structure of the list!!

cat("Referring by: name$component\n")
cat(sprintf("name: %s\n", l1$name))
cat(sprintf("wife: %s\n", l1$wife))

# NOTE: this is completely ignored!!!
cat(sprintf("this_does_not_exist: %s\n", l1$notexist))

cat("Demonstrate how to extract the named components from a list by
    using the value of a variable\n")
mynames <- c('gene1', 'gene33', 'gene45')

ngenes <- 45
geneseq <- seq(ngenes)

basename <- 'gene'
mygenes <- list(
    genename=paste0(basename, geneseq),
    genelevel=geneseq
)

cat("Extract all the genes from the list where there is a match\n")
mylevels <- mygenes$genelevel[mygenes$genename %in% mynames]
cat(sprintf("%s\n", mylevels))
