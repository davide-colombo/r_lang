# Demonstrate usage of "slice" operator

y <- c(1:4, NA, 'a', 5:2, 'f', NaN)
x <- y[!is.na(y)]

print(y)
print("y[!is.na(y)]")
print(x)

print("NOTE: the 'NaN' value has been coerced to STRING!!!")

print("Demonstrate the NaN coertion to string")
y <- c(1:3, NA, 5:2, NaN)
print(y)
print("y[!is.na(y)]")
print(y[!is.na(y)])

print("Demonstrate the usage of a positive integral vector")
x <- 1:10
print("1:10")
print(x)
i <- c(2, 3, 6, 7, 8)
print(paste0("Indices: ", i))

print("x[i]")
out <- x[i]
print(out)
