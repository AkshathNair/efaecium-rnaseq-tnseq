#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH -J fastqc_trimmed
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/fastqc_trimmed.%j.out

echo "Job started: $(date)"

module load FastQC/0.12.1-Java-17

TRIMBHI=/home/akshath/efaecium_project/data/trimmed/rnaseq/trimmomatic/BHI
TRIMSERUM=/home/akshath/efaecium_project/data/trimmed/rnaseq/trimmomatic/Serum
OUTDIR=/home/akshath/efaecium_project/results/qc/fastqc_trimmed_new

mkdir -p $OUTDIR

# FastQC on trimmed BHI reads
echo "Running FastQC on trimmed BHI reads..."
fastqc \
    $TRIMBHI/BHI_rep1_R1_paired.fastq.gz \
    $TRIMBHI/BHI_rep1_R2_paired.fastq.gz \
    $TRIMBHI/BHI_rep2_R1_paired.fastq.gz \
    $TRIMBHI/BHI_rep2_R2_paired.fastq.gz \
    $TRIMBHI/BHI_rep3_R1_paired.fastq.gz \
    $TRIMBHI/BHI_rep3_R2_paired.fastq.gz \
    --outdir $OUTDIR \
    --threads 2

# FastQC on trimmed Serum reads
echo "Running FastQC on trimmed Serum reads..."
fastqc \
    $TRIMSERUM/Serum_rep1_R1_paired.fastq.gz \
    $TRIMSERUM/Serum_rep1_R2_paired.fastq.gz \
    $TRIMSERUM/Serum_rep2_R1_paired.fastq.gz \
    $TRIMSERUM/Serum_rep2_R2_paired.fastq.gz \
    $TRIMSERUM/Serum_rep3_R1_paired.fastq.gz \
    $TRIMSERUM/Serum_rep3_R2_paired.fastq.gz \
    --outdir $OUTDIR \
    --threads 2

echo "Job finished: $(date)"
