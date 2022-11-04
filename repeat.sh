#!/bin/bash


read -p 'command (no alias) $ ' cmd

for dir in */
do
    cd $dir
    exec $cmd
    cd ..
done