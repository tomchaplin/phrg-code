# First Betti number of the path homology of random directed graphs - Code and Data Repository

## Requirements and setup
The [PerformantPathHomology](https://github.com/SteveHuntsmanBAESystems/PerformantPathHomology) uses MATLAB's symbolic toolbox and hence both MATLAB and the toolbox are required to run some of the scripts.
In order to run [flagser](https://github.com/luetge/flagser) please ensure that you have `make`, `cmake` and a `C++14` compiler.
Then run the setup script which will download both of these libraries with `git` and build `flagser`:
```
./setup.sh
```

## File structure
```
├── 📁 lib                - External libraries, written by other authors
│   ├── 📁 flagser        - flagser software, for computing homology of directed flag complex
│   └── 📁 pathhomology   - Performant path homology computation
├── 📁 mat                - MATALB .mat files storing the results of experiments + computations
├── 📁 src                - Source MATLAB files for reproducing data + figures
│   ├── 📁 experiments    - Data collection scripts for experiments section
│   ├── 📁 plot           - Script for converting experimental data into plots
│   ├── 📁 util           - Utility functions used in other scripts
│   └── 🗎 compute_Q.m    - Script for computing q_{m,l} matrix in explicit bounds
├── 🗎 README.md          - This file
└── 🗎 setup.sh           - Setup script for importing and building libraries
```
Many of the plotting scripts, as well as `compute_Q.m`, begin with a switch on the `MODE` variable.
The two valid values are `nreg` for non-regular path homology and `dflag` for directed flag complex homology.
This variable should be set prior to running the script.

## Experiments

The `experiments` folder contains all of the scripts which run the experiments described in Appendix B.
The relation between the scripts and the experiment numbers in the paper is shown below.
Each of these experiments outputs its results as `.mat` file in the `mat` directory.

| Experiment Number | Script                       |
|-------------------|------------------------------|
| 1                 | `lower_betti1_check.m`       |
| 2                 | `upper_betti1_check.m`       |
| 3                 | `lower_betti1_dflag_check.m` |
| 4                 | `upper_betti1_dflag_check.m` |

## Plots

* `???_betti1_plot.m` - These scripts take the data from the experiments and return best fits of the boundaries.
* `???_bound_analysis.m` - These scripts produce figures for the purpose of analysing the utility of the explicit bounds, developed in Appendix A.
* `mean_plotter.m` - This script draws the illustrative figures in Appendix B.
* `normal_goodness_2.m` - This script runs the normal distribution goodness-of-fit tests which are discussed in Appendix B.
