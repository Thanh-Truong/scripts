#!/bin/bash
#Author: Thanh Truong, Sweden, July 2016
#Reference: https://gist.github.com/pietrop/880a58088c630c960166

if [ "$1" == "" ]; then
    printf 'Every publication on Issu.com has its own documentationId.\n'
    printf 'step 1 - Use Chrome browser, inpsect its source, to identify that number\n'
    printf 'step 2 - download_issu <documentationId> <num-of-pages-to-be-downloaded>\n'
    printf '$./download 100522175445-15f961a117e74461a82edd9bad3cdbf8 135\n'
else

#Intialization variables
#Example http://image.issuu.com/100522175445-15f961a117e74461a82edd9bad3cdbf8/jpg/page_1.jpg
url_page_1="http://image.issuu.com/"$1"/jpg/page_1.jpg"
len=${#url_page_1}
url_page_=${url_page_1:0:(len - 5)} #length of string "1.jpg" la 5
c=1

#Download pages
while (( "$c" <= "$2" ));
do 
    printf '%s \n'$url_page_$c".jpg"
    curl $url_page_$c".jpg" -o "page_"$c".jpg"
    c=$((c+1))
done
fi
printf 'Done\n' 

exit 0
