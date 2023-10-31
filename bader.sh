function baderchg {
    chgsum.pl AECCAR0 AECCAR2
    bader CHGCAR -ref CHGCAR_sum
}

if ! [[ $1 == '-r' ]]; then
    bader-chg
else
    for dir in */
    do
        cd $dir
        baderchg
        cd ..
    done
fi