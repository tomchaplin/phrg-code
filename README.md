# First Betti number of the path homology of random directed graphs - Code and Data Repository

## Requirements and setup
The [PerformantPathHomology](https://github.com/SteveHuntsmanBAESystems/PerformantPathHomology) uses MATLAB's symbolic toolbox and hence both MATLAB and the toolbox are required to run some of the scripts.
In order to run [flgaser](https://github.com/luetge/flagser) please ensure that you have `make`, `cmake` and a `C++14` compiler.
Then run the setup script which will download both of these libraries with `git` and build `flagser`:
```
./setup.sh
```

## File structure
```
├── 📁 fig                - Figures present in the paper, saved as MATLAB .fig and .eps
├── 📁 lib                - External libraries, written by other authors
│   ├── 📁 flagser        - flagser software, for computing homology of directed flag complex
│   └── 📁 pathhomology   - Performant path homology computation
├── 📁 mat                - MATALB .mat files storing the results of experiments + computations
├── 📁 src                - Source MATLAB files for reproducing data + figures
│   ├── 📁 bounds         - Scripts for computing q_{m,l} matrix in explicit bounds
│   ├── 📁 experiments    - Data collection scripts for experiments section
│   ├── 📁 plot           - Script for converting experimental data into plots
│   └── 📁 util           - Utility functions used in other scripts
├── 🗎 README.md           - This file
└── 🗎 setup.sh            - Setup script for importing and building libraries
```
