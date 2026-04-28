#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J prokka_annotation
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/prokka.%j.out

echo "Job started: $(date)"

module load prokka/1.14.5-gompi-2024a

ASSEMBLY=/home/akshath/efaecium_project/results/assembly/flye_assembly/assembly.fasta
OUTDIR=/home/akshath/efaecium_project/results/annotation/prokka_output

prokka \
    --outdir $OUTDIR \
    --prefix Efaecium_E745 \
    --genus Enterococcus \
    --species faecium \
    --strain E745 \
    --kingdom Bacteria \
    --cpus 2 \
    --force \
    $ASSEMBLY

echo "Job finished: $(date)"
