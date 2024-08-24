#! /bin/bash

rm results_summary
rm -rf MAE_RESULTS MAE_RESULTS_Mobley

###################
tot_rep=3
tot_lambdas=20
###################


##create folders and copy .xvg files
for sys in $(awk '{print $1}' systems.dat)

do

cd $sys/

mkdir mbar_analysis

cd mbar_analysis/

for rep in $(seq 1 1 $tot_rep)

do 

mkdir rep_${rep}
cd rep_${rep}

for n_lambda in $(seq 1 1 $tot_lambdas)

do 

ln -s ../../lambda_${n_lambda}/03_prod_r${rep}/dhdl.xvg dhdl_${n_lambda}.xvg  

done
#run alchemical_analysis.py to calculate hydration free energy

dir=/home/afortuna/alchemical-analysis/alchemical_analysis
python2.7 ${dir}/alchemical_analysis.py -q xvg -p dhdl -u kcal

cd ../

done

cd ../../

done


########## create result files ##############
 


echo "#mobley_number #name #EXP_V #GAFF #rep1 #rep2 #rep3 #rep_mean #error" >> results_summary

for sys in $(awk '{print $1}' systems.dat )
do


for rep in $(seq 1 1 $tot_rep) 

do 

declare rep\_${rep}=`awk '/TOTAL/{print $17}' ${sys}/mbar_analysis/rep\_${rep}/results.txt`
declare error\_${rep}=`awk '/TOTAL/{print $19}' ${sys}/mbar_analysis/rep\_${rep}/results.txt`

done

rep_sum=`echo $rep_1+$rep_2+$rep_3 | bc`

rep_mean=`echo "scale=3; $rep_sum/3.000" | bc`

error_mean=`echo $error_1+$error_2+$error_3| bc` 

awk -v sys=$sys -v rep_1=$rep_1 -v rep_2=$rep_2 -v rep_3=$rep_3 -v rep_mean=$rep_mean -v error_mean=$error_mean '$0~sys {print $1, $2, $3, $4, -rep_1, -rep_2, -rep_3, -rep_mean, error_mean/3}' systems.dat >> results_summary

done


echo "#mobley_number #name #EXP_V #rep_mean #error #DIFF #|DIFF| #DIFF^2 #error"  >> MAE_RESULTS

tail -n +2 results_summary | awk '{print $1, $2, $3, $8, $9, $8-$3, sqrt(($8-$3)^2), ($8-$3)^2, (sqrt(($8-$3)^2))/(sqrt(($3)^2))*100}' >> MAE_RESULTS


# Calculate the average deviation from EXP and add it to the bottom of the results
#

tail -n +2 MAE_RESULTS | awk '{ sum1 += $7; sum2 += $8; sum3 += $9 } END {print "#MAE = " sum1 / NR, "#rmse = " sqrt(sum2 / NR), "#avg % err = " sum3 / NR"%" }' >> MAE_RESULTS

## calculate values for no_EP mobley
echo "#mobley_number #name #EXP_V #GAFF #DIFF #|DIFF| #DIFF^2 #error"  >>  MAE_RESULTS_Mobley
#
tail -n +2 results_summary | awk '{print $1, $2, $3, $4, $4-$3, sqrt(($4-$3)^2), ($4-$3)^2, (sqrt(($4-$3)^2))/(sqrt(($3)^2))*100}' >>  MAE_RESULTS_Mobley
## Calculate the average deviation from EXP and add it to the bottom of the results
##
#
tail -n +2 MAE_RESULTS_Mobley | awk '{ sum1 += $6; sum2 += $7; sum3 += $8 } END {print "#MAE = " sum1 / NR, "#rmse = " sqrt(sum2 / NR), "#avg % err = " sum3 / NR"%" }' >> MAE_RESULTS_Mobley

for sys in $(awk '{print $1}' systems.dat)

do

for n_lambda in $(seq 1 1 $tot_lambdas)

do

for rep in $(seq 1 1 $tot_rep)

do


tar -czvf ${sys}/lambda_${n_lambda}/03_prod_r${rep}/dhdl.xvg.gz ${sys}/lambda_${n_lambda}/03_prod_r${rep}/dhdl.xvg

rm -rf ${sys}/lambda_${n_lambda}/03_prod_r${rep}/dhdl.xvg

done

done

done
