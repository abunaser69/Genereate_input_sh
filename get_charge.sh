#!/bin/bash
for ((i=1;i<=9;i++));do
awk '{print $9}' Mol_m1-o$i.mol2 | sed -e '/^ *$/d' > charge$i.log
 done
