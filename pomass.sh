#!/bin/bash

# grab POMASS data from POTCAR
pomass=$(grep 'POMASS =' POTCAR | awk '{print $3}' | tr -d ';')

# check if POMASS line exists in INCAR
if grep -q '^POMASS' INCAR; then
  # replace POMASS line in INCAR with POMASS data from POTCAR
  sed -i "s/^POMASS.*$/POMASS = $pomass/" INCAR
else
  # add POMASS line to INCAR with POMASS data from POTCAR
  echo "POMASS = $pomass" >> INCAR
fi