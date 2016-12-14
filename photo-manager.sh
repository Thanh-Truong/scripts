#!/bin/bash
#Author: Thanh Truong, Sweden, July 2016
#Reference: https://gist.github.com/pietrop/880a58088c630c960166
rootdir="/Users/thanhtruong/repos/projects/github/temp"

function moving() { 
    img="$1"
    # B means birth of the file
    #creation_date="$(stat -f %SB -t %F $img)"
    # m means modified time of the file
    creation_date="$(stat -f %Sm -t %F $img)"
    
    imgYearDir=${creation_date:0:4}
    
    pushd $rootdir
    if [ ! -d "$imgYearDir" ]; then 
        mkdir "$imgYearDir" 
    fi
    
    pushd $imgYearDir
    if [ ! -d "$creation_date" ]; then
        mkdir "$creation_date"
    fi
    popd # from imgYearDir
    popd # from rootdir
    
    imgNameOnly=${img##*/}
    #echo "ImageNameOnly $imgNameOnly"
    $(mv $img $rootdir/$imgYearDir/$creation_date/$imgNameOnly)

    echo "...to $rootdir/$imgYearDir/$creation_date/$imgNameOnly"
 }


function mover()  {
    #The value of IFS are used as token delimiters or separator for each line.
    #By default, IFS is space so processing filenames containing spaces will not correct
    # because the any utility will break a line with spaces into several lines
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")

    # Note that, here -print0 is not used. Otherwise, it treats '\0' as 'space'
    for thisfile in $(find . -maxdepth 1 -name "$1" \! \( -name "*._*" \) -type f | xargs -0 ); do
	echo "Moving..." $thisfile;
	moving $thisfile;
    done
    #Restore IFS 
    IFS=$SAVEIFS
}

abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred. Exiting..." >&2
    exit 1
}


function test() { 
find . -name "*.txt" | xargs -I{} \
    sh -c ' \
           fname=$1 ; \
           nname=${fname//2009/1}
           mv "$1" "foo/${name}.bar.${ext}"' -- {}
}

function example_processingfilenames() { 
    #The value of IFS (|) are used as token delimiters or separator for each line.
    #By default, IFS is space so processing filenames containing spaces will not correct
    # because the any utility will break a line with spaces into several lines
    for thisfile in $(find . -maxdepth 1 -name "*" \! \( -name "*._*" \) -type f -print0 | xargs -0 ); do
	printf "Found %s \n" $thisfile;
    done

    #Solution is temporarily supressing IFS
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    for thisfile in $(find . -maxdepth 1 -name "*" \! \( -name "*._*" \) -type f -print0 | xargs -0 ); do
	printf "Found %s \n" $thisfile;
    done
    IFS=$SAVEIFS
}
#----------------------------------------
trap 'abort' 0
set -e
## ===> Guarded script goes here
mover "*.MOV"
# Done!
trap : 0
#----------------------------------------

