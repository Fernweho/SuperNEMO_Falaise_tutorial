#!/bin/sh

# SLURM options:

#SBATCH --job-name=%ISO%SOURCE         	 # Job name
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

flsimulate -c %DATA_FOLDER/%USER_FOLDNAME/%f/simu_%ISO.conf -o %DATA_FOLDER/%USER_FOLDNAME/%f/simu_%ISO.brio
flreconstruct -i %DATA_FOLDER/%USER_FOLDNAME/%f/simu_%ISO.brio -p /sps/nemo/sw/Falaise/install_develop/share//Falaise-4.1.0/resources/snemo/demonstrator/reconstruction/official-2.0.0.conf -o %DATA_FOLDER/%USER_FOLDNAME/%f/reco_%ISO.brio
flreconstruct -i %DATA_FOLDER/%USER_FOLDNAME/%f/reco_%ISO.brio -p %SENSITIVITY_MODULE/build/SensitivityModuleExample.conf

echo "================================="
echo "FINISHED simulation, STARTING analysis!"

root %DATA_FOLDER/%USER_FOLDNAME/%f/analyze.cpp