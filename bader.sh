function bader-chg {
    chgsum.pl AECCAR0 AECCAR2
    bader CHGCAR -ref CHGCAR_sum
    }

function directory {
    if ! [[ $2 == '-r' ]]; then
        $1
    else
        for dir in */
        do
            cd $dir
            $1
            cd ..
        done
    fi
    }
    
directory bader-chg $1
