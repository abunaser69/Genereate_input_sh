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

for IRC in forward reverse
do
cp "$file1".chk "$file2"-"$IRC".chk
cat > "$file2"_"$IRC".com <<!
%nproc=2
%Mem=1900Mb
%chk=$file2-$IRC.chk
#p bp86/GEN PSEUDO=READ irc=(rcfc,maxpoints=100,maxcyc=10,$IRC)
gfinput scfcyc=250 geom=checkpoint

Automatically generated IRC $IRC input file

1  1

h,c,o 0
6-31g**
*****
pd 0
sddall
*****
p 0
sddall
d 1 1.
0.387 1.
*****

pd 0
sddall
p 0
sddall


!

sub "$file2"_"$IRC"
done

##############################
