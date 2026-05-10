#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 03:30:00
#SBATCH -J multiqc
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/multiqc.%j.out

echo "Job started: $(date)"

module load MultiQC/1.28-foss-2024a

RAWQC=/home/akshath/efaecium_project/results/qc/fastqc_raw
TRIMQC=/home/akshath/efaecium_project/results/qc/fastqc_trimmed
OUTDIR=/home/akshath/efaecium_project/results/qc

multiqc \
    $RAWQC \
    $TRIMQC \
    --outdir $OUTDIR \
    --filename multiqc_report \
    --title "E. faecium E745 RNA-seq QC Report"

echo "Job finished: $(date)"
