#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J mummer_synteny
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/mummer_synteny.%j.out

echo "Job started: $(date)"

module load MUMmer/4.0.1-GCCcore-13.3.0

QUERY=/home/akshath/efaecium_project/results/assembly/flye_assembly/assembly.fasta
REF=/home/akshath/efaecium_project/data/reference/Aus0004_reference.fna
OUTDIR=/home/akshath/efaecium_project/results/synteny

mkdir -p $OUTDIR
cd $OUTDIR

# Run nucmer alignment
nucmer \
    --prefix Efaecium_E745_vs_Aus0004 \
    --threads 2 \
    $REF \
    $QUERY

# Filter alignments
delta-filter \
    -r -q \
    Efaecium_E745_vs_Aus0004.delta \
    > Efaecium_E745_vs_Aus0004.filtered.delta

# Generate dot plot coordinates
show-coords \
    -rcl \
    Efaecium_E745_vs_Aus0004.filtered.delta \
    > Efaecium_E745_vs_Aus0004.coords

# Generate dot plot
mummerplot \
    --fat \
    --layout \
    --filter \
    -R $REF \
    -Q $QUERY \
    --prefix Efaecium_E745_vs_Aus0004 \
    --png \
    Efaecium_E745_vs_Aus0004.filtered.delta

echo "Job finished: $(date)"
