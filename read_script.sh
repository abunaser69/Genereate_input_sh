#!/bin/bash

dir=`pwd`
old_energy=0.0
i=0

{

 while read number s1 s2 s3 s4 energy; do
    dif=`echo "$energy - $old_energy" | bc`
    test=`echo "$dif <= 0.0002" | bc`
    if [ $test -ne 1 ]
    then

       i=`expr $i + 1`
       cp $dir/"Ru_complex_isomer_b_"$number".xyz_2" $dir"/XYZ-files/c"$i

    fi

    old_energy=$energy

 done

} < $dir/minimize.list


