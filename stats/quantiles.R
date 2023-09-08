# Demonstrate how to compute quantiles

n <- 100
x <- sample(x=23:89, size=n, replace=TRUE)

quartiles_q <- quantile(x, probs=seq(0, 1, 0.25))
print("Quartiles: ")
print(quartiles_q)

deciles_q <- quantile(x, probs=seq(0, 1, 0.1))
print("Deciles: ")
print(deciles_q)

opath <- 'plots/hist_quantiles.pdf'
pdf(opath)
hist(x, col='#00FF66', main=paste('Random sample with replacement, n =', n))
dev.off()
