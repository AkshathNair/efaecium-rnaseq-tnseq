#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:30:00
#SBATCH -J bwa_index
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/bwa_index.%j.out

echo "Job started: $(date)"

module load BWA/0.7.19-GCCcore-13.3.0

ASSEMBLY=/home/akshath/efaecium_project/results/assembly/flye_assembly/assembly.fasta

bwa index $ASSEMBLY

echo "Job finished: $(date)"
