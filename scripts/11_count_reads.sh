#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 30:00:00
#SBATCH -J htseq_count
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/htseq_count.%j.out

echo "Job started: $(date)"

module load HTSeq/2.1.2-gfbf-2024a

BAMDIR=/proj/uppmax2026-1-61/nobackup/work/akshath/efaecium_project/bam_files
GFF=/home/akshath/efaecium_project/results/annotation/prokka_output/Efaecium_E745.gff
OUTDIR=/home/akshath/efaecium_project/results/counts

mkdir -p $OUTDIR

# Count BHI replicates
echo "Counting BHI rep1..."
htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i ID \
    $BAMDIR/BHI_rep1.sorted.bam \
    $GFF > $OUTDIR/BHI_rep1_counts.txt

echo "Counting BHI rep2..."
htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i ID \
    $BAMDIR/BHI_rep2.sorted.bam \
    $GFF > $OUTDIR/BHI_rep2_counts.txt

echo "Counting BHI rep3..."
htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i ID \
    $BAMDIR/BHI_rep3.sorted.bam \
    $GFF > $OUTDIR/BHI_rep3_counts.txt

# Count Serum replicates
echo "Counting Serum rep1..."
htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i ID \
    $BAMDIR/Serum_rep1.sorted.bam \
    $GFF > $OUTDIR/Serum_rep1_counts.txt

echo "Counting Serum rep2..."
htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i ID \
    $BAMDIR/Serum_rep2.sorted.bam \
    $GFF > $OUTDIR/Serum_rep2_counts.txt

echo "Counting Serum rep3..."
htseq-count \
    -f bam \
    -r pos \
    -s no \
    -t CDS \
    -i ID \
    $BAMDIR/Serum_rep3.sorted.bam \
    $GFF > $OUTDIR/Serum_rep3_counts.txt

echo "All counting done!"
echo "Job finished: $(date)"
