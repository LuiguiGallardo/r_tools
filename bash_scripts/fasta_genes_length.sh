#!/bin/bash
# Title: blast_coverage_filter
# Purpose: Calculate and filter a feature from a blast output
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)
# Date: 10.08.2021

# Usage and explanation of parameters:
usage(){
    cat <<help
Usage:
$0 {-i/--fasta_input_fp FASTA_INPUT_FP -o/--output_fp OUTPUT_FP}

Options:
-i, --fasta_input_fp    Input fasta.
-o, --output_fp Output filename.

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
while getopts i:o:h opts
do
    case "$opts" in
        i) input=$OPTARG;;
        o) output=$OPTARG;;
        h) usage
        exit 1;;
    esac
done

# Print parameters:
parameters(){
    cat <<parameters
Parameters:
Input file = $input
Output file = $output

parameters
}
parameters

# Beginning of the script
echo "Beginning of the script!"

# Gene length calculation
gene_length() {
    cat $input | 
    awk '/^>/ {if (seqlen){print seqlen};
        print; seqlen=0; next;}
        {seqlen += length($0)} 
        END{print seqlen}' | # Print last length
    sed 'N;s/\n/\t/' | # Convert \n to \t in the odds rows
    sed 's/>//g' > $output # Remove > at the beginning of the lines
}
gene_length

# The end!
echo "End of the script!"
