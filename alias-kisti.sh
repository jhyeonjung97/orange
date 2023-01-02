#!/bin/bash

alias cdw="cd /scratch/${account}"
alias run='sh ~/bin/orange/run-kisti.sh'
alias pestat='pbs_status | head -n 2
pbs_status | grep normal
pbs_status | grep norm_skl
pbs_status | grep long'
alias mystat="qstat -u ${account}"
alias ta='tail -n 6 */stdout.log'
alias taa='tail -n 6 */*/stdout.log'