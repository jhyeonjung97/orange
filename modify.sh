# functions
function modify {
    if [[ -z $(grep $2 $1) ]]; then
        echo $2 >> $1
    fi
    
    if [[ -z $3 ]]; then
        sed -i "s/#$2/$2/" $1
        sed -i "s/$2/#$2/" $1
    else
        sed -i "/$2/c\\$2 = $3" $1
    fi
}

modify $1 $2 $3
grep $2 $1