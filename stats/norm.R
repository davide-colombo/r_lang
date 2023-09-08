# Demonstrate how to use normal distribution in R
set.seed(579829)

# Population parameters
true_mean <- 37.9
true_sd <- 4.56

# Generate random samples from a normal distribution
nsamples <- 30
rawX <- rnorm(nsamples, mean = true_mean, sd=true_sd)

cat(sprintf("length: %d\n", length(rawX)))
cat(sprintf("mode: %s\n", mode(rawX)))
cat(sprintf("storage.mode: %s\n", storage.mode(rawX)))

odir_plot <- "plots"
opath <- file.path(odir_plot, 'hist_raw.pdf')
pdf(opath, onefile=TRUE)
hist(rawX)
dev.off()
