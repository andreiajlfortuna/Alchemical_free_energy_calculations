import os
import pandas as pd
import numpy as np

# Define method and halogens
method = 'EP1'
halogens = ['iodo', 'bromo', 'chloro']

# Step 1: Create DIFF_vs_exp and outliers files
for halogen in halogens:
    # File paths
    results_file = f"RESULTS_{halogen}_{method}"
    diff_vs_exp_file = f"DIFF_vs_exp_{halogen}_{method}"
    outliers_file = f"outliers_{halogen}_{method}"

    # Check if results file exists
    if not os.path.exists(results_file):
        print(f"File not found: {results_file}. Skipping...")
        continue

    # Read data while skipping the first line (like `tail -n +2`)
    data = pd.read_csv(results_file, sep=r'\s+', skiprows=1, header=None)

    # Create TMP1 with columns 2 and 6, TMP2 with column 3, TMP3 with columns 2 and 7
    TMP1 = data[[1, 5]]  # columns 2 and 6
    TMP2 = data[[2]]     # column 3
    TMP3 = data[[1, 6]]  # columns 2 and 7

    # Combine TMP1 and TMP2 to create DIFF_vs_exp file
    diff_vs_exp = pd.concat([TMP1, TMP2], axis=1)
    diff_vs_exp.to_csv(diff_vs_exp_file, sep=' ', index=False, header=False)

    # Combine TMP3 and TMP2 to create outliers file
    outliers = pd.concat([TMP3, TMP2], axis=1)
    outliers.to_csv(outliers_file, sep=' ', index=False, header=False)

    # Sort the outliers file by the second column
    outliers.sort_values(by=[1], inplace=True)  # sort by column 2 (index 1 in 0-based indexing)
    outliers.to_csv(outliers_file, sep=' ', index=False, header=False)

# Step 2: Process DIFF_vs_exp files for histograms
for halogen in halogens:
    diff_file = f"DIFF_vs_exp_{halogen}_{method}"
    hist_file = f"hist_{halogen}_{method}"

    # Check if diff file exists
    if not os.path.exists(diff_file):
        print(f"File not found: {diff_file}. Skipping...")
        continue

    # Load the second column from DIFF_vs_exp file for histogram analysis
    data = pd.read_csv(diff_file, sep=r'\s+', usecols=[1], header=None)

    # Generate histogram with bins of 0.5 from -20 to 20
    counts, bin_edges = np.histogram(data[1], bins=np.arange(-20, 20.5, 0.5))
    bin_centers = (bin_edges[:-1] + bin_edges[1:]) / 2

    # Save histogram to file
    hist_data = pd.DataFrame({"bin": bin_centers, "count": counts})
    hist_data.to_csv(hist_file, sep=' ', index=False, header=False)

    # Normalize histogram
    total = hist_data['count'].sum()
    hist_data['normalized'] = hist_data['count'] / total

    # Save normalized data back to the same file
    hist_data[['bin', 'normalized']].to_csv(hist_file, sep=' ', index=False, header=False)

# Step 3: Process EP and X charge files for histograms
for halogen in halogens:
    ep_charge_file = f"{halogen}_EP_charges.dat"
    x_charge_file = f"{halogen}_X_charges.dat"
    ep_hist_file = f"hist_EP_{halogen}_charge"
    x_hist_file = f"hist_{halogen}_charge"

    # Process EP charge file
    if os.path.exists(ep_charge_file):
        ep_data = pd.read_csv(ep_charge_file, sep=r'\s+', usecols=[1], header=None)
        
        # Generate histogram for EP charges with bins of 0.01 from 0.01 to 0.8
        ep_counts, ep_bin_edges = np.histogram(ep_data[1], bins=np.arange(0.01, 0.81, 0.01))
        ep_bin_centers = (ep_bin_edges[:-1] + ep_bin_edges[1:]) / 2

        # Normalize by total entries (count of lines)
        ep_total = len(ep_data)
        ep_hist_data = pd.DataFrame({"bin": ep_bin_centers, "normalized": ep_counts / ep_total})
        ep_hist_data.to_csv(ep_hist_file, sep=' ', index=False, header=False)

    # Process X charge file
    if os.path.exists(x_charge_file):
        x_data = pd.read_csv(x_charge_file, sep=r'\s+', usecols=[1], header=None)
        
        # Generate histogram for X charges with bins of 0.05 from -0.8 to 0.1
        x_counts, x_bin_edges = np.histogram(x_data[1], bins=np.arange(-0.8, 0.15, 0.05))
        x_bin_centers = (x_bin_edges[:-1] + x_bin_edges[1:]) / 2

        # Normalize by total entries (count of lines)
        x_total = len(x_data)
        x_hist_data = pd.DataFrame({"bin": x_bin_centers, "normalized": x_counts / x_total})
        x_hist_data.to_csv(x_hist_file, sep=' ', index=False, header=False)

print("Processing complete.")
