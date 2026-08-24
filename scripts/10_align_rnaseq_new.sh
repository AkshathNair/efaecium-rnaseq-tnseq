#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 25:00:00
#SBATCH -J bwa_align_new
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/bwa_align_new.%j.out

echo "Job started: $(date)"

module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22-GCC-13.3.0

ASSEMBLY=/home/akshath/efaecium_project/results/assembly/flye_assembly/assembly.fasta
TRIMBHI=/home/akshath/efaecium_project/data/trimmed/rnaseq/trimmomatic/BHI/RNA_BHI
TRIMSERUM=/home/akshath/efaecium_project/data/trimmed/rnaseq/trimmomatic/Serum/RNA_Serum
OUTDIR=/home/akshath/efaecium_project/results/alignment/rnaseq/bam_files
FLAGSTATDIR=/home/akshath/efaecium_project/results/alignment/rnaseq

mkdir -p $OUTDIR
mkdir -p $FLAGSTATDIR

declare -A BHI_ACC=( [1]=ERR1797972 [2]=ERR1797973 [3]=ERR1797974 )
declare -A SERUM_ACC=( [1]=ERR1797969 [2]=ERR1797970 [3]=ERR1797971 )

for i in 1 2 3; do
  ACC=${BHI_ACC[$i]}
  echo "Aligning BHI replicate $i ($ACC)..."
  bwa mem -t 2 $ASSEMBLY \
      $TRIMBHI/${ACC}_1_paired.fq.gz \
      $TRIMBHI/${ACC}_2_paired.fq.gz | \
      samtools sort -@ 2 -o $OUTDIR/BHI_rep${i}.sorted.bam
  samtools index $OUTDIR/BHI_rep${i}.sorted.bam
  samtools flagstat $OUTDIR/BHI_rep${i}.sorted.bam > $FLAGSTATDIR/flagstat_BHI_rep${i}.txt
done

for i in 1 2 3; do
  ACC=${SERUM_ACC[$i]}
  echo "Aligning Serum replicate $i ($ACC)..."
  bwa mem -t 2 $ASSEMBLY \
      $TRIMSERUM/${ACC}_1_paired.fq.gz \
      $TRIMSERUM/${ACC}_2_paired.fq.gz | \
      samtools sort -@ 2 -o $OUTDIR/Serum_rep${i}.sorted.bam
  samtools index $OUTDIR/Serum_rep${i}.sorted.bam
  samtools flagstat $OUTDIR/Serum_rep${i}.sorted.bam > $FLAGSTATDIR/flagstat_Serum_rep${i}.txt
done

echo "All alignments done!"
echo "Job finished: $(date)"
