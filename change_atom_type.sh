#!/bin/bash

file_name=$1
dir=`pwd`
cp $file_name".xyz" jonas
cp $file_name".xyz.back" $file_name".xyz"

{

 while read number atom x y z type con_1 con_2 con_3 con_4 con_5 con_6; do

   if [ $atom = P ];then

     type=25
     a="$atom    $x   $y    $z     $type    $con_1   $con_2   $con_3   $con_4 $con_5   $con_6" 

   fi

   if [ $atom = Ru ];then

     type=165
     b="$atom    $x   $y   $z    $type    $con_1    $con_2   $con_3   $con_4  $con_5   $con_6" 

     echo $type
     echo $con_1
     echo $con_2

   fi

   if [ $atom = N ];then

     type=9
     c="$atom     $x    $y    $z      $type   $con_1   $con_2   $con_3  $con_4  $con_5   $con_6" 

   fi
   
 done

} < $dir/$file_name".xyz"

a=`echo "$a\ndelete_jonas"`
b=`echo "$b\ndelete_jonas"`
c=`echo "$c\ndelete_jonas"`


sed '
s/P/'"$a"'/g' jonas > $file_name".xyz" 

cp $file_name".xyz" jonas

sed '
s/Ru/'"$b"'/g' jonas > $file_name".xyz" 

cp $file_name".xyz" jonas

sed '
s/N/'"$c"'/g' jonas > $file_name".xyz" 

cp $file_name".xyz" jonas

sed '/delete_jonas/d' jonas > $file_name".xyz"

rm jonas
