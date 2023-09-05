# Simple example of how to use multi-dimensional vectors in R

z <- 1:10
print(z)
print("dim(z)")
print(dim(z))

print("Now assign the dim() attribute of z")
print("dim(z) <- c(2, 5)")
dim(z) <- c(2, 5)
print(paste0("dim(z) = ", dim(z)))
