#/bin/bash
a=`grep 'SCF Done' $1 | nl | tail -n 1 | awk '{printf  $6}'`
b=`grep 'Sum of electronic and zero-point Energies'   $1 | awk '{printf  $7}'` 
c=`grep 'Sum of electronic and thermal Free Energies' $1 | awk '{printf  $8}'`
echo "          $a	$b	$c"
