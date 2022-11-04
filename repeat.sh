#!/bin/bash

read -p 'command $ ' cmd

for dir in */
do
    cd $dir
    exec $cmd
    cd ..
done