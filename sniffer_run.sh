#!/bin/bash
for ((i=0;i<=6461;i++));do
     sniffer dbpb_c1_.$i 100 -2000.0 1.0 >> sniffer.log
#     grep  "Final Function Value"  sniffer.log | cat > temp
#     nl -v 0 temp | sort -nr -k 6,6n -o sniffer.list
 done
