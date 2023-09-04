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

print("Demonstrate the usage of factor objects with NA values")
nums <- c(1, 2, NA, 4, 5, NA, 7, 8)
print(nums)
print(paste("mode(nums) = ", mode(nums), ", storage.mode(nums) = ", storage.mode(nums)))

# This considers NA values as a new level
ff <- factor(nums, exclude=NULL)
print(paste("levels(ff) = ", levels(ff)))

print("==================================================")
print("Before setting NA values")
print(paste("is.na(ff) = ", is.na(ff)))

# The problem with this is that now the 'is.na()' function is broken
is.na(ff)[is.na(nums)] <- TRUE

print("==================================================")
print("After having set NA values properly")
print(paste("is.na(ff) = ", is.na(ff)))
