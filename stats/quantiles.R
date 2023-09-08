# Demonstrate how to compute quantiles

r <- 23:89
x <- sample(x=r, size=length(r), replace=FALSE)

quartiles_q <- quantile(x, probs=seq(0, 1, 0.25))
print("Quartiles: ")
print(quartiles_q)

deciles_q <- quantile(x, probs=seq(0, 1, 0.1))
print("Deciles: ")
print(deciles_q)

xs = sort(x)
print(xs)
x_norm = (xs - min(x)) / (max(x) - min(x))
print(x_norm)
probs = seq(0, 1, 0.25)
indices = sapply(probs, function(p) which.min(abs(x_norm-p)))
q = xs[indices]
print(q)

# opath <- 'plots/hist_quantiles.pdf'
# pdf(opath)
# hist(x, col='#00FF66', main=paste('Random sample with replacement, n =', n))
# dev.off()
