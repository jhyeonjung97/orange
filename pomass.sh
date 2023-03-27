#!/bin/bash

# grab POMASS data from POTCAR
pomass=$(grep 'POMASS =' POTCAR | awk '{print $3}' | tr -d ';')
pomass_line=$(echo $pomass)

# check if POMASS line exists in INCAR
if grep -q 'POMASS' INCAR; then
  # replace POMASS line in INCAR with POMASS data from POTCAR
  sed -i "s/POMASS/POMASS = $pomass_line/" INCAR
else
  # add POMASS line to INCAR with POMASS data from POTCAR
  echo "POMASS = $pomass_line" >> INCAR
fi

# replace 1.000 with 2.000 in the line containing POMASS and 1.000 in the INCAR file
sed -i 's/POMASS\s*=\s*\(.*\)\b1\.000\b\(.*\)/POMASS = \1 2.000 \2/' INCAR
