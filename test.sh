#!/bin/bash

xc_tag=0
mag_tag=0
submit=''
filename=''
jobname=''

while getopts ":x:m:l:i:o:" opt; do
  case $opt in
    x)
      xc_tag=1
      ;;
    m)
      mag_tag=1
      ;;
    l)
      submit='multi'
      ;;
    i)
      filename="$OPTARG"
      ;;
    o)
      jobname="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "1 $xc_tag 2 $mag_tag 3 $submit 4 $filename 5 $jobname"