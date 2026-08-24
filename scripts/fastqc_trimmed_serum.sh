#!/bin/bash
#SBATCH -A uppmax2026-1-61
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_trimmed_serum

module load FastQC/0.12.1

mkdir -p /home/akshath/efaecium_project/results/qc/fastqc_trimmed_serum

fastqc -o /home/akshath/efaecium_project/results/qc/fastqc_trimmed_serum \
  /home/akshath/efaecium_project/data/trimmed/rnaseq/trimmomatic/Serum/RNA_Serum/*_paired.fq.gz
