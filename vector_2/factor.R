# Demonstrate how to use factor objects in R

sex <- c("m", "f", "m", "m", "f", "m", "f", "f")
print(sex)

print("Creating a factor")
f <- factor(sex)
print(f)
print(mode(f))
print(storage.mode(f))
print(length(f))

print("Inspecting the attributes of a factor object")
print(paste0("levels(f) = ", levels(f)))
print(paste0("class(f) = ", class(f)))
