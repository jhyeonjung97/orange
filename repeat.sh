#!/bin/bash

read -p "which command? " c

for i in {$1..$2}
do
    $c
done