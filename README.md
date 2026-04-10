# efaecium-rnaseq-tnseq
# Genomic Analysis of *Enterococcus faecium* in Human Serum

RNA-seq and Tn-seq integrated pipeline to investigate gene expression and essentiality of *Enterococcus faecium* during growth in human serum.

---

## Project Overview

*Enterococcus faecium* is an opportunistic pathogen associated with hospital-acquired infections and antibiotic resistance (VRE). This project explores how the bacterium adapts to human serum using:

- **RNA-seq** → identifies differentially expressed genes (DEGs)  
- **Tn-seq** → identifies genes essential for survival  

By integrating both approaches, the project identifies key pathways and candidate genes involved in serum adaptation and potential virulence.

---

## Objectives

### Core Analysis
- Quality control of sequencing reads (FastQC, MultiQC)
- Read trimming (Trimmomatic)
- RNA-seq alignment (HISAT2)
- Gene quantification (featureCounts)
- Differential expression analysis (DESeq2)
- Tn-seq alignment (Bowtie2)
- Identification of conditionally essential genes

### Advanced Analysis
- Functional enrichment (GO / KEGG)
- RNA-seq + Tn-seq overlap analysis
- Pathway-specific analysis (e.g., purine metabolism)
- Gene co-expression and network analysis

---

## Repository Structure
- scripts/ → Analysis scripts (bash + R)
- results/ → Final outputs (tables, plots)
- data/reference/ → Reference genome and annotation
- logs/ → Execution logs



> Large files (FASTQ, BAM) are stored on UPPMAX and are not included in this repository.

---

## Requirements

### Environment
- UPPMAX cluster (Rackham / Pelle)
- SLURM job scheduler

### Software Modules
- FastQC
- MultiQC
- Trimmomatic
- HISAT2
- Bowtie2
- SAMtools
- Subread (featureCounts)
- R (DESeq2, clusterProfiler, ggplot2, pheatmap)


---

## How to Run

### 1. Clone the repository
```bash
git clone https://github.com/AkshathNair/efaecium-rnaseq-tnseq
cd Genome_analysis
```
### 2. Load modules
```bash
source load_modules.sh
```
### 3. Run pipeline (step-by-step)
```bash
bash scripts/01_qc.sh
bash scripts/02_trim.sh
bash scripts/03_align_rnaseq.sh
bash scripts/04_align_tnseq.sh
bash scripts/05_count.sh

Rscript scripts/06_deseq2.R
Rscript scripts/07_tnseq_analysis.R
```
---

## Data Storage (UPPMAX)
**Large files are stored in the project directory:**
```
/proj/uppmax2026-1-61/nobackup/work/efaecium_project/
```
### Includes:

- Raw FASTQ files
- Trimmed reads
- BAM alignment files
- Intermediate files

---
## Results

### The pipeline produces:

- Differentially expressed genes (DEGs)
- Serum-specific essential genes
- GO and KEGG enrichment results
- RNA-seq and Tn-seq overlap analysis
#### Visualization:
- PCA plots
- Volcano plots
- Heatmaps
- Network graphs

---

## Reproducibility
- Modular and script-based pipeline
- Standardized folder structure
- Logged execution outputs
- Compatible with SLURM-based HPC systems

---

## Documentation

**Full project documentation is available in the GitHub Wiki:**
```
https://github.com/AkshathNair/efaecium-rnaseq-tnseq/wiki/Project-Plan
```
---

# Data Availability
- Raw sequencing data: (to be added SRA link here)
- Reference genome: E. faecium Aus0004 (GenBank: CP003351)

---


## Author

**Akshath Nair**  
Master’s Student in Bioinformatics  
Uppsala University
---

# License

This project is developed for academic purposes as part of a Master's course in Genome Analysis.

