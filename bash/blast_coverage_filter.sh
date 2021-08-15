#!/bin/bash
#!/bin/bash
# Title: blast_coverage_filter
# Purpose: Calculate and filter a feature from a blast output
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)
# Date: 10.08.2021

# Usage and explanation of parameters:
usage () {
    cat <<help
Usage:
$0 {-i/--blast_input BLAST_INPUT_FP -o/--output_prefix OUTPUT_PREFIX -g/--genome_info LENGTH_PER_GENE} [options]

Options:
-i,	--blast_input	Input file obtained from blast in tabular format.
-o,	--output_prefix	Prefix for the output files.
-g,	--genome_info	Genome information with gene name and length.
-e,	--evalue	E-value cutoff; (default: 0.001).
-c, 	--minimum_coverage	Coverage cutoff; (default; 0.5 = 50%)

[] indicates optional input (order unimportant)
{} indicates required input (order unimportant)
help
}

# Print the usage and help if no parameter is given
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    usage
    exit 1
fi


# Arguments input:
# Defaults:
evalue=0.001
minimum_coverage=0.50

while getopts i:o:e:g:c:h opts
do
    case "$opts" in
        i) blast_input=$OPTARG;;
        o) output_prefix=$OPTARG;;
        e) evalue=$OPTARG;;
        g) genome_info=$OPTARG;;
        c) minimum_coverage=$OPTARG;;
        h) usage
        exit 1;;
    esac
done

# Print parameters:
parameters(){
    cat <<parameters
Parameters:
Input file = $blast_input
Output prefix = $output_prefix
Genome length = $genome_info
E-value = $evalue
Minimum coverage = $minimum_coverage

parameters
}
parameters

# Beginning of the script
echo "Beginning of the script!"

# 1. E-value filter
evalue_filter() {
    cat $blast_input |
    awk '{if ($11 <= '$evalue') {print}}' \
    > $output_prefix\_e-$evalue.txt
}
evalue_filter
echo "Finished step 1: E-value filter"

# 2. Convert to .bed
convert_to_bed() {
bash blast2bed.bash $output_prefix\_e-$evalue.txt > /dev/null # Covert .txt to .bed with blast2bed.bash (required to download)
mv $output_prefix\_e-$evalue.txt.bed $output_prefix\_e-$evalue.bed # Change the name of .bed file
}
convert_to_bed
echo "Finished step 2: Convert to bed"

# 3. Coverage of AMP > 50% of AMP
coverage_filter() {
bedtools genomecov -i $output_prefix\_e-$evalue.bed -g $genome_info |
        grep -v genome | # Filter of no required information
        awk '$2 > 0 {print}' | # Zero filter
        awk '{coverage[$1] += $5} END {for (attribute in coverage) print attribute, coverage[attribute]}' | # Coverage calculation per attribute
        tr " " "\t" | # Covert spaces to tabs
        awk '$2 > '$minimum_coverage' {print}' > $output_prefix\_e-$evalue\_cov-$minimum_coverage.txt # Print of results into final file
}
coverage_filter
echo "Finished step 3: Coverage filter"

# The end!
echo "End of the script!"
