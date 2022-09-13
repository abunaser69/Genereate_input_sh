#!/bin/bash
echo "Please provide me a file name containg the charges......."
read fname
exec<$fname
value=0
while read line
do
value=`expr $value + 1`;
echo "charge     $value    $line" >> charge.log 
done    
echo "everything written in charge.log"
