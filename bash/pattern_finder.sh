#!/bin/bash
# Title: pattern_finder.sh
# Purpose: Find the patters of a file in another
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)
# Date: 14.08.2021

# Usage and explanation of parameters:
usage(){
    cat <<help
Usage:
$0 {-p/--pattern_to_search PATTERN_INPUT_FP -i/--input_to_look INPUT_TO_SEARCH_FP} [options]

Options:
-p, --pattern_to_search  Patterns file to look for.
-i, --input_to_look  Input file where to look for patterns.

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
while getopts p:i:h opts
do
    case "$opts" in
        i) input_to_look=$OPTARG;;
        p) pattern_to_search=$OPTARG;;
        h) usage
        exit 1;;
    esac
done

# Beginning of the script
finder(){
    for s in $(cat $pattern_to_search)
        do awk '/'$s'/' $input_to_look
    done
}
finder

# The end!

