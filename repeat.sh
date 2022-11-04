#!/bin/bash

read -p 'command $ ' cmd

for dir in */
do
    eval $cmd
done