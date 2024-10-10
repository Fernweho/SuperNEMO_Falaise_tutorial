#!/bin/sh

# SLURM options:

#SBATCH --job-name=Tl208_1         	 # Job name
#SBATCH --partition=htc                  # Partition choice (most generally we work with htc, but for quick debugging you can use
										 #					 #SBATCH --partition=flash. This avoids waiting times, but is limited to 1hr)
#SBATCH --mem=16G                     	 # RAM
#SBATCH --licenses=sps                   # When working on sps, must declare license!!

#SBATCH --output=/dev/null    # Redirect stdout to /dev/null
#SBATCH --error=/dev/null     # Redirect stderr to /dev/null

#SBATCH --chdir=$TMPDIR
#SBATCH --time=4-0                 	 # Time for the job in format “minutes:seconds” or  “hours:minutes:seconds”, “days-hours”
#SBATCH --cpus-per-task=1                # Number of CPUs

echo "================================="
echo "run_script started:"
start=`date +%s`

echo "Working in directory: "
pwd
echo "================================="
echo "STARTING simulation!"

flsimulate -c /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/simu_Tl208_1.conf -o /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/simu_Tl208_1.brio
flreconstruct -i /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/simu_Tl208_1.brio -p /sps/nemo/sw/Falaise/install_develop/share//Falaise-4.1.0/resources/snemo/demonstrator/reconstruction/official-2.0.0.conf -o /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/reco_Tl208_1.brio
flreconstruct -i /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/reco_Tl208_1.brio -p /sps/nemo/scratch/ktrofimi/Falaise_tutorial/SensitivityModule/build/SensitivityModuleExample.conf
mv sensitivity.root /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/sensitivity.root

echo "================================="
echo "FINISHED simulation, STARTING analysis!"

root /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/analyze.cpp

rm /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/simu_Tl208_1.brio
rm /sps/nemo/scratch/ktrofimi/Attempt/data_folder/whaa/9/reco_Tl208_1.brio