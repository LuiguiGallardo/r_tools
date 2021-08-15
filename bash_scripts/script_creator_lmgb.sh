#!/bin/bash
# Title: bash_creator_lmgb.sh
# Purpose: Creates a bash script with headers
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)
# Date: 14.08.2021

# Usage and explanation of parameters:

usage(){
    cat <<help
Usage:
$0 {SCRIPT_NAME_FP}

{} indicates required input (order unimportant)
help
}

# Print the usage and help if no parameter is given

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    usage
    exit 1
fi

# Beginning of the script
script_name=$1 # Get the script name from the first parameter
touch $script_name # Creation of the script
read -p 'Title: ' title 
read -p 'Purpose: ' purpose
var=$(date +%d.%m.%Y)

header_creator(){
    cat <<header
#!/bin/bash
# Title: $script_name
# Purpose: $purpose
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)
# Date: $var

# Beginning of the script

# The end!

header
}

header_creator >> $script_name