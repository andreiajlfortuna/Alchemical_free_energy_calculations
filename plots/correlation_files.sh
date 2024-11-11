#! /bin/bash

method=EP1

for halogen in iodo bromo chloro

do

rm -rf RESULTS_${halogen}_${method} 

i=MAE_RESULTS_${halogen}_${method}
cat $i | head -n -1 >> RESULTS_${halogen}_${method}
sed -i 's/#//g' RESULTS_${halogen}_${method}

done
method=EP1

for halogen in iodo bromo chloro

do

rm -rf CORRELATIONS_${method} 

./get-stats.py RESULTS_${halogen}_${method} EXP_V rep_mean >> TMP1_${halogen}

MAE=$(grep MAE TMP1_${halogen} | awk '{print $3}')
Pearson=$(grep Pearson TMP1_${halogen} | awk '{print $2}')
Kendall=$(grep Kendall TMP1_${halogen} | awk '{print $2}')
Spearman=$(grep Spearman TMP1_${halogen} | awk '{print $2}') 

echo "   ${halogen}" >> TMP2_${halogen}
echo "MAE       ${MAE}" >> TMP2_${halogen}
echo "Pearson   ${Pearson}" >> TMP2_${halogen}
echo "Kendall   ${Kendall}" >> TMP2_${halogen}
echo "Spearman  ${Spearman}" >> TMP2_${halogen}

done

paste TMP2_iodo TMP2_bromo TMP2_chloro >> CORRELATIONS_${method} 

rm -rf TMP*
