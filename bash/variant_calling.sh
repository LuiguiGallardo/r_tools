#!/usr/bin/env sh

# Title: variant_calling.zsh
# Purpose: Variant calling v0.1
# Author: bfllg77@gmail.com
# Date: 02.11.2022

# Usage and explanation of parameters
usage(){
	cat <<help
Usage:
$0 {-f/--f R1_FASTQ_INPUT -r/--r R2_FASTQ_INPUT -o/--output OUTPUT_PREFIX}

Options:
-f,	--f	Input R1 fastq file
-r,	--r	Input R2 fastq file
-o,	--output	Output prefix

{} indicates required input (order unimportant)
help
}

# Print the usage and help if no parameter is given
if [ $# -eq 0 ]; then
	echo "No arguments provided"
	usage
	exit 1
fi

# Arguments input
while getopts f:r:o:h opts
	do
	case "$opts" in
		f) foward=$OPTARG;;
		r) reverse=$OPTARG;;
		o) output=$OPTARG;;
		h) usage
		exit 1;;
	esac
	done

# Print parameters
parameters(){
    cat <<parameters
# Parameters:
# Input R1 fastq file = $foward
# Input R2 fastq file = $reverse
# Output folder = $output
parameters
}
parameters

# Beginning of the script
echo "# Beginning of the script!"
mkdir $output
cd $output

# Quality filtering with trimmomatic
trimmomatic_paired() {
	echo "# Quality filtering with trimmomatic"
	# Creation of output directory
	mkdir trimmomatic_output
	# Trimmomatic
	trimmomatic PE ../$foward ../$reverse \
	trimmomatic_output/$output\_R1_paired.fq trimmomatic_output/$output\_R1_unpaired.fq \
	trimmomatic_output/$output\_R2_paired.fq trimmomatic_output/$output\_R2_unpaired.fq \
	LEADING:3 TRAILING:3 \
	SLIDINGWINDOW:6:20 \
	MINLEN:36 \
#	ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
}

# FASTQC analysis
fastqc(){
	mkdir fastqc_output
	echo fastqc ../$foward -o fastqc_output | bash 2> /dev/null > /dev/null
	echo fastqc ../$reverse -o fastqc_output | bash 2> /dev/null > /dev/null
	echo fastqc trimmomatic_output/$output\_R1_paired.fq -o fastqc_output | bash 2> /dev/null > /dev/null
	echo fastqc trimmomatic_output/$output\_R2_paired.fq -o fastqc_output | bash 2> /dev/null > /dev/null
}

# Alignment of reads to reference genome
bwa_mem(){
	echo "# Alignment of reads to reference genome with BWA MEM"
	# Creation of output directory
	mkdir bwa_mem_output
	# BWA MEM
	bwa mem ../reference_genome/GCF_000001405.40_GRCh38.p14_genomic.fna \
	trimmomatic_output/$output\_R1_paired.fq trimmomatic_output/$output\_R2_paired.fq \
	> bwa_mem_output/$output\_bwa-mem_human.sam
	# Samtools
	# SAM to BAM
	samtools view -S -b bwa_mem_output/$output\_bwa-mem_human.sam \
	> bwa_mem_output/$output\_bwa-mem_human_aligned.bam
	# Sort BAM file
	samtools sort -o bwa_mem_output/$output\_bwa-mem_human_sorted.bam \
	bwa_mem_output/$output\_bwa-mem_human_aligned.bam
	# Flagstat file
	samtools flagstat bwa_mem_output/$output\_bwa-mem_human_sorted.bam \
	> bwa_mem_output/$output\_bwa-mem_human_sorted_flagstat.txt
	# Remotion of temporary files
	rm bwa_mem_output/$output\_bwa-mem_human.sam bwa_mem_output/$output\_bwa-mem_human_aligned.bam
}

# Variant calling
bcftools(){
	echo "# Variant calling with bcftools"
	# Creation of output directory
	mkdir bcftools_output
	# Calculation of read coverage
	echo "# Calculation of read coverage"
	echo bcftools mpileup -O b -o bcftools_output/$output\_raw.bcf \
	-f ../reference_genome/GCF_000001405.40_GRCh38.p14_genomic.fna \
	bwa_mem_output/$output\_bwa-mem_human_sorted.bam | bash 
	# Detection of the SNVs
	echo "# Detection of the SNVs"
	echo bcftools call --ploidy 1 -m -v -o bcftools_output/$output\_variants.vcf \
	bcftools_output/$output\_raw.bcf | bash 
	# Filter and report the SNVs variants in variant calling format (VCF)
	echo "# Filter and report the SNVs variants in variant calling format (VCF)"
	echo vcfutils.pl varFilter bcftools_output/$output\_variants.vcf \
	\> bcftools_output/$output\_variants_final.vcf | bash 
}

# Execution
trimmomatic_paired
fastqc
bwa_mem
bcftools

# The end!
echo "# End of the script!"#