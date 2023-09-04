alias jl='cd ~/bin
jupyter-lab'
alias jn='cd ~/bin
jupyter notebook'

alias cdw='cd ~/Desktop/'
alias vbash='vi ~/.zshrc'
alias sbash='source ~/.zshrc'
alias port='scp -P 54329 hyeonjung@burning.postech.ac.kr:~/port/*.vasp .'

alias vasp2png='python ~/bin/shoulder/vasp2png.py'
alias style='open /Applications/VESTA/VESTA.app/Contents/Resources/style.ini'
alias element='open /Applications/VESTA/VESTA.app/Contents/Resources/elements.ini'
alias carbon='sed -i -e "s/1.89002  0  2/1.89002  0  0/" *.vesta'

alias orange='dir_now=$PWD
cd ~/bin/orange
git pull
git add *
git commit -m "."
git push
cd $dir_now'
alias shoulder='dir_now=$PWD
cd ~/bin/shoulder
git pull
git add *
git commit -m "."
git push
cd $dir_now'
