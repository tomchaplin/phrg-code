#!/bin/bash
FLAGSER_GIT="https://github.com/luetge/flagser.git"
PPH_\hIT="https://github.com/SteveHuntsmanBAESystems/PerformantPathHomology.git"
# Check pre-reqs
if ! command -v cmake &> /dev/null
then
  echo "Please install cmake"
  exit
fi
if ! command -v make &> /dev/null
then
  echo "Please install make"
  exit
fi
# Setup directories
mkdir -p lib
# Download git repos
git clone $FLAGSER_GIT lib/flagser
git clone $PPH_GIT lib/pathhomology
# Build flagser
cd lib/flagser
(mkdir -p build && cd build && cmake .. && make -k)
