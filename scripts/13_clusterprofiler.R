# GO/KEGG Enrichment Analysis — FINAL CLEAN VERSION
# E. faecium E745 — Serum vs BHI
# Akshath Nair, Uppsala University 2026

library(clusterProfiler)
library(enrichplot)
library(ggplot2)

# ─── 1. Paths ─────────────────────────────────────
LOCALDIR <- "C:/Users/Anil Kumar/Desktop/Genome_analysis/Lab/local"
OUTDIR   <- file.path(LOCALDIR, "enrichment")
dir.create(OUTDIR, showWarnings = FALSE)

# ─── 2. Load eggNOG ───────────────────────────────
eggnog <- read.table(
  file.path(LOCALDIR, "Efaecium_E745_eggnog.emapper.annotations"),
  sep = "\t", header = FALSE, comment.char = "#",
  quote = "", fill = TRUE, stringsAsFactors = FALSE
)

colnames(eggnog) <- c("query","seed_ortholog","evalue","score",
                      "eggNOG_OGs","max_annot_lvl","COG_category",
                      "Description","Preferred_name","GOs","EC",
                      "KEGG_ko","KEGG_Pathway","KEGG_Module",
                      "KEGG_Reaction","KEGG_rclass","BRITE",
                      "KEGG_TC","CAZy","BiGG_Reaction","PFAMs")

cat("Total annotated genes:", nrow(eggnog), "\n")

# ─── 3. Load DESeq2 ───────────────────────────────
sig <- read.csv(file.path(LOCALDIR, "deseq2/DESeq2_Serum_vs_BHI_significant.csv"), row.names=1)
all_res <- read.csv(file.path(LOCALDIR, "deseq2/DESeq2_Serum_vs_BHI_all.csv"), row.names=1)

up_genes   <- rownames(sig[sig$log2FoldChange > 0,])
down_genes <- rownames(sig[sig$log2FoldChange < 0,])
all_genes  <- rownames(all_res[!is.na(all_res$padj),])

cat("Up:", length(up_genes), "Down:", length(down_genes), "\n")

# ─── 4. GO mapping ────────────────────────────────
go_data <- eggnog[!is.na(eggnog$GOs) & eggnog$GOs != "-" & eggnog$GOs != "",
                  c("query","GOs")]

go_list <- strsplit(go_data$GOs, ",")

term2gene_go <- data.frame(
  term = trimws(unlist(go_list)),
  gene = rep(go_data$query, sapply(go_list, length)),
  stringsAsFactors = FALSE
)

term2gene_go <- term2gene_go[term2gene_go$term != "", ]
term2gene_go <- unique(term2gene_go)

cat("GO term-gene pairs:", nrow(term2gene_go), "\n")

# ─── 5. KEGG mapping (CORRECT + DEDUPLICATED) ────
kegg_data <- eggnog[
  !is.na(eggnog$KEGG_Pathway) &
    eggnog$KEGG_Pathway != "-" &
    eggnog$KEGG_Pathway != "",
  c("query","KEGG_Pathway")
]

kegg_list <- strsplit(kegg_data$KEGG_Pathway, ",")

term2gene_kegg <- data.frame(
  term = trimws(unlist(kegg_list)),
  gene = rep(kegg_data$query, sapply(kegg_list, length)),
  stringsAsFactors = FALSE
)

# Remove empty
term2gene_kegg <- term2gene_kegg[term2gene_kegg$term != "", ]

# Convert map → ko (IMPORTANT FIX)
term2gene_kegg$term <- gsub("^map", "ko", term2gene_kegg$term)

# Remove duplicates AFTER conversion
term2gene_kegg <- unique(term2gene_kegg)

cat("KEGG pathway-gene pairs:", nrow(term2gene_kegg), "\n")

# ─── 6. Coverage diagnostics ──────────────────────
cat("GO coverage:",
    sum(all_genes %in% term2gene_go$gene), "/", length(all_genes), "\n")

cat("KEGG coverage:",
    sum(all_genes %in% term2gene_kegg$gene), "/", length(all_genes), "\n")

# ─── 7. GO enrichment ─────────────────────────────
ego_up <- enricher(
  gene = up_genes,
  TERM2GENE = term2gene_go,
  universe = all_genes,
  pvalueCutoff = 0.1,
  pAdjustMethod = "BH",
  minGSSize = 2
)

ego_down <- enricher(
  gene = down_genes,
  TERM2GENE = term2gene_go,
  universe = all_genes,
  pvalueCutoff = 0.1,
  pAdjustMethod = "BH",
  minGSSize = 2
)

# Filter significant
ego_up_res <- if (!is.null(ego_up)) ego_up@result[ego_up@result$p.adjust < 0.1, ] else NULL
ego_down_res <- if (!is.null(ego_down)) ego_down@result[ego_down@result$p.adjust < 0.1, ] else NULL

# Save + Plot GO
if (!is.null(ego_up_res) && nrow(ego_up_res) > 0) {
  write.csv(ego_up_res, file.path(OUTDIR, "GO_up.csv"), row.names=FALSE)
  ggsave(file.path(OUTDIR,"GO_up.png"),
         dotplot(ego_up, showCategory=20, orderBy="p.adjust") +
           ggtitle("GO Upregulated"),
         width=10, height=8)
} else {
  cat("No significant GO upregulated terms\n")
}

if (!is.null(ego_down_res) && nrow(ego_down_res) > 0) {
  write.csv(ego_down_res, file.path(OUTDIR, "GO_down.csv"), row.names=FALSE)
  ggsave(file.path(OUTDIR,"GO_down.png"),
         dotplot(ego_down, showCategory=20, orderBy="p.adjust") +
           ggtitle("GO Downregulated"),
         width=10, height=8)
} else {
  cat("No significant GO downregulated terms\n")
}

# ─── 8. KEGG enrichment ───────────────────────────
ekegg_up <- enricher(
  gene = up_genes,
  TERM2GENE = term2gene_kegg,
  universe = all_genes,
  pvalueCutoff = 0.1,
  pAdjustMethod = "BH",
  minGSSize = 2
)

ekegg_down <- enricher(
  gene = down_genes,
  TERM2GENE = term2gene_kegg,
  universe = all_genes,
  pvalueCutoff = 0.1,
  pAdjustMethod = "BH",
  minGSSize = 2
)

# Filter
ekegg_up_res <- if (!is.null(ekegg_up)) ekegg_up@result[ekegg_up@result$p.adjust < 0.1, ] else NULL
ekegg_down_res <- if (!is.null(ekegg_down)) ekegg_down@result[ekegg_down@result$p.adjust < 0.1, ] else NULL

# Save + Plot KEGG
if (!is.null(ekegg_up_res) && nrow(ekegg_up_res) > 0) {
  write.csv(ekegg_up_res, file.path(OUTDIR, "KEGG_up.csv"), row.names=FALSE)
  ggsave(file.path(OUTDIR,"KEGG_up.png"),
         dotplot(ekegg_up, showCategory=20, orderBy="p.adjust") +
           ggtitle("KEGG Upregulated"),
         width=10, height=8)
} else {
  cat("No significant KEGG upregulated terms\n")
}

if (!is.null(ekegg_down_res) && nrow(ekegg_down_res) > 0) {
  write.csv(ekegg_down_res, file.path(OUTDIR, "KEGG_down.csv"), row.names=FALSE)
  ggsave(file.path(OUTDIR,"KEGG_down.png"),
         dotplot(ekegg_down, showCategory=20, orderBy="p.adjust") +
           ggtitle("KEGG Downregulated"),
         width=10, height=8)
} else {
  cat("No significant KEGG downregulated terms\n")
}

cat("\n✅ FULL enrichment complete — results saved in:", OUTDIR, "\n")

