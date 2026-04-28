#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 06:00:00
#SBATCH -J fastqc_raw
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/fastqc_raw.%j.out

echo "Job started: $(date)"

module load FastQC/0.12.1-Java-17

RAWBHI=/home/akshath/efaecium_project/data/raw/rnaseq/BHI
RAWSERUM=/home/akshath/efaecium_project/data/raw/rnaseq/Serum
OUTDIR=/home/akshath/efaecium_project/results/qc/fastqc_raw

mkdir -p $OUTDIR

# Run FastQC on all BHI raw files
fastqc \
    $RAWBHI/ERR1797972_1.fastq.gz \
    $RAWBHI/ERR1797972_2.fastq.gz \
    $RAWBHI/ERR1797973_1.fastq.gz \
    $RAWBHI/ERR1797973_2.fastq.gz \
    $RAWBHI/ERR1797974_1.fastq.gz \
    $RAWBHI/ERR1797974_2.fastq.gz \
    --outdir $OUTDIR \
    --threads 2

# Run FastQC on all Serum raw files
fastqc \
    $RAWSERUM/ERR1797969_1.fastq.gz \
    $RAWSERUM/ERR1797969_2.fastq.gz \
    $RAWSERUM/ERR1797970_1.fastq.gz \
    $RAWSERUM/ERR1797970_2.fastq.gz \
    $RAWSERUM/ERR1797971_1.fastq.gz \
    $RAWSERUM/ERR1797971_2.fastq.gz \
    --outdir $OUTDIR \
    --threads 2

echo "Job finished: $(date)"
