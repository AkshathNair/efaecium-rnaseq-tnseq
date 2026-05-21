#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 10:00:00
#SBATCH -J tnseq_counts
#SBATCH --mail-type=ALL
#SBATCH --output=/home/akshath/efaecium_project/logs/tnseq_counts.%j.out

echo "Job started: $(date)"

module load HTSeq/2.1.2-gfbf-2024a

GFF=/home/akshath/efaecium_project/results/annotation/prokka_output/Efaecium_E745_noFASTA.gff
BAMDIR=/home/akshath/efaecium_project/results/tnseq/bam_files
OUTDIR=/home/akshath/efaecium_project/results/tnseq/counts

mkdir -p $OUTDIR

for bam in $BAMDIR/*.sorted.bam; do
    sample=$(basename $bam .sorted.bam)
    echo "Counting insertions: $sample..."
    htseq-count \
        -f bam \
        -r pos \
        -s no \
        -t CDS \
        -i ID \
        $bam $GFF \
        > $OUTDIR/${sample}_counts.txt
    echo "Done: $sample"
done

echo "All insertion counting complete!"
echo "Job finished: $(date)"
