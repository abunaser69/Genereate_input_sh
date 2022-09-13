#!/bin/bash
for ((i=1;i<=13;i++));do
 cp dbpb.$i dbpb_$i.xyz
 cp dbpb.prm dbpb_$i.prm 
 cp dbpb.key dbpb_$i.key 
 minimize  dbpb_$i.xyz  0.01 >> minimize.log
 grep  "Final Function Value"  minimize.log | cat > temp
 nl -v 1 temp | sort -nr -k 6,6n -o minimize.list
 rm dbpb_$i.prm 
 rm dbpb_$i.key
 rm dbpb_$i.xyz  
 done
rm temp
