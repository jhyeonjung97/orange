#!/bin/bash

if [[ -z $1 ]] || [[ -z $2 ]]; then
    echo 'wrong usage...'
    exit 1
fi

if [[ $1 == '-ase' ]] || [[ $1 == '-a' ]]; then
    extension=${2##*.}
    filename=${2%.*}
    echo $extension $filename
    for file in $filename*.$extenstion
    do
        echo $file
        # name=$(echo $file | rev | cut -c 6- | rev)
        numb=$(echo $file | rev | cut -c -5 | rev)
        if [[ $numb == 00000 ]]; then
            cp $file "$filename"1.$extension
        elif [[ $numb == 0000* ]]; then
            i = $(echo $file | rev | cut -c -1 | rev)
            cp $file $filename$i.$extension
        elif [[ $numb == 000* ]]; then
            i = $(echo $file | rev | cut -c -2 | rev)
            cp $file $filename$i.$extension
        fi
    done
else
    extension1=${1##*.}
    filename1=${1%.*}
    extension2=${2##*.}
    filename2=${2%.*}
    for i in {0..9}
    do
        if [[ -e $filename1$i.$extension1 ]]; then
            mv $filename1$i.$extension1 $filename2$i.$extension2
        fi
    done
fi