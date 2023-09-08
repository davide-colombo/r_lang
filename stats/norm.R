# Demonstrate how to use normal distribution in R
set.seed(579829)

# Population parameters
true_mean <- 37.9
true_sd <- 4.56

# Generate random samples from a normal distribution
nsamples <- 15
rawX <- rnorm(nsamples, mean = true_mean, sd=true_sd)

cat(sprintf("length: %d\n", length(rawX)))
cat(sprintf("mode: %s\n", mode(rawX)))
cat(sprintf("storage.mode: %s\n", storage.mode(rawX)))

odir_plot <- "plots"
opath <- file.path(odir_plot, 'hist_raw.pdf')
title=paste('Histogram of', nsamples,
            'samples from a Normal distribution, mean=',
            true_mean, 'sd=', true_sd)

myxlim=c(round(min(rawX)-10), round(max(rawX)+10))
pdf(opath, onefile=TRUE)
hist(rawX, main=title, freq=FALSE, xlim=myxlim, col='#FF6600')
curve(dnorm(x, mean=mean(rawX), sd=sd(rawX)), add=TRUE, col='#0066FF', lty=2)
curve(dnorm(x, mean=true_mean, sd=true_sd), add=TRUE, col='#00EE66')
dev.off()
