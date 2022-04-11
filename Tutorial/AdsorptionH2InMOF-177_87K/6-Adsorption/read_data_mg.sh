#!/bin/bash

P0=101325

#grep "Average loading absolute" output*
#grep "Average loading excess" output*
#grep "cm^3 (STP)/gr framework" output*

echo "P/P0, absolute[milligram/gram framework], P[Pa], absolute[wt%]" > absolute_results_mg.txt
echo "P/P0, excess[milligram/gram framework], P[Pa], excess[wt%]" > excess_results_mg.txt
for f in *.data
do
  #echo $f
  f2=${f%.data}
  fbase=${f2%_*}
  Pa=${f2//"${fbase}_"/}
  #echo ${Pa}
  #awk '{if($3=="absolute" && $5=="(STP)/gr"){printf "%d", NR}}' $f
  #awk '{if($3=="excess" && $5=="(STP)/gr"){printf "%d", NR}}' $f
  nra=`awk '{if($3=="absolute" && $5=="(STP)/gr"){printf "%d", NR}}' $f`
  nre=`awk '{if($3=="excess" && $5=="(STP)/gr"){printf "%d", NR}}' $f`
  awk -v pre=${Pa} -v p0=${P0} -v NRA=${nra} '{if(NR==(NRA-1)){printf "%12.10f, %12.6f, %12.6f, %4.2f \n", (pre/p0), $6, pre, ($6/10)}}' $f >> absolute_results_mg.txt
  awk -v pre=${Pa} -v p0=${P0} -v NRE=${nre} '{if(NR==(NRE-1)){printf "%12.10f, %12.6f, %12.6f, %4.2f \n", (pre/p0), $6, pre, ($6/10)}}' $f >> excess_results_mg.txt
done
