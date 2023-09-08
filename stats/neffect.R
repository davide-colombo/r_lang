# Demonstrate how the shape of the empirical distribution
# changes as the sample size increases
set.seed(673287)

pdf("plots/hist_neffect.pdf")

# 3x3 = 9 graphs
# fill columns before
par(mfcol=c(3,3))

n <- c(12, 17, 25, 30, 45, 60, 77, 89, 100)
for(nsamples in n){
    rawX <- rnorm(nsamples, mean=36.7, sd=4.23)
    hist(rawX, main=paste("n =", nsamples), col='#FF6600', freq=FALSE)
    curve(dnorm(x, mean=mean(rawX), sd=sd(rawX)), add=TRUE, col='#0066FF')
}
dev.off()
