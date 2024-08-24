

**01_prepare_systems.sh** 


- Modifies the GMX topology files when EPs are present;

*This script requires that you have a file with the name or codes for each compound. In this example, I have a file (system.dat) with the code, name, experimental value and calculated value (AM1-BCC charges), from FreeSolv database (10.1007/s10822-014-9747-x).
*You need to have ${sys}-RESP.${dEP}.top and ${sys}-RESP.${dEP}.crd
*This script is adapted to include extra points (EP) to describe the halogen anisotropy. If you are interested in knowing more about it, check this paper: 10.1021/acs.jcim.3c01561

- Creates box (editconf, GROMACS) and adds water molecules (solvate, GROMACS);

*In this example, I used a procedure from Mobley and co-workers (see paper: 10.1021/acs.jced.7b00104), since I wanted to compare the performance of several charge models and therefore, I was interested in using the same number of water molecules. However, you can change the number of water molecules if you want.

- Creates an index file;

- Prepares the setup (creates folders, copies required files to run simulations, etc);

*You need to have the mdp files, run_init.sh, run_init.dat, slurm_MD.dat, slurm_MD.sh (the .sh files send jobs to the cluster. You can run the simulations locally, you just have to adapt the code).

**02_run_init_all.sh** 

- Sends jobs to cluster to run minimization and initialization. In the initialization phase, 3 replicates are going to be considered per lambda point (20 lambda points). Therefore, we have 3 x 20 simulations per compound (in this example, I have the smallest dataset that I studied in this work, just 12 compounds, in total: 720. For the chlorinated compounds I had 103 molecules! That's a lot of jobs as you can imagine!).

*This script has a while loop that only submits jobs till a certain value (in this example, 100). This script is designed to be colleague-friendly, as it prevents the submission of an excessive number of jobs, thereby avoiding congestion in the queue and ensuring that others don’t have to wait long for their tasks to be completed. This is even more important for the production phase, where your simulations can take more time (of course, it depends if you are running the jobs in CPU or GPU, but still, don't be a bad colleague!).


**03_check_progress_init.sh**

- There can be cases where you have a lot of jobs running and it would be nice to check the progress of your simulations. This script does that by checking the npt2.tpr files in each folder (compound, lambda point, replicate). The best part of this script is that it prints a pegasus!!! Of course, you can change this, but I think it really makes a difference!

**04_prod_all.sh**

- Similarly to 02_run_init_all.sh, this script sends jobs to the cluster to run the production phase. 


**05_check_progress_prod.sh**

- Similarly to 03_check_progress_init.sh, this script checks the progress of your simulations by checking if the 001.xtc file exists. You can customize this, but don't forget to print a magical creature :)

**06_analysis**

- 
 
