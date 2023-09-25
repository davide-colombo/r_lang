# Differential gene expression analysis of short non-coding RNAs
# from Aedes albopictus mosquitoes.
#
# Source: ENA database
# Project Accession: PRJNA293817
# Sample Accession: SAMN04010069
# Experiment Accession: SRX1163797
# Run Accession: SRR2182471

library(ShortRead)      # FastQ files manipulation
library(Biostrings)     # DNASequence manipulation
library(data.table)     # Efficient manipulation of data
library(stringr)        # str_count() function
library(ggplot2)        # Graphs

# Input directory
dir_in <- "./fastq"

# Input files
files_in <- list.files(dir_in, pattern = "\\.fastq")

# Error
if(length(files_in) == 0){
    stop(sprintf("Error: no file found in %s\n", dir_in))
}

# Process each FastQ file
for(fn in files_in){
    fp = file.path(dir_in, fn)

    # ==========================================================================
    # Read raw FastQ file
    # ==========================================================================
    fastq_raw <- readFastq(fp)

    # Reads
    reads_raw <- sread(fastq_raw)

    # Reads length
    reads_length <- width(fastq_raw)

    # ==========================================================================
    # Reads quality
    # ==========================================================================
    reads_qual <- quality(fastq_raw)

    # Convert ASCII to character
    phred_score <- as(reads_qual, "matrix")

    # Data.table object
    dt_qual <- data.table(PhredMean = colMeans(phred_score, na.rm = TRUE),
                          NReads = colSums(!is.na(phred_score)))

    # ==========================================================================
    # Per base sequence quality
    # ==========================================================================
    plot_phred <- ggplot(dt_qual) +
        geom_line(aes(x = 1:nrow(dt_qual), y = PhredMean), color = "#121212") +
        ylim(0, NA) +
        labs(x = "Nucleotide position", y = "Phred score",
             title = "Per base sequence quality, Sanger scale") +
        theme_minimal()

    pdf( file.path("./plots", "reads_phred_per_base.pdf"), onefile = TRUE)
    print(plot_phred)
    dev.off()

    # ==========================================================================
    # GC content
    # ==========================================================================
    gc_freq <- rowSums( letterFrequency(reads_raw, letters = c("G", "C")) )
    gc_perc <- gc_freq / reads_length * 100

    # Data.table much better to do computations
    dt <- data.table(Reads = as.character(reads_raw),
                     Length = reads_length,
                     GCFreq = gc_freq,
                     GCPerc = gc_perc)

    # Filter out duplicates after grouping by sequence
    dt_dups <- unique(dt[, .(Length, GCFreq, GCPerc, NCopies = .N), by = Reads][order(-NCopies)])

    # Count number of sequences longer than 30 nucleotides
    dt_longer <- dt[Length > 30, .(Count = .N, Perc = .N / nrow(dt) * 100)]
    # print(dt_longer)

    # These occupy just a small fraction of the reads, it can be due to artifacts in the library
    # for example capturing or purification

    # Filter out sequences longer than 30 nucleotides
    dt_filt <- dt[Length < 31]
    # print(dt_filtered)

    # Count duplicates on filtered reads
    dt_dups_filt <- unique(dt_filt[, .(Length, GCFreq, GCPerc, NCopies = .N), by = Reads][order(-NCopies)])
    # print(dt_dups_filt)

    # ==========================================================================
    # Duplicates
    # ==========================================================================
    dt_dups_filt_more10copies <- dt_dups_filt[NCopies > 10, .(Count = .N, Perc = .N / nrow(dt_dups_filt) * 100)]
    print(dt_dups_filt_more10copies)

    dt_dups_filt_more100copies <- dt_dups_filt[NCopies > 100, .(Count = .N, Perc = .N / nrow(dt_dups_filt) * 100)]
    print(dt_dups_filt_more100copies)

    dt_dups_filt_more1000copies <- dt_dups_filt[NCopies > 1000, .(Count = .N, Perc = .N / nrow(dt_dups_filt) * 100)]
    print(dt_dups_filt_more1000copies)

    dt_dups_filt_more10000copies <- dt_dups_filt[NCopies > 10000, .(Count = .N, Perc = .N / nrow(dt_dups_filt) * 100)]
    print(dt_dups_filt_more10000copies)

    # ==========================================================================
    # GC percentage
    # ==========================================================================
    dt_filt_gc_mean <- dt_filt[, .(Mean = mean(GCPerc), SD = sd(GCPerc), Count = .N)]
    print(dt_filt_gc_mean)

    # ==========================================================================
    # RNA species column
    # ==========================================================================
    dt_rnas <- dt_filt[, .(Reads, Length, GCFreq, GCPerc, RNAType = ifelse(Length > 18 & Length < 24, "si", "pi"))][order(GCFreq)]
    # print(dt_rnas)

    dt_rnas_gc_stats <- dt_filt[, .(Mean = mean(GCFreq), SD = sd(GCFreq)) ]

    dt_rnas <- dt_rnas[, .(Reads, Length, GCFreq, GCPerc, RNAType, GCecdf = ecdf(GCFreq)(GCFreq))]
    # print(dt_rnas_ecdf)

    dt_rnas <- dt_rnas[, .(Reads, Length, GCFreq, GCPerc, RNAType, GCecdf, GCtcdf = pnorm(GCFreq, mean = dt_rnas_gc_stats$Mean, sd = dt_rnas_gc_stats$SD))]
    # print(dt_rnas_gc_dist)

    dt_rnas <- dt_rnas[, .(Reads, Length, GCFreq, GCPerc, RNAType, GCecdf, GCtcdf, GCDevAbs = abs(GCecdf - GCtcdf))]
    print(dt_rnas)

    t_test_res <- t.test(dt_rnas$GCDevAbs, mu = 0)
    print(t_test_res)

    # ==========================================================================
    # Small interfering RNAs
    # ==========================================================================
    dt_sirna <- dt[Length > 18 & Length < 24]
    # print(dt_sirna)

    dt_sirna_gc <- dt_sirna[, .(Mean = mean(GCPerc), SD = sd(GCPerc), Count = .N)]
    # print(dt_sirna_gc)

    # ==========================================================================
    # PIWI-interacting RNAs
    # ==========================================================================
    dt_pirna <- dt[Length > 23 & Length < 31]
    # print(dt_pirna)

    dt_pirna_gc <- dt_pirna[, .(Mean = mean(GCPerc), SD = sd(GCPerc), Count = .N)]
    # print(dt_pirna_gc)

    # ==========================================================================
    # Read length distribution siRNA
    # ==========================================================================
    nbins <- nrow(dt_sirna[, .N, by = Length])
    hist_sirna <- ggplot(dt_sirna, aes(x = Length)) +
        geom_histogram(bins = nbins, color = "black", fill = "blue") +
        labs(x = "Read Length", y = "Frequency", title = "Frequency Distribution of Read Lengths - small interfering RNAs") +
        theme_minimal()

    # histogram <- hist(read_lengths, breaks = 20, col = "blue", main = "Frequency Distribution of Read Lengths", xlab = "Read Length", ylab = "Frequency")
    pdf( file.path("./plots", "sirna_length_distribution.pdf"), onefile = TRUE)
    print(hist_sirna)
    dev.off()

    # ==========================================================================
    # Read length distribution piRNA
    # ==========================================================================
    nbins <- nrow(dt_pirna[, .N, by = Length])
    hist_pirna <- ggplot(dt_pirna, aes(x = Length)) +
        geom_histogram(bins = nbins, color = "black", fill = "blue") +
        labs(x = "Read Length", y = "Frequency", title = "Frequency Distribution of Read Lengths - PIWI-interacting RNAs") +
        theme_minimal()

    # histogram <- hist(read_lengths, breaks = 20, col = "blue", main = "Frequency Distribution of Read Lengths", xlab = "Read Length", ylab = "Frequency")
    pdf( file.path("./plots", "pirna_length_distribution.pdf"), onefile = TRUE)
    print(hist_pirna)
    dev.off()

    # ==========================================================================
    # GC percentage distribution siRNA
    # ==========================================================================
    hist_sirna_gc <- ggplot(dt_sirna, aes(x=GCPerc)) +
        geom_histogram(bins = 20, fill="steelblue", color="black") +
        labs(title="Frequency Distribution of GC Content, small interfering RNAs", x="GC Content (%)", y="Frequency") +
        theme_minimal()

    pdf( file.path("./plots", "sirna_gc_distribution.pdf"), onefile = TRUE )
    print(hist_sirna_gc)
    dev.off()

    # ==========================================================================
    # GC percentage distribution piRNA
    # ==========================================================================
    hist_pirna_gc <- ggplot(dt_pirna, aes(x=GCPerc)) +
        geom_histogram(bins = 20, fill="steelblue", color="black") +
        labs(title="Frequency Distribution of GC Content, PIWI-interacting RNAs", x="GC Content (%)", y="Frequency") +
        theme_minimal()

    pdf( file.path("./plots", "pirna_gc_distribution.pdf"), onefile = TRUE )
    print(hist_pirna_gc)
    dev.off()

    # ==========================================================================
    # GC percentage violin plot piRNA
    # ==========================================================================
    violin_rna_gc <- ggplot(dt_rnas, aes(x=RNAType, y=GCPerc, fill=RNAType)) +
        geom_violin(adjust=2) +
        labs(title="Violin plot of GC content (%): siRNAs VS piRNAs", x="RNA type", y="GC Content (%)") +
        theme_minimal()

    pdf( file.path("./plots", "rnas_gc_violin.pdf"), onefile = TRUE )
    print(violin_rna_gc)
    dev.off()

    # ==========================================================================
    # GC percentage cumulative distribution
    # ==========================================================================
    plot_gc_cdf <- ggplot(dt_rnas) +
        geom_line(aes(x = GCFreq, y = GCecdf), color = "blue") +
        geom_line(aes(x = GCFreq, y = GCtcdf), color = "red") +
        labs(x = "GC Frequency", y = "Empirical CDF VS Theoretical CDF",
             title = "Empirical vs Theoretical CDF of GC content, short ncRNAs",
             subtitle = "Blue: Empirical, Red: Theoretical") +
        theme_minimal()

    pdf( file.path("./plots", "rna_gc_cdf.pdf"), onefile = TRUE)
    print(plot_gc_cdf)
    dev.off()

    # ==========================================================================
    # Write content to a file
    # ==========================================================================
    # fn_split <- strsplit(fn, "\\.")
    # fp_out <- file.path(dir_in, paste0(fn_split[[1]][1], "_filtered.", fn_split[[1]][2]))

    # NOTE: need to set compress to FALSE!!!
    # writeFastq(filtered_reads, file = fp_out, full = TRUE, compress = FALSE, mode = "w")
}
