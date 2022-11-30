#!/bin/bash

if [[ $1 =~ q ]]; then
    for dir in */
    do
        cd $dir
        echo "$dir"stdout.log
        grep '!    total energy' stdout.log | tail -n 1
        cd ..
    done
else
    tail -n 6 */stdout*
fi