# 🔮 Alchemical Free Energy Calculations

This repository contains **scripts and tools** for running **alchemical free energy calculations** with **Extra Points (EPs)** to describe **halogen anisotropy**.   
If you're interested in learning more about EPs, check out this paper:  
📄 [DOI: 10.1021/acs.jcim.3c01561](https://doi.org/10.1021/acs.jcim.3c01561)  

---

## 📂 Project Structure

### 📁 **Simulation Folder**
This folder contains the following key scripts:  

### ⚙️ **01_prepare_systems.sh**  
🔹 **Modifies GROMACS topology files** when **EPs** are present.  

#### ⚠️ *Requirements:*  
- A file containing **compound names or codes** (e.g., `system.dat`).  
- The following files: `${sys}-RESP.${dEP}.top` and `${sys}-RESP.${dEP}.crd`.  
- **Molecular dynamics parameter files (MDPs)** and job submission scripts (`run_init.sh`, `run_init.dat`, `slurm_MD.dat`, `slurm_MD.sh`) if running on a cluster.  

#### 🔹 **Prepares the system:**  
- Defines the simulation **box** (via `editconf`, **GROMACS**).  
- **Solvates** the system (via `solvate`, **GROMACS**).  
- Creates an **index file**.  
- Sets up folders & copies necessary files.  

💡 *Water Molecules:*  
This setup follows a method from Mobley & co-workers ([DOI: 10.1021/acs.jced.7b00104](https://doi.org/10.1021/acs.jced.7b00104)).  
However, you can modify it based on your needs.  

---

### 🚀 **02_run_init_all.sh**  
🔹 Submits jobs to the **cluster** to run:  
- **Minimization**   
- **Initialization** (3 replicates per lambda point, with **20 lambda points**)  

#### 📊 *Total simulations:*  
 📌 *12 compounds → 720 simulations!*  
 📌 *For chlorinated compounds → 103 molecules!* 🚀 *(Over 6000 simulations!)*  

#### ⚠️ **Important:**  
- The script contains a **while loop** to prevent excessive job submissions (**default max = 100**).  
- This prevents **queue congestion** and ensures a fair share of computing resources.  

---

### 📊 **03_check_progress_init.sh**  
🔹 **Monitors progress** of running jobs by checking `npt2.tpr` files.  
🦄 **Bonus:** This script prints a **Pegasus!** ✨)  

---

### 🚀 **04_prod_all.sh**  
🔹 Submits jobs for **production runs**, similar to the **initialization script**.  

---

### 📊 **05_check_progress_prod.sh**  
🔹 **Monitors production phase** progress by checking if `001.xtc` files exist.  
🦄 *Reminder:* Don't forget to **print a magical creature** in the output!   

---

### 📊 **06_analysis**  
🔹 **(To be detailed further)**  

---

## 📌 Notes  
- You can **run simulations locally**, but job submission scripts (`.sh`) are designed for **cluster environments**. Modify as needed!  
- Ensure dependencies are correctly installed before running the scripts.  

---


