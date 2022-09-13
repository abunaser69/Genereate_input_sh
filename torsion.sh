#!/bin/bash

file_name=$1
dir=`pwd`


#Set parameters

cp $file_name.prm jonas 
q=0
search_pattern="torsion"
w_flag=0


while [ $w_flag == 0 ]; do

  analyze $file_name.xyz > temp2 l

  {

  while read s1 rest; do

    if [ $s1 = Torsion ];then
      if [ $q == 0 ];then

        write_var="$s1 $rest" 
        echo -e "$write_var" >> final
        q=1

      fi
    fi

  done

  if [ $q == 0 ];then

    w_flag=1

  fi

  q=0

  } < $dir/temp2

  {

  while read s1 s2 s3 s4 s5 q1 q2 q3 q4; do
  
    echo "hej!"
 
    a="torsion      $q1    $q2    $q3    $q4      0.000 0.0 1    0.000 180.0 2    0.000 0.0 3" 

    b=`echo "$a\n#append_here"`
   
    sed '
    s/#append_here/'"$b"'/g' jonas > $file_name.prm 
     
    cp $file_name.prm jonas
    cp final final_$w     

  done

  } < $dir/final


  sed '1d' final > final_n
  cp final_n final 

done

rm final* temp2 jonas
