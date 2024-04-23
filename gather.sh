#!/bin/bash

cut_tag=''
neb_tag=''
port_tag=''
r=''

while getopts ":c:nrpd:" opt; do
  case $opt in
    c)
      cut_tag=$OPTARG
      ;;
    n)
      neb_tag=1
      ;;
    r)
      r='-r '
      ;;
    p)
      port_tag=1
      ;;
    d)
      send="$OPTARG"
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

# Shift the options out, so $1, $2, etc. are the non-option arguments
shift "$((OPTIND-1))"

if [[ $neb_tag == 1 ]]; then
    # usage: sh gather.sh -n #IMAGES
    read -p "files starts with: " f
    for i in $(seq 1 $2)
    do
        cp 0$i/POSCAR $f-p$i.vasp
        cp 0$i/CONTCAR $f-c$i.vasp
    done
    cp 00/POSCAR $f-p0.vasp
    cp 0$(($2+1))/POSCAR $f-p$(($2+1)).vasp
    cp 00/POSCAR $f-c0.vasp
    cp 0$(($2+1))/POSCAR $f-c$(($2+1)).vasp
    exit 1
fi

if [[ $1 == '-rr' ]]; then
    dirs='*/*/'
    destination='../../'
    shift
else
    dirs='*/'
    destination='../'
fi

if [[ -z $1 ]]; then
    read -p 'which files/directories to move? ' f
else
    f=$1
fi

if [[ $f == 'p' ]] || [[ $f == 'pos' ]]; then
    pattern='POSCAR'
    filename=$2
    if [[ -z $filename ]]; then
        read -p "filename starts with? " filename
    fi
elif [[ $f == 'c' ]] || [[ $f == 'con' ]]; then
    pattern='CONTCAR'
    filename=$2
    if [[ -z $filename ]]; then
        read -p "filename starts with? " filename
    fi
elif [[ $f == 'POSCAR' ]]; then
    pattern='POSCAR'
    filename=$2
    if [[ -z $filename ]]; then
        read -p "filename starts with? " filename
    fi
else
    pattern=$f
fi

list=''
if [[ $port_tag == 1 ]]; then
    send='port'
fi 
# read -p 'vaspsend destination (enter for skip): ' send

for dir in $dirs
do
    cd $dir
    if [[ $cut_tag != 0 ]]; then
        numb=$(echo $dir | cut -c -$cut_tag)
    else
        numb=${dir%/}
    fi
    for file in *
    do
        if [[ $file =~ $pattern ]]; then
            if [[ $pattern == 'POSCAR' ]] || [[ $pattern == 'CONTCAR' ]]; then
                if [[ $f == 'POSCAR' ]]; then
                    cp POSCAR $destination$filename$numb.vasp
                    echo "$dir$fxzfx $filename$numb.vasp"
                elif [[ $pattern == 'POSCAR' ]] && [[ -e initial.vasp ]]; then
                    cp initial.vasp $destination$filename$numb.vasp
                    echo "$dir'initial.vasp' $filename$numb.vasp"
                elif [[ $pattern == 'CONTCAR' ]] && [[ ! -s $file ]]; then
                    cp POSCAR $destination$filename$numb.vasp
                    echo "$dir'POSCAR' $filename$numb.vasp"
                else
                    cp $pattern $destination$filename$numb.vasp
                    echo "$dir$pattern $filename$numb.vasp"
                fi
                list+="$filename$numb.vasp "
            elif [[ $file == 'CHGCAR' ]]; then
                cp $file $destination'chgcar'$numb.vasp
                echo "$dir$file 'chgcar'$numb.vasp"
                list+="chgcar$numb.vasp "
            elif [[ "${file##*.}" == "${pattern##*.}" ]]; then
                filename="${file%.*}"
                extension="${file##*.}"
                if [[ $filename == $extension ]]; then
                    cp $r$file $destination$filename$numb
                    echo "$r$dir$file $filename$numb"
                    list+="$filename$numb "
                else
                    cp $r$file $destination$filename$numb.$extension
                    echo "$r$dir$file $filename$numb.$extension"
                    list+="$filename$numb.$extension "
                fi
            fi
        fi
    done
    cd $destination
done

if [[ -d $send ]]; then
    cp $r$list $send/
elif [[ $send == 'port' ]]; then
    cp $r$list ~/port/
# elif [[ $send =~ 'window' ]]; then
#     echo "scp $list jhyeo@192.168.1.251:~/Desktop/$send"
#     scp $list jhyeo@192.168.1.251:~/Desktop/$send
elif [[ $send =~ 'x2658' ]]; then
    echo "scp $r$list x2658a09@nurion-dm.ksc.re.kr:~/vis"
    scp $r$list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2347' ]]; then
    echo "scp $r$list x2347a10@nurion-dm.ksc.re.kr:~/vis"
    scp $r$list x2347a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2431' ]]; then
    echo "scp $r$list x2431a10@nurion-dm.ksc.re.kr:~/vis"
    scp $r$list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2421' ]]; then
    echo "scp $r$list x2421a04@nurion-dm.ksc.re.kr:~/vis"
    scp $r$list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2755' ]]; then
    echo "scp $r$list x2755a09@nurion-dm.ksc.re.kr:~/vis"
    scp $r$list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'cori' ]]; then
    echo "scp $r$list jiuy97@cori.nersc.gov:~/vis"
    scp $r$list jiuy97@cori.nersc.gov:~/vis
elif [[ $send =~ 'mac' ]]; then
    read -p "which directory? " mac_dir
    echo "scp $r$list hailey@172.30.1.14:~/Desktop/$mac_dir"
    scp $r$list hailey@172.30.1.14:~/Desktop/$mac_dir
elif [[ $send =~ 'mini' ]]; then
    read -p "which directory? " mac_dir
    echo "scp $r$list hailey@192.168.0.241:~/Desktop/$mac_dir"
    scp $r$list hailey@192.168.0.241:~/Desktop/$mac_dir
fi