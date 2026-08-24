#!/bin/bash
#SBATCH -A uppmax2026-1-61
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_trimmed_new

module load FastQC/0.12.1

mkdir -p /home/akshath/efaecium_project/results/qc/fastqc_trimmed_new

fastqc -o /home/akshath/efaecium_project/results/qc/fastqc_trimmed_new \
  /home/akshath/efaecium_project/data/trimmed/rnaseq/trimmomatic/BHI/RNA_BHI/*paired.fq.gz
