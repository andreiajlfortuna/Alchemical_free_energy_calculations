#! /bin/bash -e
#
## Working Dir:
Dir=`pwd`
#
# Source the .dat file that has all the settings
runname=`basename $0`; source ${runname%.*}.dat
#
# Override Partition chosen in case it's a GPU job
#
## Beginning of QEXE file

 


cat <<EOF >$Name.slurm
#! /bin/bash -e
#
#. /etc/profile
#. ~/.bashrc
#. ~/.bash_profile
export EMAIL=$Email
InitDate=\`date\`
#
LocalDir=\`pwd\`
#

############################ MINIMIZATION ###########################

cd 01_min/

## Make the tpr file for min1
${grom} grompp -f ${mdp_min} -po min_out.mdp \
	-c ${gro_min} -r ${gro_min}  -n ${index} -p ${top} \
	-pp TMP_processed.top -o min.tpr -maxwarn 1000

## Run min
${grom} mdrun -nt ${ncpus} -pin auto -s min.tpr -x min.xtc \
	-c min.gro -e min.edr -g min.log \
	-v -nice 0

cd ../
########################### EQUILIBRATION ##############################


tot_rep=5

for rep in \$(seq 1 1 \$tot_rep)

do

cd 02_equil_r\${rep}/

####nvt

${grom} grompp -f ${mdp_eq1} -po nvt_out.mdp \
	-c ${gro_eq1} -r ${gro_eq1} -p ${top} \
	-pp TMP_processed.top -o nvt.tpr -n ${index} -maxwarn 1000

${grom} mdrun -nt ${ncpus} -pin auto -s nvt.tpr -x nvt.xtc \
	-c nvt.gro -e nvt.edr -g nvt.log -v -nice 19

####npt

${grom} grompp -f ${mdp_eq2} -po npt_out.mdp \
	-c ${gro_eq2} -r ${gro_eq2} -p ${top} \
	-pp TMP_processed.top -o npt.tpr -n ${index} -maxwarn 1000

${grom} mdrun -nt ${ncpus} -pin auto -s npt.tpr -x npt.xtc \
	-c npt.gro -e npt.edr -g npt.log -v -nice 19

####npt2
${grom} grompp -f ${mdp_eq3} -po npt2_out.mdp \
	-c ${gro_eq3} -r ${gro_eq3} -p ${top} \
	-pp TMP_processed.top -o npt2.tpr -n ${index} -maxwarn 1000

${grom} mdrun -nt ${ncpus} -pin auto -s npt2.tpr -x npt2.xtc \
	-c npt2.gro -e npt2.edr -g npt2.log -v -nice 19

cd ../

done

EOF

chmod +x $Name.slurm

if [ $requeue == 1 ]
   then 
       sbatch --requeue -p $Partition -N 1 -n $ncpus -o $Name.sout -e $Name.serr $Name.slurm
else
       sbatch -p $Partition -N 1 -n $ncpus -o $Name.sout -e $Name.serr $Name.slurm
fi
echo ""
echo "Job submitted to Partition(s): $Partition with $ncpus Processors"
#
## End of Script
#


