#!/bin/bash

#######################################################################
#wirtten by Abu Naser                                                 #
#IMPORTANT:                                                           #
# 1)the script will start from a directory which MUST contains: *.prm,#
#   *.ml, *.dat, *.crd, *.key  tinker connection information (s2)     #
# 2)make sure in the *.dat file pop=(mk,readatradii) is present.      #
# 3) make sure you have the correct inactive atom in key files        #
#                                                                     #
#THIS SCRIPT ALSO CALLS FOLLOWING SMALL SCRIPTS:                      #
# 1) get_esp_charge.awk(Gaussian)                                     #
# 2) charge_for_tinker_key.sh                                         #
# 3) getqmmmxyz.pl                                                    #
# 4) tinker_connect.pl                                                #
# 5) tinker2qmmm_pt.pl                                                #
# USAGE: automate_qmmm_min_orca_whole.sh file name without extenstion #
#######################################################################

file=$1
cdir=`pwd`       

########################################
#1st QM optimization start             #
########################################

cd $cdir
mkdir  qmmm_opt_0
cp $cdir/$1.crd $cdir/qmmm_opt_0/$1_0.crd 
cp $cdir/$1.prm $cdir/qmmm_opt_0/$1_0.prm
cp $cdir/$1.ml $cdir/qmmm_opt_0/$1.ml
cp $cdir/$1.dat $cdir/qmmm_opt_0/temp.dat

#############################################
# Changing atom distance in *.dat file      #
#############################################
sd01=`sed -n '35p' $cdir/qmmm_opt_0/temp.dat | sed 's/^[ \t]*//;s/[ \t]*$//'`
sd02=`sed -n '35p' $cdir/qmmm_opt_0/temp.dat | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{print $1" "$2" "$3}'`
sd03=`echo $sd02 F`
sed '
35 s/'"$sd01"'/'"$sd03"'/' $cdir/qmmm_opt_0/temp.dat > $cdir/qmmm_opt_0/$1_0.dat

####################################
#Changing qmmm ml file             #
####################################

#######################################################
# Please check the original ml files for line numbers #
#######################################################

cd qmmm_opt_0/

sed '
17 s/'"$1"'/'"$1"'_'"0"'/ 
124 s/('"$1"')/('"$1"'_'"0"')/ ' $1.ml > $1_0.ml

chmod a+rwx $1_0.ml

rm $1.ml

./$1_0.ml >> $cdir/qmmm.log&
wait

############################################
# Extracting energies from *.out file      #
############################################

cd $cdir

a=`grep -A 2 'External Optimization with Gaussian' $cdir/qmmm_opt_0/$1_0/$1_0.out | tail -n 1 | awk '{printf  $3}'`
c=`grep -A 2 'Display of QMMM energy (a.u.):'  $cdir/qmmm_opt_0/$1_0/$1_0.out | tail -n 1 | awk '{printf  $1}'`
echo "$1_0 th qm optimization energy $a" >> optimization_energy.log&
echo "$1_0 th qm optimization done" >> qmmm.log& 
echo "$1_0 th qmmm energy $c" >> qmmm_energy.log&

###################################
#Start off the iteration loop     #
##################################

for ((i=1;i<=30;i++));do

########################
#MM optimization start #
########################

mkdir mm_opt_$i
cp $cdir/$1.prm $cdir/mm_opt_$i/$1_$i.prm
cp $cdir/$1.key $cdir/mm_opt_$i/$1.key
cp $cdir/s2 $cdir/mm_opt_$i/s2_$i

##############################################
#copying files from the previous calculation #
##############################################

cp $cdir/qmmm_opt_$((i-1))/$1_$((i-1))/$1_$((i-1)).g03out $cdir/mm_opt_$i
cp $cdir/qmmm_opt_$((i-1))/$1_$((i-1))/$1_$((i-1)).out  $cdir/mm_opt_$i
cd $cdir/mm_opt_$i

###################################################
#Get the charge from the gaussian/orca file       #
#Need to change the script according to programme #
###################################################

get_esp_charge.awk $1_$((i-1)).g03out > charge_$i

#########################################
#Formatting charge for tinker key files #
#########################################

charge_for_tinker_key.sh charge_$i > charge_$i.log

#########################################
#Deleting charge from existing key file #
#########################################

sed -e '/charge /d' $1.key > $1_$i.key

##########################################
# Including new charge for new key file  #
##########################################

cat charge_$i.log >> $1_$i.key

##########################################################
#Get the cartesian coordinate from previous run output   #
##########################################################

getqmmmxyz.pl $1_$((i-1)).out 

##########################################################
#convert cartesian coordiante to tinker file using babel #
##########################################################

babel -ixyz qmmm.xyz -otxyz s1 >& /dev/null

##############################################################
# Babel gives wrong connection information; replace with     #
# the correct connection using paste for a particular system #
##############################################################

tinker_connect.pl s1 > s1_$i
paste -d" " s1_$i s2_$i >s3_$i
cp s3_$i $1_$i.xyz

############################
#Running MM minimization   #
############################

minimize $1_$i.xyz 0.001 > mm.log 
wait
# mm optimization done
cd $cdir 
echo "$1_$i th mm optimization done" >> qmmm.log &

###############################
#QM optimization              #
###############################

mkdir qmmm_opt_$i

############################################
#Copying tinker coordinated from mm folder #
############################################

cp $cdir/mm_opt_$i/$1_$i.xyz_2 $cdir/qmmm_opt_$i/
cp $cdir/$1.prm $cdir/qmmm_opt_$i/$1_$i.prm
cp $cdir/$1.ml $cdir/qmmm_opt_$i/temp_$i.ml
cp $cdir/$1.dat $cdir/qmmm_opt_$i/temp.dat

#############################################
# Changing atom distance in *.dat file      #
#############################################

sd1=`sed -n '35p' $cdir/qmmm_opt_$i/temp.dat | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{print $3}'`
sd2=`sed -n '35p' $cdir/qmmm_opt_$i/temp.dat | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{print $6}'`
sd3=`echo $sd2*$i | bc`
sd4=`echo $sd1 + $sd3 | bc`
sed '
35 s/'"$sd1"'/'"$sd4"'/' $cdir/qmmm_opt_$i/temp.dat > $cdir/qmmm_opt_$i/$1_$i.dat
 

###########################################
#Converting coordinate for qmmm programme #
###########################################

cd  $cdir/qmmm_opt_$i/
tinker2qmmm_pt.pl $1_$i.xyz_2 > temp1_$i.xyz

##########################################################
#IMPORTANT:Make sure you change the two letter atom name #
#          according to the line numbers                 #
########################################################## 

sed '
4 s/ P/ Pt/
5 s/ C/ Cl/
6 s/ C/ Cl/
7 s/ C/ Cl/ 
111 s/ N/ Na/' temp1_$i.xyz > $1_$i.crd

######################################################
# Please check the original ml files for line numbers #
######################################################

sed '
17 s/'"$1"'/'"$1"'_'"$i"'/ 
124 s/('"$1"')/('"$1"'_'"$i"')/ ' temp_$i.ml > $1_$i.ml 

chmod a+rwx $1_$i.ml

./$1_$i.ml  >> ../qmmm.log &

wait

############################################
# Extracting energies from *.out file      #
############################################
 
cd $cdir
b=`grep -A 2 'External Optimization with Gaussian' $cdir/qmmm_opt_$i/$1_$i/$1_$i.out | tail -n 1 | awk '{printf  $3}'`
d=`grep -A 2 'Display of QMMM energy (a.u.):'  $cdir/qmmm_opt_$i/$1_$i/$1_$i.out | tail -n 1 | awk '{printf  $1}'`
echo "$1_$i th qm optimization energy $b" >> optimization_energy.log&
echo "$1_$i th qm optimization done" >> qmmm.log&
echo "$1_$i th qmmm energy $d" >> qmmm_energy.log&
#rm temp

#############
#End of loop #
#############

done

####################################
#---------- END OF SCRIPT-----------#
#####################################
