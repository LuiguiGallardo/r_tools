#!/bin/bash
# Created 10.08.2021 by Luigui Gallardo-Becerra (bfllg77@gmail.com)

# Usage and explanation of parameters:
usage () {
    cat <<help
Usage:
$0 {-i/--fasta_input_fp FASTA_INPUT_FP -o/--output_fp OUTPUT_FP}

Options:
-i, --fasta_input_fp    Input fasta.
-o, --output_fp Output filename.

[] indicates optional input (order unimportant)
help
}

# Print the usage and help if no parameter is given
if [$# == 0] ; then
    usage
    exit
fi

# Arguments input:
while getopts h:i:o: opts
do
    case "$opts" in
        i) input=$OPTARG;;
        o) output=$OPTARG;;
        h) usage
        exit 0;;
        *) usage
        exit 1;;
    esac
done

awk '/^>/ {if (seqlen){print seqlen}; print ;seqlen=0;next; } { seqlen += length($0)}END{print seqlen}'

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
    awk '/^>/ {if (seqlen){print seqlen};\
        print; seqlen=0; next;}\
        {seqlen += length($0)} 
        END{print seqlen}' | # Print last length
    tr "\n" "\t" | # Convert \n to tabs
    sed 's/>//g' # Remove > at the beginning of the lines
}

# The end!
echo "End of the script!"
