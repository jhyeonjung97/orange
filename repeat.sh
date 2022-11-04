#!/bin/bash

read -p 'command $ ' cmd

for dir in */
do
    cd $dir
    eval $cmd
    cd ..
done