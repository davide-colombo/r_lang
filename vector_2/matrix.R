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

# Consider a 3D array
print("a <- array(1:24, dim=c(3, 4, 2))")
a <- array(1:24, dim=c(3, 4, 2))
print(a)

# Now let's take the second row from 'a'
print("a[2,,]")
r <- a[2,,]
print("dim(a[2,,])")
print(dim(r))

# The multi-dimensional vector 'r' contains
# the values of 'a' in this order:
# c(a[2,1,1], a[2,2,1], a[2,3,1], a[2,4,1],
#   a[2,1,2], a[2,2,2], a[2,3,2], a[2,4,2])

