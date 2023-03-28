#!/bin/bash

alias run='sh ~/bin/orange/run-nurion.sh'
alias pestat='pbs_status | head -n 2
pbs_status | grep normal
pbs_status | grep norm_skl
pbs_status | grep long'
alias mystat='qstat -u x2347a10
qstat -u x2421a04
qstat -u x2431a10'
alias ta='tail -n 6 */stdout.log'
alias taa='tail -n 6 */*/stdout.log'