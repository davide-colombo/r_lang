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
set.seed(123456)

n = 20
true_mu = 42.1
true_sd = 5.67

# Raw data
# x <- rnorm(n=n, mean=true_mu, sd=true_sd)
x <- sample(rnorm(n=1, mean=true_mu, sd=true_sd), size=n, replace=TRUE)

# Sorted
x <- sort(x)

# Unique
xu <- unique(x)

# Frequency of each unique value in 'x'
xf <- sapply(xu, function(vu) sum(x == vu))

# Relative frequency of each unique value in 'x'
xrf <- sapply(xu, function(vu) sum(x == vu)) / n

# Cumulative frequency of each unique value in 'x'
xcf <- cumsum(xf)

# Cumulative relative frequency
xcrf <- cumsum(xf) / n

# cat(sprintf("%s\n", paste('x =', round(xu, 2), 'abs =', xf, 'rel =', xrf, 'cum =', xcf, 'crel =', xcrf, sep='\t')))

opath <- 'plots/combined_x.pdf'
pdf(opath)
par(mfrow=c(2, 2))
# hist(x, col='#00FF66', main=paste('Absolute frequency (n =', n, ')'))
# hist(x, col='#0066FF', main=paste('Relative frequency (n =', n, ')'), freq=FALSE)
plot(xu, xf)
plot(xu, xrf)
plot(xu, xcf)
plot(xu, xcrf)
curve(pnorm(x, mean=mean(x), sd=sd(x)), add=TRUE, col='#FF6600', lty=2)
dev.off()

# Rank of the data
xrk <-rank(x)
print(xrk)

# # Using the quantile() function to compute quartiles
# probs = seq(0, 1, 0.25)
# q4 <- quantile(x, probs=probs, na.rm=FALSE)
# # cat(sprintf("quartiles: %s\n", paste(q4, probs)))
#
# # Using the quantile() function to compute deciles
# probs = seq(0, 1, 0.1)
# q10 <- quantile(x, probs=probs, na.rm=FALSE)
# # cat(sprintf("deciles: %s\n", paste(q10, probs)))
