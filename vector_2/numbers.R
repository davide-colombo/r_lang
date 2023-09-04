# Simple example on numeric vectors


print("Using the ':' operator")
print("v1 <- 1:4")
v1 <- 1:4
print(v1)

print("Using the 'c()' function")
print("v2 <- c(10, 9, 13, 13, 13, 5, 5, 89, 0, -32)")
v2 <- c(10, 9, 13, 13, 13, 5, 5, 89, 0, -32)
print(v2)

print("Evaluating expression '1/v1'")
print(1/v1)

print("Demonstrate vector arithmetic")
v1 <- 1:4
v2 <- 2:5
print(v1)
print(v2)
print("v1 + v2 - (v1 * v2)")
print(v1 + v2 - (v1*v2))

print("Demonstrate arithmetic with vectors of different length")
v1 <- 1:7
print(length(v1))
v2 <- c(2, 4, 8)
print(length(v2))

print("2 * v2 + v1 + 1")
print(2*v2 + v1 + 1)

print("Demonstrate min() and max() functions")
print("max(v1)")
print(max(v1))

print("min(v2)")
print(min(v2))

print("Demonstrate range() function")
print("range(1, 10)")
print(range(1, 10))

print("Demonstrate use of the seq() function")
print("seq(20) -> generates a sequence from 1 to 20")
print(seq(20))

print("seq(from=3, to=15) generates a sequence from 3 to 15")
print(seq(from=3, to=15))

print("seq(from=7, to=2, by=-1) generates a sequence from 7 to 2")
print(seq(from=7, to=2, by=-1))

print("seq(from=0, to=20, length.out=13)")
print(seq(from=0, to=20, length.out=13))
