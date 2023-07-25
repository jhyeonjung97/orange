#!/bin/bash

if [[ -z $1 ]] || [[ -z $2 ]]; then
    echo 'wrong usage...'
    exit 1
fi

if [[ $1 == '-ase' ]] || [[ $1 == '-a' ]]; then
    extension=${2##*.}
    filename=${2%.*}
    # echo $extension $filename
    for file in *."$extension"
    do  
        name=$(echo $file | rev | cut -c 6- | rev)
        if [[ $name =~ $filename ]]; then
            # echo $file
            numb=$(echo $name | rev | cut -c -5 | rev)
            # echo $numb
            if [[ $numb =~ '00000' ]]; then
                mv $file $filename'1'.$extension
                # echo $i
                # echo "cp $file $filename'1'.$extension"
            elif [[ $numb =~ '0000' ]]; then
                i=$(echo $numb | rev | cut -c -1 | rev)
                j=$(($i+1))
                mv $file $filename$j.$extension
                # echo $i
                # echo "cp $file $filename$i.$extension"
            elif [[ $numb =~ '000' ]]; then
                i=$(echo $numb | rev | cut -c -2 | rev)
                j=$(($i+1))
                mv $file $filename$j.$extension
                # echo $i
                # echo "cp $file $filename$i.$extension"
            fi
        fi
    done
elif [[ $1 == '-0' ]] || [[ $1 == '-z' ]]; then
    extension=${2##*.}
    filename=${2%.*}
    # echo $extension $filename
    for file in *."$extension"
    do  
        name=$(echo $file | rev | cut -c 6- | rev)
        if [[ $name =~ $filename ]]; then
            numb=$(echo $name | rev | cut -c -5 | rev)
            if [[ $numb =~ '0000' ]]; then
                i=$(echo $numb | rev | cut -c -1 | rev)
                mv $file $filename$i.$extension
            fi
        fi
    done
elif [[ $1 == '-ksoe' ]] || [[ $1 == '-k' ]]; then
    extension=${2##*.}
    filename=${2%.*}
    # echo $extension $filename
    for file in *."$extension"
    do  
        name=$(echo $file | rev | cut -c 6- | rev)
        if [[ $name =~ $filename ]]; then
            # echo $file
            numb=$(echo $name | rev | cut -c -5 | rev)
            # echo $numb
            if [[ $numb =~ '00000' ]]; then
                mv $file $filename'1'.$extension
            elif [[ $numb =~ '00001' ]]; then
                mv $file $filename'10'.$extension
            elif [[ $numb =~ '00002' ]]; then
                mv $file $filename'11'.$extension
            elif [[ $numb =~ '00003' ]]; then
                mv $file $filename'12'.$extension
            elif [[ $numb =~ '00004' ]]; then
                mv $file $filename'13'.$extension
            elif [[ $numb =~ '00005' ]]; then
                mv $file $filename'14'.$extension
            elif [[ $numb =~ '0000' ]]; then
                i=$(echo $numb | rev | cut -c -1 | rev)
                j=$(($i-2))
                mv $file $filename$j.$extension
            elif [[ $numb =~ '000' ]]; then
                i=$(echo $numb | rev | cut -c -2 | rev)
                j=$(($i-2))
                mv $file $filename$j.$extension
            fi
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