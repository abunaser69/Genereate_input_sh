#!/bin/bash
for ((i=0;i<=2;i++));do
     babel -ipdb geom_$i.pdb -otxyz temp1_$i.xyz >& /dev/null
sed '
2 s/ Xx/ Ru/ ' temp1_$i.xyz > temp2_$i.xyz 
./tinker_connect.pl temp2_$i.xyz > temp3_$i.xyz
paste temp3_$i.xyz connect.xyz > final.$i
rm temp1_$i.xyz temp2_$i.xyz temp3_$i.xyz 
echo "$i th conformation done"
done
