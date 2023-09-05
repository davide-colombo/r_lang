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

print("Demonstrate how to use cbind() function")

m1 <- matrix(1:9, nrow=3)
print(m1)

m2 <- matrix(1:27, nrow=3)
print(m2)

# cbind() works fine if the matrices have the same number of rows!!
m3 <- cbind(m1, m2)
print(m3)

print("Vector of 19 elements: ")
m4 <- 1:19
print(m4)

print("Demonstrate cbind() with arrays of different size")
m5 <- cbind(m3, m4)
print(m5)

print("Demonstrate rbind() with arrays of different size")
m6 <- rbind(m3, m4)
print(m6)

# NOTE: the rbind() function only appends rows of the same size of a matrix!
#       So, if a vector has more elements that the "NUMBER OF COLUMNS" of the
#       matrix, then rbind() stops appending elements from the vector when the
#       row is saturated.
#
#       In other words, the "RECYCLING RULE" does not apply!!

print("A shorter vector")
vshort <- 1:2
print(vshort)

print("Demonstrate cbind() between matrix and shorter vector")
m7 <- cbind(m3, vshort)
print(m7)

# NOTE: the recycling rule does apply here!!

print("Demonstrate rbind() between matrix and shorter vector")
m8 <- rbind(m3, vshort)
print(m8)
