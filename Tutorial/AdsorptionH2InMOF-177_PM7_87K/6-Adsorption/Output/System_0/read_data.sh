#!/bin/bash

#grep "Average loading absolute" output*
#grep "Average loading excess" output*
#grep "cm^3 (STP)/gr framework" output*

echo "P/P0, absolute[cm3 (STP)/gr framework]" > absolute_results.txt
echo "P/P0, excess[cm3 (STP)/gr framework]" > excess_results.txt
for f in *.data
do
  #echo $f
  f2=${f%.data}
  fbase=${f2%_*}
  Pa=${f2//"${fbase}_"/}
  #echo ${Pa}
  awk -v pre=${Pa} '{if($3=="absolute" && $5=="(STP)/gr"){printf "%12.10f, %12.6f \n", (pre/101325), $7}}' $f >> absolute_results.txt
  awk -v pre=${Pa} '{if($3=="excess" && $5=="(STP)/gr"){printf "%12.10f, %12.6f \n", (pre/101325), $7}}'   $f >> excess_results.txt
done
