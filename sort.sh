#!/bin/bash
     grep  "Final Function Value"  sniffer.log | cat > temp
     nl -v 0 temp | sort -nr -k 6,6n -o sniffer.list
