#!/bin/bash
#!/bin/bash
# Title: blast_besthit_features_count
# Purpose: Calculate and filter a feature from a blast output
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)
# Date: 10.08.2021

# Usage and explanation of parameters:
usage () {
    cat <<help
Usage:
$0 {-i/--blast_input BLAST_INPUT_FP -o/--output_prefix OUTPUT_PREFIX}

Options:
-i,	--blast_input	Input file obtained from blast in tabular format.
-o,	--output_prefix	Prefix for the output files.

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
while getopts i:o:h opts
do
    case "$opts" in
        i) blast_input=$OPTARG;;
        o) output_prefix=$OPTARG;;
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

parameters
}
parameters

# Beginning of the script
echo "Beginning of the script!"

feature_count(){
    printf '#\n#featureID\t'$output_prefix'\n' > $output_prefix.txt
    cat $blast_input |
    grep -v \# |
    sort -u -k 1,1 |
    cut -f 2 | sort |
    uniq -c |
    sed 's/^ *//g ; s/ /\t/g' |
    awk  '{print $2 "\t" $1}' >> $output_prefix.txt
}
feature_count

# The end!
echo "End of the script!"