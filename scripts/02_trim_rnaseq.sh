#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 38:00:00
#SBATCH -J trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/trimmomatic.%j.out

echo "Job started: $(date)"

module load Trimmomatic/0.39-Java-17

# Paths
RAW_BHI=/proj/uppmax2026-1-61/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_BH/raw
RAW_SERUM=/proj/uppmax2026-1-61/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_Serum/raw
OUTDIR=/home/akshath/efaecium_project/data/trimmed/rnaseq/trimmomatic

mkdir -p $OUTDIR/BHI
mkdir -p $OUTDIR/Serum

ADAPTERS=/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa

# Trimmomatic parameters:
# ILLUMINACLIP:2:30:10 - remove Illumina adapters
# LEADING:3 - remove leading bases quality < 3
# TRAILING:3 - remove trailing bases quality < 3
# SLIDINGWINDOW:4:15 - 4-base window, cut when avg quality < 15
# MINLEN:36 - discard reads shorter than 36 bp

# BHI replicates
echo "Trimming BHI_rep1 (ERR1797972)..."
trimmomatic PE -threads 2 \
    $RAW_BHI/ERR1797972_1.fastq.gz $RAW_BHI/ERR1797972_2.fastq.gz \
    $OUTDIR/BHI/BHI_rep1_R1_paired.fastq.gz $OUTDIR/BHI/BHI_rep1_R1_unpaired.fastq.gz \
    $OUTDIR/BHI/BHI_rep1_R2_paired.fastq.gz $OUTDIR/BHI/BHI_rep1_R2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36
echo "Done: BHI_rep1"

echo "Trimming BHI_rep2 (ERR1797973)..."
trimmomatic PE -threads 2 \
    $RAW_BHI/ERR1797973_1.fastq.gz $RAW_BHI/ERR1797973_2.fastq.gz \
    $OUTDIR/BHI/BHI_rep2_R1_paired.fastq.gz $OUTDIR/BHI/BHI_rep2_R1_unpaired.fastq.gz \
    $OUTDIR/BHI/BHI_rep2_R2_paired.fastq.gz $OUTDIR/BHI/BHI_rep2_R2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36
echo "Done: BHI_rep2"

echo "Trimming BHI_rep3 (ERR1797974)..."
trimmomatic PE -threads 2 \
    $RAW_BHI/ERR1797974_1.fastq.gz $RAW_BHI/ERR1797974_2.fastq.gz \
    $OUTDIR/BHI/BHI_rep3_R1_paired.fastq.gz $OUTDIR/BHI/BHI_rep3_R1_unpaired.fastq.gz \
    $OUTDIR/BHI/BHI_rep3_R2_paired.fastq.gz $OUTDIR/BHI/BHI_rep3_R2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36
echo "Done: BHI_rep3"

# Serum replicates
echo "Trimming Serum_rep1 (ERR1797969)..."
trimmomatic PE -threads 2 \
    $RAW_SERUM/ERR1797969_1.fastq.gz $RAW_SERUM/ERR1797969_2.fastq.gz \
    $OUTDIR/Serum/Serum_rep1_R1_paired.fastq.gz $OUTDIR/Serum/Serum_rep1_R1_unpaired.fastq.gz \
    $OUTDIR/Serum/Serum_rep1_R2_paired.fastq.gz $OUTDIR/Serum/Serum_rep1_R2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36
echo "Done: Serum_rep1"

echo "Trimming Serum_rep2 (ERR1797970)..."
trimmomatic PE -threads 2 \
    $RAW_SERUM/ERR1797970_1.fastq.gz $RAW_SERUM/ERR1797970_2.fastq.gz \
    $OUTDIR/Serum/Serum_rep2_R1_paired.fastq.gz $OUTDIR/Serum/Serum_rep2_R1_unpaired.fastq.gz \
    $OUTDIR/Serum/Serum_rep2_R2_paired.fastq.gz $OUTDIR/Serum/Serum_rep2_R2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36
echo "Done: Serum_rep2"

echo "Trimming Serum_rep3 (ERR1797971)..."
trimmomatic PE -threads 2 \
    $RAW_SERUM/ERR1797971_1.fastq.gz $RAW_SERUM/ERR1797971_2.fastq.gz \
    $OUTDIR/Serum/Serum_rep3_R1_paired.fastq.gz $OUTDIR/Serum/Serum_rep3_R1_unpaired.fastq.gz \
    $OUTDIR/Serum/Serum_rep3_R2_paired.fastq.gz $OUTDIR/Serum/Serum_rep3_R2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36
echo "Done: Serum_rep3"

echo "All trimming complete!"
echo "Job finished: $(date)"
