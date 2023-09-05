# Simple example of how to use multi-dimensional vectors in R

z <- 1:10
print(z)
print("dim(z)")
print(dim(z))

print("Now assign the dim() attribute of z")
print("dim(z) <- c(2, 5)")
dim(z) <- c(2, 5)
print(paste0("dim(z) = ", dim(z)))

z[1, 1] <- 1
z[2, 1] <- 2
z[1, 2] <- 3
z[2, 2] <- 4
z[1, 3] <- 5
z[2, 3] <- 6
z[1, 4] <- 7
z[2, 4] <- 8
z[1, 5] <- 9
z[2, 5] <- 10

print("COLUMN MAJOR ORDERING")
print(z)
