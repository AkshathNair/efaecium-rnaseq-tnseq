#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH -J eggnog_mapper
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/eggnog.%j.out

echo "Job started: $(date)"

module load eggnog-mapper/2.1.13-gfbf-2024a

PROTEINS=/home/akshath/efaecium_project/results/annotation/prokka_output/Efaecium_E745.faa
OUTDIR=/home/akshath/efaecium_project/results/annotation/eggnog_output

mkdir -p $OUTDIR

emapper.py \
    -i $PROTEINS \
    --itype proteins \
    -o Efaecium_E745_eggnog \
    --output_dir $OUTDIR \
    --cpu 2 \
    --go_evidence all \
    --target_orthologs all \
    --seed_ortholog_evalue 0.001 \
    -m hmmer \
    -d Enterococcaceae \
    --data_dir /sw/data/eggNOG_data/5.0.0/rackham \
    --override

echo "Job finished: $(date)"
