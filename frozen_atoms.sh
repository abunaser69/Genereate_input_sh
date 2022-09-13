#!/bin/bash

file_name=$1
dir=`pwd`
cp $file_name".key" jonas
cp sm.key.back sm.key

{

 while read number atom x y z type con_1 con_2 con_3 con_4 con_5 con_6; do

   if [ $atom = Ru ];then

     a="inactive $number $con_1 $con_2 $con_3 $con_4 $con_5 $con_6" 

   fi

   if [ $atom = N ];then

     a="$a $number $con_1 $con_2 $con_3" 

   fi
   
 done

} < $dir/$file_name".xyz"

a=`echo "$a\ndelete_jonas"`

sed '
s/inactive/'"$a"'/g' jonas > $file_name".key" 

cp $file_name".key" jonas

sed '
/delete_jonas/d' jonas > $file_name".key"

rm jonas
