dir=`pwd`
cd $dir
for i in $*
do
atoms=`head -1 $i | gawk '{printf $1}'`
coords=`tail -$atoms $i | gawk '{printf $2 " " $3 " " $4 " " $5 "\n"}'`
cat > temp <<!
$atoms

$coords
!
lines=`expr $atoms + 2`
head -$lines temp > $i.xyz
echo "$i.xyz created"
rm temp
done
