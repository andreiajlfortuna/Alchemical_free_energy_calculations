import os
import pandas as pd
from sklearn.metrics import mean_absolute_error
from scipy.stats import pearsonr, kendalltau, spearmanr

# Define method and halogen list
method = 'EP1'
halogens = ['iodo', 'bromo', 'chloro']

# Loop over halogens to process results
for halogen in halogens:
    # File paths
    result_file = f"RESULTS_{halogen}_{method}"
    mae_result_file = f"MAE_RESULTS_{halogen}_{method}"

    # Read MAE_RESULTS and exclude the last line, remove '#' symbols
    with open(mae_result_file, 'r') as f_in, open(result_file, 'w') as f_out:
        lines = f_in.readlines()[:-1]  # Exclude last line
        for line in lines:
            f_out.write(line.replace('#', ''))

# Process correlations
correlation_results = []
for halogen in halogens:
    result_file = f"RESULTS_{halogen}_{method}"
    
    # Read the results file into a pandas DataFrame
    df = pd.read_csv(result_file, sep='\s+')

    # Ensure the columns exist
    if 'EXP_V' not in df.columns or 'rep_mean' not in df.columns:
        print(f"Missing columns in {result_file}. Skipping...")
        continue
    
    # Calculate MAE, Pearson, Kendall, and Spearman correlations
    y = df['EXP_V']
    X = df['rep_mean']

    mae = mean_absolute_error(y, X)
    pearson_corr, _ = pearsonr(y, X)
    kendall_corr, _ = kendalltau(y, X)
    spearman_corr, _ = spearmanr(y, X)

    # Store the results
    correlation_results.append({
        'halogen': halogen,
        'MAE': mae,
        'Pearson': pearson_corr,
        'Kendall': kendall_corr,
        'Spearman': spearman_corr
    })

# Write the correlation results to a file
correlation_file = f'CORRELATIONS_{method}'
with open(correlation_file, 'w') as f_out:
    for result in correlation_results:
        f_out.write(f"   {result['halogen']}\n")
        f_out.write(f"MAE       {result['MAE']}\n")
        f_out.write(f"Pearson   {result['Pearson']}\n")
        f_out.write(f"Kendall   {result['Kendall']}\n")
        f_out.write(f"Spearman  {result['Spearman']}\n")
        f_out.write("\n")

# Print a message when done
print(f"Correlation results saved to {correlation_file}")
