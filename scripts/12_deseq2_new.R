# DESeq2 Differential Expression Analysis
# E. faecium E745 — Serum vs BHI
# Akshath Nair, Uppsala University 2026
# Re-run on own Trimmomatic retrim + realignment (Aug 2026)

library(DESeq2)
library(ggplot2)
library(pheatmap)
library(RColorBrewer)
library(ggrepel)

# ─── 1. Load count files ───────────────────────────────────────────
COUNTDIR <- "C:/Users/Anil Kumar/Desktop/Genome_Analysis/Lab/local/counts"

samples <- c("BHI_rep1", "BHI_rep2", "BHI_rep3",
             "Serum_rep1", "Serum_rep2", "Serum_rep3")

# Read all count files
count_list <- lapply(samples, function(s) {
  f <- read.table(file.path(COUNTDIR, paste0(s, "_counts.txt")),
                  header=FALSE, row.names=1)
  f[,1]
})

count_matrix <- do.call(cbind, count_list)
colnames(count_matrix) <- samples
rownames(count_matrix) <- read.table(
  file.path(COUNTDIR, "BHI_rep1_counts.txt"),
  header=FALSE, row.names=1
) |> rownames()

# Remove HTSeq summary lines
count_matrix <- count_matrix[!grepl("^__", rownames(count_matrix)), ]

cat("Genes in count matrix:", nrow(count_matrix), "\n")
cat("Samples:", ncol(count_matrix), "\n")

# ─── 2. Metadata ───────────────────────────────────────────────────
coldata <- data.frame(
  condition = factor(c("BHI","BHI","BHI","Serum","Serum","Serum"),
                     levels = c("BHI", "Serum")),
  row.names = samples
)

# ─── 3. DESeq2 ─────────────────────────────────────────────────────
dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = coldata,
  design = ~condition
)

# Filter low count genes
dds <- dds[rowSums(counts(dds)) >= 10, ]
cat("Genes after filtering:", nrow(dds), "\n")

dds <- DESeq(dds)

# Results: Serum vs BHI
res <- results(dds, contrast=c("condition","Serum","BHI"))
res_ordered <- res[order(res$padj), ]

cat("\n=== Summary ===\n")
summary(res)

# Save full results
OUTDIR <- "C:/Users/Anil Kumar/Desktop/Genome_Analysis/Lab/local/deseq2"
dir.create(OUTDIR, showWarnings=FALSE)
write.csv(as.data.frame(res_ordered),
          file.path(OUTDIR, "DESeq2_Serum_vs_BHI_all.csv"))

# Save significant results only (padj < 0.05, |log2FC| > 1)
sig <- subset(res_ordered, padj < 0.05 & abs(log2FoldChange) > 1)
write.csv(as.data.frame(sig),
          file.path(OUTDIR, "DESeq2_Serum_vs_BHI_significant.csv"))
cat("Significant DEGs:", nrow(sig), "\n")

# ─── 4. Plots ──────────────────────────────────────────────────────

# Volcano plot
res_df <- as.data.frame(res_ordered)
res_df$gene <- rownames(res_df)
res_df$sig <- "Not significant"
res_df$sig[res_df$padj < 0.05 & res_df$log2FoldChange > 1] <- "Up in Serum"
res_df$sig[res_df$padj < 0.05 & res_df$log2FoldChange < -1] <- "Down in Serum"

png(file.path(OUTDIR, "volcano_plot.png"), width=800, height=600)
ggplot(res_df, aes(log2FoldChange, -log10(padj), color=sig)) +
  geom_point(alpha=0.6, size=1.5) +
  scale_color_manual(values=c(
    "Not significant" = "grey60",
    "Up in Serum" = "red",
    "Down in Serum" = "steelblue"
  )) +
  geom_vline(xintercept=c(-1,1), linetype="dashed", color="black") +
  geom_hline(yintercept=-log10(0.05), linetype="dashed", color="black") +
  theme_bw(base_size=14) +
  labs(title="Differential Expression: Serum vs BHI",
       subtitle="E. faecium E745",
       x="Log2 Fold Change",
       y="-log10(adjusted p-value)",
       color="")
dev.off()

# PCA plot
pca_data <- plotPCA(vsd, intgroup="condition", returnData=TRUE)
percentVar <- round(100 * attr(pca_data, "percentVar"))

png(file.path(OUTDIR, "PCA_plot.png"), width=900, height=700, res=120)
ggplot(pca_data, aes(PC1, PC2, color=condition, label=name)) +
  geom_point(size=5, alpha=0.85) +
  geom_text_repel(size=4, show.legend=FALSE) +
  scale_color_manual(values=c("BHI"="#F8766D", "Serum"="#00BFC4")) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  theme_bw(base_size=15) +
  theme(
    plot.title = element_text(face="bold"),
    aspect.ratio = 0.75,
    legend.position = "right"
  ) +
  labs(title="PCA — RNA-seq samples",
       subtitle="E. faecium E745: Serum vs BHI",
       color="Condition")
dev.off()

# Heatmap of top 50 DEGs
top50 <- head(rownames(res_ordered[!is.na(res_ordered$padj),]), 50)
mat <- assay(vsd)[top50, ]
mat <- mat - rowMeans(mat)

png(file.path(OUTDIR, "heatmap_top50.png"), width=800, height=1000)
pheatmap(mat,
         annotation_col = as.data.frame(colData(vsd)[,"condition",drop=FALSE]),
         main = "Top 50 DEGs — Serum vs BHI",
         fontsize_row = 8)
dev.off()

cat("\nDESeq2 analysis complete!\n")
cat("Results saved to:", OUTDIR, "\n")
