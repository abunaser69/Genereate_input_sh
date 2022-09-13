#!/bin/sh


usage()
{
 cat <<EOF
################################################################################################
# Usage: >sub4 filename                                                                        #
#        e.g. "sub-m test" will submit the job test.in to the que                              #
#                                                                                              #
# 1. Filename without ".com"                                                                   #
#                                                                                              #
# 2. specify your memory and nproc-values in the input-file                                    #
################################################################################################
-------------------------------
| Stefan Erhardt / 2007-03-08 |
-------------------------------
EOF
exit 0
} # usage

die()
{
echo $1
exit 1
}


[ -z "$1" ] && usage


input=${1}

#getting the username
username=`whoami`
scratch_dir=`date +%F-%H%M`
cat <<EOF > ${input}.sub
#!/bin/csh
#$ -S /bin/csh
#
# NAME OF JOB
#$ -N $1
#$ -cwd
#$ -j n
#$ -o $1.stdout
#$ -e $1.stderr
#$ -V
# -notify
# -M ${username}@master.beowulf.cluster
#$ -m eas

# DO NOT MAKE CHANGES BETWEEN THE HASHED-LINES
###############################################################
# Request the mpich parallel execution environment, followed by
# the value %nprocl-1, where %nprocl is defined in the gaussian input.
# In this case, %nproc=4.
#\$ -pe mpich 4
#
# Set up the environment variables for G03 and SGE
#

setenv g03root /home/${username}/ChemSoft/G03L
source /home/${username}/ChemSoft/G03L/g03/bsd/g03.login
setenv GAUSS_SCRDIR  /state/partition1/${username}_${scratch_dir}

#

# enables $TMPDIR/rsh to catch rsh calls if available

#

set path=(\$TMPDIR \$path)
setenv NODES \`cat \$TMPDIR/machines\`
#setenv GAUSS_LFLAGS "-nodelist '\${NODES}' -mp 2"


#$ -q all.q


###############################################################
# make temporary scratch dir
mkdir /state/partition1/${username}_${scratch_dir}

# replace "filename.in" with your gaussian com file
g03 ${input}.com

# remove temporary scratch dir
rm -rf /state/partition1/${username}_${scratch_dir}

EOF

qsub ${input}.sub
