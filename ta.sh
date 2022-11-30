#!/bin/bash

if [[ $1 =~ q ]]; then
    for dir in */
    do
        cd $dir
        if [[ -e stdout.log ]]
            echo $dir$(grep '!    total energy' stdout.log | tail -n 1)
        else
            echo $dir
        cd ..
    done
else
    tail -n 6 */stdout*
fi