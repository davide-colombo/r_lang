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
