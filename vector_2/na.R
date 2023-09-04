# Demonstrate "not-available" values

y <- c('a', 'f')
x <- c(1:10, NA, y, NA)
print(y)
print(x)

print("is.na(x)")
print(is.na(x))

z <- c(1:3, NA, NA, NaN, 1:3, NaN)
print(z)
print("is.na(z)")
print(is.na(z))

print("is.nan(z)")
print(is.nan(z))

