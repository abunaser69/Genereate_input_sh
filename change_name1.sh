#!/bin/bash
for ((i=0;i<=9;i++));do
     mv xx0$i   xx$i
 done

for ((i=0;i<=999;i++));do
     mv xx$i   dbpb_$i.pdb
 done
