#!/bin/bash
for ((i=500;i<=20000;i+=500));do 
    echo 1 1 | g_covar -f hopltpwat1+con+cen.trr  -s hopltpwat.tpr -mwa -o eigen$i.xvg -av average$i.pdb -e $i  
 done
