import os
import numpy as np
import pandas as pd

# Define method and halogens
method = 'EP1'
halogens = ['iodo', 'bromo', 'chloro']

# Part 1: Process DIFF_vs_exp files
for halogen in halogens:
    # File path
    diff_file = f"DIFF_vs_exp_{halogen}_{method}"
    hist_file = f"hist_{halogen}_{method}"

    # Read the data from the file
    try:
        data = pd.read_csv(diff_file, delim_whitespace=True, usecols=[1], header=None)
    except FileNotFoundError:
        print(f"File not found: {diff_file}. Skipping...")
        continue
    
    # Generate histogram with bins of 0.5 from -20 to 20
    counts, bin_edges = np.histogram(data[1], bins=np.arange(-20, 20.5, 0.5))
    bin_centers = (bin_edges[:-1] + bin_edges[1:]) / 2  # Calculate bin centers

    # Save histogram to file
    hist_data = pd.DataFrame({"bin": bin_centers, "count": counts})
    hist_data.to_csv(hist_file, sep=' ', index=False, header=False)

    # Normalize histogram
    total = hist_data['count'].sum()
    hist_data['normalized'] = hist_data['count'] / total

    # Save normalized data back to the same file
    hist_data[['bin', 'normalized']].to_csv(hist_file, sep=' ', index=False, header=False)

# Part 2: Process EP and X charge files
for halogen in halogens:
    # Define file paths
    ep_charge_file = f"{halogen}_EP_charges.dat"
    x_charge_file = f"{halogen}_X_charges.dat"
    ep_hist_file = f"hist_EP_{halogen}_charge"
    x_hist_file = f"hist_{halogen}_charge"

    # Process EP charge file
    try:
        ep_data = pd.read_csv(ep_charge_file, delim_whitespace=True, usecols=[1], header=None)
    except FileNotFoundError:
        print(f"File not found: {ep_charge_file}. Skipping...")
        continue

    # Generate histogram for EP charges with bins of 0.01 from 0.01 to 0.8
    ep_counts, ep_bin_edges = np.histogram(ep_data[1], bins=np.arange(0.01, 0.81, 0.01))
    ep_bin_centers = (ep_bin_edges[:-1] + ep_bin_edges[1:]) / 2

    # Normalize by total entries (count of lines)
    ep_total = len(ep_data)
    ep_hist_data = pd.DataFrame({"bin": ep_bin_centers, "normalized": ep_counts / ep_total})
    ep_hist_data.to_csv(ep_hist_file, sep=' ', index=False, header=False)

    # Process X charge file
    try:
        x_data = pd.read_csv(x_charge_file, delim_whitespace=True, usecols=[1], header=None)
    except FileNotFoundError:
        print(f"File not found: {x_charge_file}. Skipping...")
        continue

    # Generate histogram for X charges with bins of 0.05 from -0.8 to 0.1
    x_counts, x_bin_edges = np.histogram(x_data[1], bins=np.arange(-0.8, 0.15, 0.05))
    x_bin_centers = (x_bin_edges[:-1] + x_bin_edges[1:]) / 2

    # Normalize by total entries (count of lines)
    x_total = len(x_data)
    x_hist_data = pd.DataFrame({"bin": x_bin_centers, "normalized": x_counts / x_total})
    x_hist_data.to_csv(x_hist_file, sep=' ', index=False, header=False)

print("Processing complete.")
