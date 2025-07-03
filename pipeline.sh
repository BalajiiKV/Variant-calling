#!bin/bash
mkdir ref
curl -L -o ref/chr20.fa.gz https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr20.fa.gz
gunzip ref/chr20.fa.gz
mkdir sample
curl -L -o sample/NA12878_R1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR151/004/SRR1518044/SRR1518044_1.fastq.gz
curl -L -o sample/NA12878_R2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR151/004/SRR1518044/SRR1518044_2.fastq.gz
fastqc sample/NA12878_R1.fastq.gz
fastqc sample/NA12878_R2.fastq.gz
bwa index ref/chr20.fa
mkdir result
bwa mem ref/chr20.fa sample/NA12878_R1.fastq.gz sample/NA12878_R2.fastq.gz > result/NA12878.aligned.sam
samtools view -S -b result/NA12878.aligned.sam > result/NA12878.aligned.bam
samtools sort -o result/NA12878.aligned.sorted.bam result/NA12878.aligned.bam
samtools index result/NA12878.aligned.sorted.bam
freebayes -f ref/chr20.fa result/NA12878.aligned.sorted.bam > result/NA12878.vcf