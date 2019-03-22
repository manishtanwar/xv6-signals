# echo "" > assig2b.inp
for a in 2 3 4 5 6 7 8 9 10 12 14 16
do
   echo $(($a * $a)) "0" "0" $(($a * $a)) >> assig2b.inp
   echo $(time ./maekawa) >> results
done