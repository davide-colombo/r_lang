# Simple demo for computing the GC content using Bioconductor suite

library(Biostrings)


sequence <- DNAString("TGGACGGAGAACTGATAAGGA")
print(sequence)

freqs <- letterFrequency(sequence, letters = c("G", "C"))
print(freqs)

gc_perc = sum(freqs) / length(sequence) * 100
print(gc_perc)

