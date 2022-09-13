#!/bin/bash

dir=`pwd`
i=0

mkdir Parameter_file
mkdir Minimize
mkdir High_temp_MD

cp /home/haller/MM/Template_files/Tautomerism/Start_material/sm.prm $dir/Parameter_file
cp /home/haller/MM/Template_files/Tautomerism/Start_material/sm.key $dir/Parameter_file

cp /home/haller/MM/Template_files/Tautomerism/Start_material/mdrun.inp $dir/High_temp_MD

cp /home/haller/MM/Template_files/Tautomerism/Start_material/minimize.sh $dir/Minimize
cp /home/haller/MM/Template_files/Tautomerism/Start_material/change_name_single_point.sh $dir/Minimize
cp /home/haller/MM/Template_files/Tautomerism/Start_material/read_script.sh $dir/Minimize
