#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 25:00:00
#SBATCH -J bwa_align
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/bwa_align.%j.out

echo "Job started: $(date)"

module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22-GCC-13.3.0

ASSEMBLY=/home/akshath/efaecium_project/results/assembly/flye_assembly/assembly.fasta
TRIMBHI=/home/akshath/efaecium_project/data/trimmed/rnaseq/BHI
TRIMSERUM=/home/akshath/efaecium_project/data/trimmed/rnaseq/Serum
OUTDIR=/proj/uppmax2026-1-61/nobackup/work/akshath/efaecium_project/bam_files

mkdir -p $OUTDIR

echo "Aligning BHI replicate 1..."
bwa mem -t 2 $ASSEMBLY \
    $TRIMBHI/trim_paired_ERR1797972_pass_1.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797972_pass_2.fastq.gz | \
    samtools sort -@ 2 -o $OUTDIR/BHI_rep1.sorted.bam
samtools index $OUTDIR/BHI_rep1.sorted.bam

echo "Aligning BHI replicate 2..."
bwa mem -t 2 $ASSEMBLY \
    $TRIMBHI/trim_paired_ERR1797973_pass_1.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797973_pass_2.fastq.gz | \
    samtools sort -@ 2 -o $OUTDIR/BHI_rep2.sorted.bam
samtools index $OUTDIR/BHI_rep2.sorted.bam

echo "Aligning BHI replicate 3..."
bwa mem -t 2 $ASSEMBLY \
    $TRIMBHI/trim_paired_ERR1797974_pass_1.fastq.gz \
    $TRIMBHI/trim_paired_ERR1797974_pass_2.fastq.gz | \
    samtools sort -@ 2 -o $OUTDIR/BHI_rep3.sorted.bam
samtools index $OUTDIR/BHI_rep3.sorted.bam

echo "Aligning Serum replicate 1..."
bwa mem -t 2 $ASSEMBLY \
    $TRIMSERUM/trim_paired_ERR1797969_pass_1.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797969_pass_2.fastq.gz | \
    samtools sort -@ 2 -o $OUTDIR/Serum_rep1.sorted.bam
samtools index $OUTDIR/Serum_rep1.sorted.bam

echo "Aligning Serum replicate 2..."
bwa mem -t 2 $ASSEMBLY \
    $TRIMSERUM/trim_paired_ERR1797970_pass_1.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797970_pass_2.fastq.gz | \
    samtools sort -@ 2 -o $OUTDIR/Serum_rep2.sorted.bam
samtools index $OUTDIR/Serum_rep2.sorted.bam

echo "Aligning Serum replicate 3..."
bwa mem -t 2 $ASSEMBLY \
    $TRIMSERUM/trim_paired_ERR1797971_pass_1.fastq.gz \
    $TRIMSERUM/trim_paired_ERR1797971_pass_2.fastq.gz | \
    samtools sort -@ 2 -o $OUTDIR/Serum_rep3.sorted.bam
samtools index $OUTDIR/Serum_rep3.sorted.bam

echo "All alignments done!"
echo "Job finished: $(date)"
