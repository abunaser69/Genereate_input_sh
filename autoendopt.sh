#!/bin/bash
file1=$1

if [ $# -eq 0 ]
then
echo 'no input given'
exit 1
fi

if [ $# -ge 3 ]
then
echo 'too many inputs'
exit 1
fi

if [ $# -eq 1 ]
then
file2=$file1
else
	if [ $# -eq 2 ]
	then
	file2=$2
	fi
fi

cp "$file1".chk "$file2"-endopt.chk
cat > "$file2"-endopt.com <<!
%mem=1900Mb
%chk=$file2-endopt.chk
#p bp86/GEN opt=(gdiis) freq=noraman
gfinput scfcyc=200 PSEUDO=READ geom=checkpoint

Automatically generated optimisation input file from $file1

0  1

Ru 0 
SDDALL
***** 
P  0  
SDDALL
D 1 1.
0.387 1.
***** 
Cl 0
SDDALL
D 1 1.
0.640 1.
*****
C H N O 0
6-31G**
*****

Ru 0 
SDDALL
P 0  
SDDALL
Cl 0
SDDALL


!

sub "$file2"-endopt

##############################
