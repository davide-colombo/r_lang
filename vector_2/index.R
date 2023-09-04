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
