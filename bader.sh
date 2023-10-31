function bader {
    chgsum.pl AECCAR0 AECCAR2
    bader CHGCAR -ref CHGCAR_sum
    }

function directory {
    if ! [[ $2 == '-r' ]]; then
        $1
    else
        for dir in */
        cd $dir
        $1
        cd ..
    fi
    }
    
directory bader $1
