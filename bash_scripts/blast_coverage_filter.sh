#!/bin/bash
# Created 10.08.2021 by Luigui Gallardo-Becerra (bfllg77@gmail.com)

# Usage and explanation of parameters:
usage () {
    cat <<help
Usage:
$0 {-i/--blast_input_fp BLAST_INPUT_FP -o/--output_prefix} [options]

Options:
-i, --blast_input_fp Input file obtained from blast in tabular format.
-o, --output_prefix  Prefix for the output files.

[] indicates optional input (order unimportant)
{} indicates required input (order unimportant)
help
}

# Print the usage and help if no parameter is given
if [ $# == 0 ] ; then
    usage
    exit
fi

# Arguments input:
# Defaults:
evalue=0.001
minimum_coverage=0.50

while getopts h:i:o:e:g:c: opts
do
    case "$opts" in
        i) input=$OPTARG;;
        o) output=$OPTARG;;
        e) evalue=$OPTARG;;
        g) genome_info=$OPTARG;;
        c) minimum_coverage=$OPTARG;;
        h) usage
        exit 0;;
        *) usage
        exit 1;;
    esac
done

# Print parameters:
parameters(){
    cat <<parameters
Parameters:
Input file = $input
Output prefix = $output
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
    cat $input |
    awk '{if ($11 <= '$evalue') {print}}' \
    > $output\_e-$evalue.txt
}
evalue_filter
echo "Finished step 1: E-value filter"

# 2. Convert to .bed
convert_to_bed() {
bash blast2bed.bash $output\_e-$evalue.txt > /dev/null # Covert .txt to .bed with blast2bed.bash (required to download)
mv $output\_e-$evalue.txt.bed $output\_e-$evalue.bed # Change the name of .bed file
}
convert_to_bed
echo "Finished step 2: Convert to bed"

# 3. Coverage of AMP > 50% of AMP
coverage_filter() {
bedtools genomecov -i $output\_e-$evalue.bed -g $genome_info |
        grep -v genome | # Filter of no required information
        awk '$2 > 0 {print}' | # Zero filter
        awk '{coverage[$1] += $5} END {for (attribute in coverage) print attribute, coverage[attribute]}' | # Coverage calculation per attribute
        tr " " "\t" | # Covert spaces to tabs
        awk '$2 > '$minimum_coverage' {print}' > $output\_e-$evalue\_cov-$minimum_coverage.txt # Print of results into final file
}
coverage_filter
echo "Finished step 3: Coverage filter"

# The end!
echo "End of the script!"