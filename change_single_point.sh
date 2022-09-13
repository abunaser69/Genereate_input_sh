#!/bin/bash
for ((i=1;i<=9;i++));do
mv $1.00$i   $1.$i

echo "$i th conformation done"

done

for ((i=10;i<=99;i++));do
mv $1.0$i   $1.$i

echo "$i th conformation done"

done
