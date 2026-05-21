#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -t 02:00:00
#SBATCH -J tnseq_align
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/tnseq_align.%j.out

echo "Job started: $(date)"

module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22-GCC-13.3.0

# Paths
ASSEMBLY=/home/akshath/efaecium_project/results/assembly/flye_assembly/assembly.fasta
TNSEQ_BHI=/home/akshath/efaecium_project/data/raw/tnseq/BHI
TNSEQ_SERUM=/home/akshath/efaecium_project/data/raw/tnseq/Serum
TNSEQ_HSERUM=/home/akshath/efaecium_project/data/raw/tnseq/HSerum
OUTDIR=/home/akshath/efaecium_project/results/tnseq/bam_files

mkdir -p $OUTDIR

# Index genome
if [ ! -f ${ASSEMBLY}.bwt ]; then
    echo "Indexing genome..."
    bwa index $ASSEMBLY
fi

# BHI rep1
echo "Aligning BHI_rep1..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_BHI/trim_ERR1801012_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/BHI_rep1.sorted.bam
samtools index $OUTDIR/BHI_rep1.sorted.bam
samtools flagstat $OUTDIR/BHI_rep1.sorted.bam > $OUTDIR/BHI_rep1_flagstat.txt
echo "Done: BHI_rep1"

# BHI rep2
echo "Aligning BHI_rep2..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_BHI/trim_ERR1801013_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/BHI_rep2.sorted.bam
samtools index $OUTDIR/BHI_rep2.sorted.bam
samtools flagstat $OUTDIR/BHI_rep2.sorted.bam > $OUTDIR/BHI_rep2_flagstat.txt
echo "Done: BHI_rep2"

# BHI rep3
echo "Aligning BHI_rep3..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_BHI/trim_ERR1801014_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/BHI_rep3.sorted.bam
samtools index $OUTDIR/BHI_rep3.sorted.bam
samtools flagstat $OUTDIR/BHI_rep3.sorted.bam > $OUTDIR/BHI_rep3_flagstat.txt
echo "Done: BHI_rep3"

# Serum rep1
echo "Aligning Serum_rep1..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_SERUM/trim_ERR1801006_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/Serum_rep1.sorted.bam
samtools index $OUTDIR/Serum_rep1.sorted.bam
samtools flagstat $OUTDIR/Serum_rep1.sorted.bam > $OUTDIR/Serum_rep1_flagstat.txt
echo "Done: Serum_rep1"

# Serum rep2
echo "Aligning Serum_rep2..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_SERUM/trim_ERR1801007_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/Serum_rep2.sorted.bam
samtools index $OUTDIR/Serum_rep2.sorted.bam
samtools flagstat $OUTDIR/Serum_rep2.sorted.bam > $OUTDIR/Serum_rep2_flagstat.txt
echo "Done: Serum_rep2"

# Serum rep3
echo "Aligning Serum_rep3..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_SERUM/trim_ERR1801008_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/Serum_rep3.sorted.bam
samtools index $OUTDIR/Serum_rep3.sorted.bam
samtools flagstat $OUTDIR/Serum_rep3.sorted.bam > $OUTDIR/Serum_rep3_flagstat.txt
echo "Done: Serum_rep3"

# HSerum rep1
echo "Aligning HSerum_rep1..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_HSERUM/trim_ERR1801009_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/HSerum_rep1.sorted.bam
samtools index $OUTDIR/HSerum_rep1.sorted.bam
samtools flagstat $OUTDIR/HSerum_rep1.sorted.bam > $OUTDIR/HSerum_rep1_flagstat.txt
echo "Done: HSerum_rep1"

# HSerum rep2
echo "Aligning HSerum_rep2..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_HSERUM/trim_ERR1801010_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/HSerum_rep2.sorted.bam
samtools index $OUTDIR/HSerum_rep2.sorted.bam
samtools flagstat $OUTDIR/HSerum_rep2.sorted.bam > $OUTDIR/HSerum_rep2_flagstat.txt
echo "Done: HSerum_rep2"

# HSerum rep3
echo "Aligning HSerum_rep3..."
bwa mem -t 4 $ASSEMBLY $TNSEQ_HSERUM/trim_ERR1801011_pass.fastq.gz | \
    samtools view -bS -F 4 | \
    samtools sort -o $OUTDIR/HSerum_rep3.sorted.bam
samtools index $OUTDIR/HSerum_rep3.sorted.bam
samtools flagstat $OUTDIR/HSerum_rep3.sorted.bam > $OUTDIR/HSerum_rep3_flagstat.txt
echo "Done: HSerum_rep3"

echo "All Tn-seq alignments complete!"
echo "Job finished: $(date)"
