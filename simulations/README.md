

**01_prepare_system.sh** 


- Modifies the GMX topology files when EPs are present;

*This script requires that you have a file with the name or codes for each compound. In this example, I have a file (system.dat) with the code, name, experimental value and calculated value (AM1-BCC charges), from FreeSolv database (10.1007/s10822-014-9747-x).
*You need to have ${sys}-RESP.${dEP}.top and ${sys}-RESP.${dEP}.crd
*This script is adapted to include extra points (EP) to describe the halogen anisotropy. If you are interested in knowing more about it, check this paper: 10.1021/acs.jcim.3c01561

- Creates box (editconf, GROMACS) and adds water molecules (solvate, GROMACS);

*In this example, I used a procedure from Mobley and co-workers (see paper: 10.1021/acs.jced.7b00104), since I wanted to compare the performance of several charge models and therefore, I was interested in using the same number of water molecules. However, you can change the number of water molecules if you want.

- Creates an index file;

- Prepares the setup (creates folders, copies required files to run simulations, etc);

*You need to have the mdp files, run_init.sh, run_init.dat, slurm_MD.dat, slurm_MD.sh (the .sh files send jobs to the cluster. You can run the simulations locally, you just have to adapt the code).
