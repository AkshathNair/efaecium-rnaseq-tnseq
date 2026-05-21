# Tn-seq Essentiality Analysis
# E. faecium E745
# Akshath Nair, Uppsala University 2026

library(ggplot2)

# ─── 1. Paths ─────────────────────────────────────────────────────
COUNTDIR <- "C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local/tnseq_counts"
OUTDIR   <- "C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local/tnseq_results"
dir.create(OUTDIR, showWarnings=FALSE)

# ─── 2. Load all count files ──────────────────────────────────────
samples <- c("BHI_rep1","BHI_rep2","BHI_rep3",
             "Serum_rep1","Serum_rep2","Serum_rep3",
             "HSerum_rep1","HSerum_rep2","HSerum_rep3")

count_list <- lapply(samples, function(s) {
  f <- read.table(file.path(COUNTDIR, paste0(s,"_counts.txt")),
                  header=FALSE, row.names=1, stringsAsFactors=FALSE)
  f[,1]
})

count_matrix <- do.call(cbind, count_list)
colnames(count_matrix) <- samples
rownames(count_matrix) <- rownames(read.table(
  file.path(COUNTDIR,"BHI_rep1_counts.txt"), header=FALSE, row.names=1))
count_matrix <- count_matrix[!grepl("^__", rownames(count_matrix)),]
cat("Total genes:", nrow(count_matrix), "\n")

# ─── 3. Calculate mean insertions per condition ───────────────────
bhi_counts    <- count_matrix[, c("BHI_rep1","BHI_rep2","BHI_rep3")]
serum_counts  <- count_matrix[, c("Serum_rep1","Serum_rep2","Serum_rep3")]
hserum_counts <- count_matrix[, c("HSerum_rep1","HSerum_rep2","HSerum_rep3")]

bhi_mean    <- rowMeans(bhi_counts)
serum_mean  <- rowMeans(serum_counts)
hserum_mean <- rowMeans(hserum_counts)

# Normalize to reads per million
bhi_norm    <- (bhi_mean / sum(bhi_mean)) * 1e6
serum_norm  <- (serum_mean / sum(serum_mean)) * 1e6
hserum_norm <- (hserum_mean / sum(hserum_mean)) * 1e6

# ─── 4. Coverage check ────────────────────────────────────────────
cat("Genes with >0 insertions in BHI:", sum(bhi_mean > 0), "\n")
cat("Genes with >0 insertions in Serum:", sum(serum_mean > 0), "\n")
cat("Genes with >0 insertions in HSerum:", sum(hserum_mean > 0), "\n")
cat("% genome covered BHI:", 
    round(100*sum(bhi_mean > 0)/length(bhi_mean), 1), "%\n")
cat("% genome covered Serum:", 
    round(100*sum(serum_mean > 0)/length(serum_mean), 1), "%\n")

# ─── 5. Build results dataframe ───────────────────────────────────
ess <- data.frame(
  gene        = rownames(count_matrix),
  BHI_mean    = bhi_mean,
  Serum_mean  = serum_mean,
  HSerum_mean = hserum_mean,
  BHI_norm    = bhi_norm,
  Serum_norm  = serum_norm,
  HSerum_norm = hserum_norm,
  stringsAsFactors = FALSE
)

# ─── 6. Focus on informative genes ────────────────────────────────
# Only genes with insertions in at least one condition
ess$any_insertions <- (ess$BHI_mean > 0 | ess$Serum_mean > 0 | 
                         ess$HSerum_mean > 0)
informative <- ess[ess$any_insertions,]
cat("\nInformative genes:", nrow(informative), "\n")

# ─── 7. Identify depleted genes ───────────────────────────────────
# Serum depleted = has insertions in BHI but not in Serum
# These are conditionally essential in serum
informative$serum_depleted <- (informative$BHI_mean > 2 & 
                                 informative$Serum_mean == 0)
informative$bhi_depleted   <- (informative$Serum_mean > 2 & 
                                 informative$BHI_mean == 0)

cat("Conditionally essential in Serum:", 
    sum(informative$serum_depleted), "\n")
cat("Depleted in BHI:", 
    sum(informative$bhi_depleted), "\n")

# ─── 8. Log2 fold change of insertions ────────────────────────────
informative$log2FC_serum <- log2((informative$Serum_norm + 1) /
                                   (informative$BHI_norm + 1))

# ─── 9. Categorize genes ──────────────────────────────────────────
informative$category <- "Present in both"
informative$category[informative$serum_depleted] <- "Depleted in Serum"
informative$category[informative$bhi_depleted]   <- "Depleted in BHI"

# ─── 10. Save results ─────────────────────────────────────────────
write.csv(ess, file.path(OUTDIR, "tnseq_essentiality.csv"), row.names=FALSE)
write.csv(informative[informative$serum_depleted,],
          file.path(OUTDIR, "serum_depleted_genes.csv"), row.names=FALSE)
write.csv(informative,
          file.path(OUTDIR, "tnseq_informative_genes.csv"), row.names=FALSE)

# ─── 11. Plot 1: Scatter BHI vs Serum insertions ──────────────────
p1 <- ggplot(informative,
             aes(log2(BHI_norm+1), log2(Serum_norm+1), color=category)) +
  geom_point(alpha=0.6, size=1.5) +
  scale_color_manual(values=c("Present in both"  = "grey60",
                              "Depleted in Serum"= "red",
                              "Depleted in BHI"  = "steelblue")) +
  geom_abline(slope=1, intercept=0, linetype="dashed") +
  theme_bw(base_size=12) +
  labs(title="Tn-seq: Insertions BHI vs Serum",
       subtitle="E. faecium E745 — red = conditionally essential in serum",
       x="Log2 normalized insertions (BHI)",
       y="Log2 normalized insertions (Serum)",
       color="")
ggsave(file.path(OUTDIR,"insertion_scatter.png"),
       p1, width=8, height=7, dpi=300)

# ─── 12. Plot 2: Log2FC distribution ──────────────────────────────
p2 <- ggplot(informative, aes(log2FC_serum, fill=category)) +
  geom_histogram(bins=50, alpha=0.7, position="identity") +
  scale_fill_manual(values=c("Present in both"  = "grey60",
                             "Depleted in Serum"= "red",
                             "Depleted in BHI"  = "steelblue")) +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw(base_size=12) +
  labs(title="Tn-seq: Insertion Fold Change (Serum vs BHI)",
       subtitle="E. faecium E745",
       x="Log2FC insertions (Serum/BHI)",
       y="Number of genes", fill="")
ggsave(file.path(OUTDIR,"insertion_log2FC.png"),
       p2, width=8, height=6, dpi=300)

# ─── 13. Plot 3: Summary bar chart ────────────────────────────────
ess_summary <- data.frame(
  Category = c("Informative\ngenes",
               "Depleted\nin Serum",
               "Depleted\nin BHI"),
  Count = c(nrow(informative),
            sum(informative$serum_depleted),
            sum(informative$bhi_depleted)),
  Color = c("grey60","red","steelblue")
)

p3 <- ggplot(ess_summary, aes(Category, Count, fill=Category)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=Count), vjust=-0.5, size=5) +
  scale_fill_manual(values=c("grey60","steelblue","red")) +
  theme_bw(base_size=12) +
  theme(legend.position="none") +
  labs(title="Tn-seq Essentiality Summary",
       subtitle="E. faecium E745",
       x="", y="Number of Genes")
ggsave(file.path(OUTDIR,"essentiality_summary.png"),
       p3, width=7, height=6, dpi=300)

# ─── 14. Print final summary ──────────────────────────────────────
cat("\n=== FINAL SUMMARY ===\n")
cat("Total genes analyzed:", nrow(ess), "\n")
cat("Informative genes (any insertions):", nrow(informative), "\n")
cat("Conditionally essential in Serum:", 
    sum(informative$serum_depleted), "\n")
cat("Depleted in BHI:", 
    sum(informative$bhi_depleted), "\n")
cat("\nResults saved to:", OUTDIR, "\n")

# Load annotation
annot <- read.table(
  "C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local/Efaecium_E745.tsv",
  sep="\t", header=FALSE, quote="", fill=TRUE,
  stringsAsFactors=FALSE)
colnames(annot) <- c("locus_tag","ftype","length_bp","gene",
                     "EC_number","COG","product")

# Load serum depleted genes
serum_dep <- read.csv(
  "C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local/tnseq_results/serum_depleted_genes.csv")

# Merge with annotation
serum_dep_annot <- merge(serum_dep, 
                         annot[,c("locus_tag","gene","product","COG")],
                         by.x="gene", by.y="locus_tag", all.x=TRUE)

# Sort by BHI insertions (most confident hits first)
serum_dep_annot <- serum_dep_annot[order(serum_dep_annot$BHI_mean, 
                                         decreasing=TRUE),]

# Show top 30
cat("=== TOP SERUM-DEPLETED GENES (Conditionally Essential) ===\n")
print(serum_dep_annot[1:30, c("gene","gene.y","product","BHI_mean","COG")])

# Check if any pur genes are in there
cat("\n=== PUR GENES IN SERUM DEPLETED? ===\n")
serum_dep_annot[grepl("pur", serum_dep_annot$gene.y, ignore.case=TRUE),
                c("gene","gene.y","product","BHI_mean")]

# Save annotated results
write.csv(serum_dep_annot,
          "C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local/tnseq_results/serum_depleted_annotated.csv",
          row.names=FALSE)



# Load annotated results
dep <- read.csv("C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local/tnseq_results/serum_depleted_annotated.csv")

# Load DESeq2 significant results
deseq <- read.csv("C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local/deseq2/DESeq2_Serum_vs_BHI_significant.csv",
                  row.names=1)

# Find overlap — genes both upregulated in RNA-seq AND depleted in Tn-seq
overlap <- dep[dep$gene %in% rownames(deseq),]
cat("=== GENES BOTH UPREGULATED AND CONDITIONALLY ESSENTIAL ===\n")
cat("Total overlap:", nrow(overlap), "\n")
print(overlap[,c("gene","gene.y","product","BHI_mean","log2FC_serum")])

# Check pur genes specifically
cat("\n=== PUR GENES IN SERUM DEPLETED ===\n")
pur_dep <- dep[grepl("pur", dep$gene.y, ignore.case=TRUE),
               c("gene","gene.y","product","BHI_mean")]
print(pur_dep)
# 
