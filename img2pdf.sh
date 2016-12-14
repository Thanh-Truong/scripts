#!/bin/bash
#--------------------------------- 
# Author: Thanh Truong
# http://github.com/thanhtruongc
# Uppsala, Sweden, July 2016
#---------------------------------
# Reference: https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/sips.1.html
# Sip: scriptable image processing
sips -s format pdf "$1" --out "${1%.*}.pdf"
