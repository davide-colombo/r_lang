# Test how to use Data frame objects

library(dplyr)          # filter() function

df <- data.frame(
    x = c(1, 2, 3, 4),
    y = c("a", "b", "c", "d")
    )

print(df)
print(mode(df))
print(storage.mode(df))
print(typeof(df))
print(format(object.size(df), units='auto'))

print("Most efficient way to subset a data frame")
print("df %>% filter(x > 2)")
df %>% filter(x > 2)
