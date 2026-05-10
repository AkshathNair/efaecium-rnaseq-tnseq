#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 30:00:00
#SBATCH -J fastqc_trimmed
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/fastqc_trimmed.%j.out

echo "Job started: $(date)"

module load FastQC/0.12.1-Java-17

TRIMBHI=/home/akshath/efaecium_project/data/trimmed/rnaseq/BHI
TRIMSERUM=/home/akshath/efaecium_project/data/trimmed/rnaseq/Serum
OUTDIR=/home/akshath/efaecium_project/results/qc/fastqc_trimmed

mkdir -p $OUTDIR

# FastQC on trimmed BHI reads
fastqc \
    $TRIMBHI/trim_paired_ERR1797972_pass_1.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797972_pass_2.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797973_pass_1.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797973_pass_2.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797974_pass_1.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797974_pass_2.fastq.gz \
    --outdir $OUTDIR \
    --threads 2

# FastQC on trimmed Serum reads
fastqc \
    $TRIMSERUM/trim_paired_ERR1797969_pass_1.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797969_pass_2.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797970_pass_1.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797970_pass_2.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797971_pass_1.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797971_pass_2.fastq.gz \
    --outdir $OUTDIR \
    --threads 2

echo "Job finished: $(date)"
