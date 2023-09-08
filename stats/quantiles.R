# Demonstrate how to compute quantiles

# What are quantiles?
# Quantiles are cut points into the range of the variable of interest
# (say X). They divide the range of a probability distribution into
# continuous intervals with equal probabilities.
#
# The same is valid for the sampling distribution.
# Quantiles are based on the concept of dividing the range of the observed
# data into equally probable intervals.
#
# The best thing is to assign a rank to the data.
# See: https://en.wikipedia.org/wiki/Quantile

# THIS IS THE WRONG APPROACH!
# xs = sort(x)
# x_norm = (xs - min(x)) / (max(x) - min(x))
# probs = seq(0, 1, 0.25)
# indices = sapply(probs, function(p) which.min(abs(x_norm-p)))
# q = xs[indices]
#
# WHY IS THIS WRONG?
# Because the cut points are not equally likely, especially for a set of data
# with repeated samples.

x <- sample(x=23:89, size=100, replace=TRUE)

# Using the quantile() function to compute quartiles
probs = seq(0, 1, 0.25)
q4 <- quantile(x, probs=probs, na.rm=FALSE)
cat(sprintf("quartiles: %s\n", paste(q4, probs)))

# Using the quantile() function to compute deciles
probs = seq(0, 1, 0.1)
q10 <- quantile(x, probs=probs, na.rm=FALSE)
cat(sprintf("deciles: %s\n", paste(q10, probs)))

# opath <- 'plots/hist_quantiles.pdf'
# pdf(opath)
# hist(x, col='#00FF66', main=paste('Random sample with replacement, n =', n))
# dev.off()
