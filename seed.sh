extension="${1##*.}"
filename="${1%.*}"

sed "/seed/c\seed $2" $1 > $filename$2.inp