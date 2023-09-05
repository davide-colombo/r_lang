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

print("Example on an actual matrix object")
x <- matrix(1:20, nrow=4, ncol=5)
print(x)
print(dim(x))

indices <- array(c(1:3, 3:1), dim=c(3, 2))
print("Creating matrix of indices")
print(indices)
print(dim(indices))

print("Use the matrix of indices to extract the elements from the other matrix")
print(x[indices])

print("Demonstrate mixed arithmetic between vector and arrays")

# NOTE: arrays are just vectors in multiple dimensions.
# An array is the generalization of the vector object.
# Can hold data of the same type
# Matrix is a convenient abstraction for a 2D vector

v <- 1:9
m <- matrix(1:9, nrow=3)
print(v)
print(dim(v))
print(m)
print(dim(m))

print("m + v")
print(m + v)
# NOTE: it is possible to sum 'm' (3x3) and 'v' (1x9)
# only because the size of 'm' is a multiple of 'v'

print("But it is possible to sum a shorter array to a matrix")
v <- 1:5
print(v)
print(dim(v))
print("sum matrix (i.e., 2D array) with vector object")
print(m + v)

# Inspecting the matrix object
print("Inspect the matrix object")
print(paste0("mode(m) = ", mode(m)))
print(paste0("storage.mode(m) = ", storage.mode(m)))
print(paste0("typeof(m) = ", typeof(m)))
