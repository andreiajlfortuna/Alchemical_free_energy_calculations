import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Replace with the correct path to your files
chloro_hist_file = 'hist_chloro_EP1'
bromo_hist_file = 'hist_bromo_EP1'
iodo_hist_file = 'hist_iodo_EP1'

chloro_corr_file = 'RESULTS_chloro_EP1'
bromo_corr_file = 'RESULTS_bromo_EP1'
iodo_corr_file = 'RESULTS_iodo_EP1'

def create_histogram(file, color, label, ax, xlabel="Difference (kcal mol$^{-1}$)", ylabel="% of molecules"):
    # Read first two columns for plotting without column names
    data = pd.read_csv(file, sep=r'\s+', usecols=[0, 1], header=None)

    # Plot histogram data, with the second column multiplied by 100
    ax.bar(data[0], data[1] * 100, color=color, label=label)
    ax.set_xlabel(xlabel, fontsize=12)
    ax.set_ylabel(ylabel, fontsize=12)
    ax.set_title(label, fontsize=14)
    ax.set_xlim(-10, 10) 

# Create figure for histograms
fig, axes = plt.subplots(1, 3, figsize=(15, 5))

# Plot the histograms for Chlorine, Bromine, and Iodine
create_histogram(chloro_hist_file, '#FF0000', 'Chlorine EP1', axes[0], xlabel=r"$\Delta G_{\text{hyd}}^{\text{calc}} - \Delta G_{\text{hyd}}^{\text{exp}}$ (kcal mol$^{-1}$)")
create_histogram(bromo_hist_file, '#0000FF', 'Bromine EP1', axes[1], xlabel=r"$\Delta G_{\text{hyd}}^{\text{calc}} - \Delta G_{\text{hyd}}^{\text{exp}}$ (kcal mol$^{-1}$)")
create_histogram(iodo_hist_file, '#000000', 'Iodine EP1', axes[2], xlabel=r"$\Delta G_{\text{hyd}}^{\text{calc}} - \Delta G_{\text{hyd}}^{\text{exp}}$ (kcal mol$^{-1}$)")

# Save histogram plot as PNG
plt.tight_layout()
plt.savefig('hists_DIFFs_EP1.png', format='png')

def create_correlation_plot(file, color, label, ax, xlabel=r"$\Delta G_{\text{hyd}}$ (exp) / kcal mol$^{-1}$", ylabel=r"$\Delta G_{\text{hyd}}$ (calc) / kcal mol$^{-1}$"):
    # Load only the third and fourth columns for correlation plotting
    data = pd.read_csv(file, sep=r'\s+', usecols=[2, 3], header=None, skiprows=1)

    # Scatter plot of experimental vs. calculated values
    ax.scatter(data[2], data[3], color=color, label=label)
    
    # Plot y=x line for reference
    min_val = min(data[2].min(), data[3].min())
    max_val = max(data[2].max(), data[3].max())
    ax.plot([min_val, max_val], [min_val, max_val], color='black', linestyle='--', linewidth=1)

    # Set plot limits, labels, and title
    ax.set_xlim(-20, 5)
    ax.set_ylim(-20, 5)
    ax.set_xlabel(xlabel, fontsize=14)
    ax.set_ylabel(ylabel, fontsize=14)
    ax.set_title(label, fontsize=16)

# Create figure for correlation plots
fig, axes = plt.subplots(1, 3, figsize=(15, 5))

# Plot the correlations for Chlorine, Bromine, and Iodine
create_correlation_plot(chloro_corr_file, '#FF0000', 'Chlorine EP1', axes[0], xlabel=r'$\Delta G_{\text{hyd}}$ (exp) / kcal mol$^{-1}$', ylabel=r'$\Delta G_{\text{hyd}}$ (calc) / kcal mol$^{-1}$')
create_correlation_plot(bromo_corr_file, '#0000FF', 'Bromine EP1', axes[1], xlabel=r'$\Delta G_{\text{hyd}}$ (exp) / kcal mol$^{-1}$', ylabel=r'$\Delta G_{\text{hyd}}$ (calc) / kcal mol$^{-1}$')
create_correlation_plot(iodo_corr_file, '#000000', 'Iodine EP1', axes[2], xlabel=r'$\Delta G_{\text{hyd}}$ (exp) / kcal mol$^{-1}$', ylabel=r'$\Delta G_{\text{hyd}}$ (calc) / kcal mol$^{-1}$')

# Save correlation plot as PNG
plt.tight_layout()
plt.savefig('correlations_EP1.png', format='png')

plt.show()
