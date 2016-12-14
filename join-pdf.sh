#!/bin/bash
#Author: Thanh Truong, Sweden, July 2016

# OSX ships with a Python script that does the job
# "/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" 
#-o path-to-your-merged-file.pdf file1.pdf file2.pdf path-to-directory/*.pdf

join_py="/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py"
read -p "Name of merged PDF > " output_file
"$join_py" -o $output_file "$@"
open $output_file

#    ./join_pdf.sh all.pdf p1.pdf p2.pdf
