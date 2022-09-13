#!/bin/bash
for ((i=1455;i<=1455;i++));do
     babel -ipdb dbpb_c1_$i.pdb -otxyz temp$i.xyz >& /dev/null
sed '
3 s/ 25 /60/
12 s/ P /Pd/
12 s/ 25 /165/
12 s/$/   14/
13 s/ 30 /3/
15 s/$/   11/
21 s/ 5 /21/ ' temp$i.xyz > dbpb_c1_.$i
rm temp$i.xyz
 done
