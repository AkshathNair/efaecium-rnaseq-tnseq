#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J quast_eval
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/quast_eval.%j.out

echo "Job started: $(date)"

module load QUAST/5.3.0-gfbf-2024a

ASSEMBLY=/home/akshath/efaecium_project/results/assembly/flye_assembly/assembly.fasta
OUTDIR=/home/akshath/efaecium_project/results/assembly/quast_evaluation

quast.py \
    $ASSEMBLY \
    --output-dir $OUTDIR \
    --threads 2 \
    --min-contig 500

echo "Job finished: $(date)"
