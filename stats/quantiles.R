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

n = 500
true_mu = 42.1
true_sd = 5.67

# Raw data
# x <- rnorm(n=n, mean=true_mu, sd=true_sd)
x <- sample(rnorm(n=1, mean=true_mu, sd=true_sd), size=n, replace=TRUE)

# Sorted
x <- sort(x)

# Unique
xu <- unique(x)

# ==========================================================
# DISTRIBUTIONS
# ==========================================================

# Frequency of each unique value in 'x'
xf <- sapply(xu, function(vu) sum(x == vu))

# Relative frequency of each unique value in 'x'
xrf <- sapply(xu, function(vu) sum(x == vu)) / n

# Cumulative frequency of each unique value in 'x'
xcf <- cumsum(xf)

# Cumulative relative frequency
xcrf <- cumsum(xf) / n

# cat(sprintf("%s\n", paste('x =', round(xu, 2), 'abs =', xf, 'rel =', xrf, 'cum =', xcf, 'crel =', xcrf, sep='\t')))

# ==========================================================
# QUANTILES
# ==========================================================

# First way to compute any quantile:
# Look at the value of X at which the cumulative relative frequency distribution
# passes the desired value (e.g., 0.05 or 5%)
probs = seq(0, 1, by=0.05)

# NOTE: if we are using the cumulative distribution, then we need to extract
# the value from the array of UNIQUE VALUES, not from 'x'!!
q_approach1 = sapply(probs, function(p) xu[which.min(abs(xcrf-p))])

# Instead, for the second (and more precise) approach we can
q_approach2 = sapply(seq(0.05, 1, by=0.05), function(p) x[n*p])
q_approach2 = c(x[1], q_approach2)

# Builtin function
q <- quantile(x, probs=probs, na.rm=FALSE)

cat(sprintf("%s\n",
            paste('p =', probs, 'q1 =', q_approach1, 'q2 =', q_approach2, 'q =', q, sep='\t')
    )
)

# ==========================================================
# GRAPHS
# ==========================================================

# opath <- 'plots/combined_x.pdf'
# xf_ylim = c(0, round(max(xf)+5))
# xrf_ylim = c(0, max(xrf))
# xcf_ylim = c(0, round(max(xcf)))
# xcrf_ylim = c(0, ceiling(max(xcrf)))
#
# pdf(opath, onefile=TRUE)
# par(mfrow=c(2, 2))
#
# plot(xu, xf, cex=0.5, main=paste('Frequency (n =', n, ')'), xlab='X [units]', ylab='Frequency', ylim=xf_ylim, xaxs='i', yaxs='i')
# axis(1, at=xu)  # bottom axis
# axis(2, at=xf)  # left axis
# curve(n*dnorm(x, mean=mean(x), sd=sd(x)), add=TRUE, col='#FF6600', lty=2)
#
# plot(xu, xrf, cex=0.5, main=paste('Relative frequency (n =', n, ')'), xlab='X [units]', ylab='Relative frequency', ylim=xrf_ylim)
# curve(dnorm(x, mean=mean(x), sd=sd(x)), add=TRUE, col='#FF6600', lty=2)
#
# plot(xu, xcf, cex=0.5, main=paste('Cumulative frequency (n =', n, ')'), xlab='X [units]', ylab='Cumulative frequency', ylim=xcf_ylim)
# curve(n*pnorm(x, mean=mean(x), sd=sd(x)), add=TRUE, col='#FF6600', lty=2)
#
# plot(xu, xcrf, cex=0.5, main=paste('Relative cumulative frequency (n =', n, ')'), xlab='X [units]', ylab='Relative cumulative frequency', ylim=xcrf_ylim)
# curve(pnorm(x, mean=mean(x), sd=sd(x)), add=TRUE, col='#FF6600', lty=2)
#
# dev.off()
