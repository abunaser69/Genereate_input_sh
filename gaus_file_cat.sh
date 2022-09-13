#!/bin/bash
for ((i=1;i<=5;i++));do
cat  dbpb_charge$i.log >> all_gaus.log
done
 echo "No worries! Everythings done"
