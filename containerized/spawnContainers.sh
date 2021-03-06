#!/bin/bash

# Matthew Lee
# Fall 2019
# JagResearch
# MultiMutant
# Spawns docker containers - requires superuser
# Dockerfile should be in same folder as this script

# SCRIPT ARGS:
# pdbID
# chainID
# resNumRange (X:Y)(inclusive)
# optional - energy minimization

# amino acids
declare -a amAcids=("A" "R" "N" "D" "C" "Q" "E" "G" "H" "I" "L" "K"
					"M" "F" "P" "S" "T" "W" "Y" "V")

# starts a docker container that runs rMutant with the given arguments
# ARGS: pdbID chainID resNum mutTarget (optional)energyMinimization
# TODO: make an arg for the image name
runMutant () {
    sudo docker run -d multimutanttest $1 $2 $3 $4 $5
}


#calls runMutant for each amino acid type
# ARGS: pdbID chainID resNum (optional)energyMinimization
allTargets() {
     for j in "${amAcids[@]}"
     do
        runMutant $1 $2 $3 $j $4
     done
}

#finding range of residues to mutate
beginning=${3%:*}
end=${3#*:}

#download specified protein pdb file from rcsb
wget -q -O "${1}.pdb" "https://files.rcsb.org/download/${1}.pdb"
#move to folder that gets copied to docker container
mv -t "./multiMutant_image/" "${1}.pdb"

#chmod +x ./multiMutant_image/multimut.sh

#building docker image
sudo docker build -t multimutanttest .

#loops over range of residues mutating each into all amino acids
for ((i = $beginning; i <= end; i++));
do
    allTargets $1 $2 $i $4
done
