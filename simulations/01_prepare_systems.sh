
grom=/gromacs/gromacs-2020.6-GPU/bin/gmx
export AMBERHOME=/home/pjcosta/bin/amber/amber16

rm run_init_systems.dat
rm slurm_systems.dat

mobley_path="/home/afortuna/explicit_solvation/02_sim/02_compare_systems/gromacs_solvated"

for sys in $(awk '{print $1}' systems.dat)

do 

dEP=2.15

mkdir ${sys}
 
cd ${sys}

cp ../initialfiles/${sys}-RESP.${dEP}.top .
cp ../initialfiles/${sys}-RESP.${dEP}.crd .

sed -i 's/LIG/MOL/' ${sys}-RESP.${dEP}.top

cp /home/pjcosta/bin/acpype.py . 

python3 acpype.py -p ${sys}-RESP.${dEP}.top -x ${sys}-RESP.${dEP}.crd

mv MOL_GMX.gro ${sys}.gro
mv MOL_GMX.top ${sys}.top

cp ${sys}.top ${sys}_GMX.top.bak

#######################################################
# Modifies the GMX topology files when EPs are present
#######################################################


#######################################################
# Remove bonds, angles, dihedrals for EPs
#######################################################
sed -i '/ - EP/d;/EP-/d;/-    EP/d;/EP -/d' ${sys}.top

########################################################
# In GMX, EPs are represented as virtual sites
# Add virtual site for each halogen
#########################################################

# Identifies the halogens

for halogen in `sed -n -r '/bonds/,/^\s*$/p' ${sys}_GMX.top.bak | grep EP | awk '{print $1}'`
do

nC=`sed -n -r '/bonds/,/^\s*$/p' ${sys}.top | awk -v halogen=$halogen '{if ($1 == halogen) print $2; else if ($2 == halogen) print $1}'`
nEP=`sed -n -r '/bonds/,/^\s*$/p' ${sys}_GMX.top.bak | grep EP | awk -v halogen=$halogen '{if ($1 == halogen) print $2; else if ($2 == halogen) print $1}'`
Cdist=`sed -n -r '/bonds/,/^\s*$/p' ${sys}.top | awk -v halogen=$halogen '{if ($1 == halogen || $2 == halogen) print $4}'`
epdist=`awk -v xep=${dEP} 'BEGIN {print -xep/10}'`

echo ${nEP} ${halogen} ${nC} 2 ${epdist} >>  VSITE.${lig}
done 

sed -i '1 i\[ virtual_sites2 ]' VSITE.${lig}
sed -i '1 i\ ' VSITE.${lig}

sed -i "/qtot 0.000/r VSITE.${lig}" ${sys}.top
sed -i "/qtot -0.000/r VSITE.${lig}" ${sys}.top
rm -rf VSITE.${lig}
rm -rf em.mdp md.mdp

wat_mobley=`tail -n1 $mobley_path/$sys.top | awk '{print $2}'`
# create box
$grom editconf -f ${sys}.gro -o ${sys}_box.gro -c -d 1.5 -bt cubic
# add water molecules
$grom solvate -cp ${sys}_box.gro -cs spc216.gro -maxsol $wat_mobley -o ${sys}_solv.gro -p ${sys}.top 

sed -i '3,5d' ${sys}.top 
sed -i '2 a #include "amber99sb-ildn.ff/forcefield.itp"' ${sys}.top

sed -i '/^\[ system \]/i #include "amber99sb-ildn.ff/tip3p.itp"\n' ${sys}.top

mv ${sys}.gro ${sys}.original.gro
mv ${sys}_solv.gro ${sys}.gro


#create index file:
${grom} make_ndx -f ${sys}.gro -o index.ndx<<EOF
0
q
EOF

cp ../../01_systembuild .

cp ../*.mdp .

./01_systembuild

cp ../run_init.* .

sed -i "s/ZZZZ/$sys/g" run_init.dat

cp ../slurm_MD.* .

sed -i "s/ZZZZ/$sys/g" slurm_MD.dat

tot_lambdas=20

for n_lambda in $(seq 1 1 $tot_lambdas)
do

cp run_init.sh lambda_${n_lambda}/.

cp run_init.dat lambda_${n_lambda}/.

sed -i "s/XXXX/$n_lambda/g" lambda_${n_lambda}/run_init.dat


echo $sys/lambda_$n_lambda >> ../run_init_systems.dat

tot_rep=5

for rep in $(seq 1 1 $tot_rep)

do

cp slurm_MD.sh lambda_${n_lambda}/03_prod_r${rep}/.

cp slurm_MD.dat lambda_${n_lambda}/03_prod_r${rep}/.

sed -i "s/XXXX/$n_lambda/g" lambda_${n_lambda}/03_prod_r${rep}/slurm_MD.dat

sed -i "s/YYYY/$rep/g" lambda_${n_lambda}/03_prod_r${rep}/slurm_MD.dat


echo $sys/lambda_$n_lambda/03_prod_r${rep} >> ../slurm_systems.dat

done

done

cd ../
done
