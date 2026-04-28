#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH -J flye_assembly
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/flye_assembly.%j.out
#SBATCH --error=/home/akshath/efaecium_project/logs/flye_assembly.%j.err

echo "START $(date)"
echo "Running on $(hostname)"

module load Flye/2.9.6-GCC-13.3.0

OUTDIR=/home/akshath/efaecium_project/results/assembly/flye_assembly
PACBIO=/proj/uppmax2026-1-61/Genome_Analysis/1_Zhang_2017/genomics_data/PacBio

mkdir -p $OUTDIR

echo "Files:"
ls -lh $PACBIO

flye \
  --pacbio-raw $PACBIO/*.fastq.gz \
  --out-dir $OUTDIR \
  --genome-size 3m \
  --threads 2

echo "END $(date)"
