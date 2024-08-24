rm progress_init

tot_lambdas=20

for sys in $(awk '{print $1}' systems.dat)

do 

for n_lambda in $(seq 1 1 $tot_lambdas)

do 

tot_rep=5

for rep in $(seq 1 1 $tot_rep)

do 

file=${sys}/lambda_${n_lambda}/02_equil_r${rep}/npt2.tpr

 if [ -f "$file" ]
 
 then progress=1
 
 else progress=0
 
 fi
 

 echo $sys lambda_$n_lambda r_$rep $progress >> progress

 
 done
 
 #lambda=lambda_$n_lambda
 #sum_lambdas=`awk -v lambda=$lambda '$0~lambda {sum+=$4} END {print sum}' progress`
 #percent_lambda=$(((sum_lambdas*100)/5))
 #echo lambda_$n_lambda = $percent_lambda %


 done

final_percent_lambda=`awk -v sys=$sys '$0~sys {sum+=$4} END {print sum}' progress`
echo total $final_percent_lambda % >> progress

n=$(awk '{print $1}' systems.dat | wc -l)

sum_systems=`awk '/total/{sum+=$2} END {print sum}' progress`
final_progress=`echo "scale=0; $sum_systems/$n" | bc`
echo $sys percentage = $final_percent_lambda %

done


echo '                      . . . .                       '
echo '                      ,`,`,`,`,                     '  
echo '. . . .               `\`\`\`\;                     '
echo '`\`\`\`\`,            ~|;!;!;\!                     ' 
echo ' ~\;\;\;\|\          (--,!!!~`!       .             '
echo '(--,\\\===~\         (--,|||~`!     ./              '
echo " (--,\\\===~\          ,-,~,=,:. _,//               "
echo "  (--,\\\==~~\        ~-=~-.---|\;/J,               "
echo '   (--,\\\((```==.    ~"`~/       a |               '
echo '     (-,.\\("("(`\\.  ~"=~|     \_.  \                   Righ now, the work submitted '
echo '        (,--(,(,(,.\\. ~"=|       \\_;>                       has a progress of'
echo "          (,-( ,(,(,;\\ ~=/        \                                   $final_progress %"
echo '          (,-/ (.(.(,;\\,/          )               '
echo '           (,--/,;,;,;,\\         ./------.         '
echo '             (==,-;-"`;"         /_,----`. \        '
echo '     ,.--_,__.-"                    `--.  ` \       '
echo '    (="~-_,--/        ,       ,!,___--. \  \_)      '
echo '   (-/~(     |         \   ,_-         | ) /_|      '
echo '   (~/((\    )\._,      |-´         _,/ /           '
echo '    \\))))  /   ./~.    |           \_\;            '
echo ' ,__/////  /   /    )  /                            '
echo '  "===~"   |  |    (, <.                            ' 
echo '           / /       \. \                           '
echo '         _/ /          \_\                          '
echo '        /_!/            >_\                         ' 
echo '. . . . . . . . . . . . . . . . . . . . . . . . . . '

mv progress progress_init
