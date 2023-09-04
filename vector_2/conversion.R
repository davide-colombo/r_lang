# Demonstrate the "as.*" functions

print("A simple numerical vector")
z <- 0:9
print(z)
print(paste0("mode(z) = ", mode(z)))
print(paste0("length(z) = ", length(z)))
print(paste0("attributes(z) = ", attributes(z)))

print("=========================================================")
print("as.character(z)")
digits <- as.character(z)
print(digits)
print(paste0("mode(digits) = ", mode(digits)))
print(paste0("length(digits) = ", length(digits)))
print(paste0("attributes(digits) = ", attributes(digits)))

