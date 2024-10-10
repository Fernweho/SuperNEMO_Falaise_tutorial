#!/bin/bash
#source ${THRONG_DIR}/config/supernemo_profile.bash
#export G4LEDATA=/sps/nemo/sw/BxCppDev/opt/g4datasets-9.6.4/share/Geant4Datasets-9.6.4/data/G4EMLOW6.32

echo "Choose the isotope: "
echo "Se82_0nubb, Se82_2nubb, Bi214 or Tl208"
read ISO

echo "Number of events to simulate?: "
read NUMEV

DATA_FOLDER=/sps/nemo/scratch/ktrofimi/Attempt/data_folder
ISO_FOLDER=/sps/nemo/scratch/ktrofimi/Attempt/Isotopes_configurations
MAIN_FOLDER=/sps/nemo/scratch/ktrofimi/Attempt
SENSITIVITY_MODULE=/sps/nemo/scratch/ktrofimi/Falaise_tutorial/SensitivityModule
FAL=/sps/nemo/sw/snsw/2024/opt/falaise-5.1.2/bin

echo "	"
cd $DATA_FOLDER
ls	
echo "	"

echo "Choose the name of simulation folder:"
read USER_FOLDNAME
echo "					   "
echo "Choose number of files:"
read FILES
echo "	"

if [ ! -d "$DATA_FOLDER/$USER_FOLDNAME" ] 
then
    mkdir -p $DATA_FOLDER/$USER_FOLDNAME
else
    echo "Warning: Simulation name already exists. Using previously used configuration files."
    echo "											 "
fi

cd $DATA_FOLDER/$USER_FOLDNAME
ls
echo "	"
    
echo 	"Sending request for Run $USER_FOLDNAME!"
echo    "==========================="

sed 	    -e "s|%ISO|$ISO|g" \
            -e "s|%USER_FOLDNAME|$USER_FOLDNAME|g" \
            -e "s|%MAIN_FOLDER|$MAIN_FOLDER|g" \
            -e "s|%DATA_FOLDER|$DATA_FOLDER|g" \
            -e "s|%SENSITIVITY_MODULE|$SENSITIVITY_MODULE|g" \
            $MAIN_FOLDER/Analyze.sh > $MAIN_FOLDER/Analyze.sh

for (( f=0; f < $FILES; f++  )) # iterate over number of files 
do
    if [ ! -d "$DATA_FOLDER/$USER_FOLDNAME/$f/" ]  # create unique folder 
    then

        mkdir 	$DATA_FOLDER/$USER_FOLDNAME/$f/
        cp $MAIN_FOLDER/analyze.cpp $DATA_FOLDER/$USER_FOLDNAME/$f/
        cp $MAIN_FOLDER/run.sh $DATA_FOLDER/$USER_FOLDNAME/$f/

        sed 		-e "s|%ISO|$ISO|" \
                    -e "s|%NUMEV|$NUMEV|" \
                    -e "s|%USER_FOLDNAME|$USER_FOLDNAME|g" \
                    -e "s|%MAIN_FOLDER|$MAIN_FOLDER|g" \
                    -e "s|%DATA_FOLDER|$DATA_FOLDER|g" \
                    -e "s|%f|$f|g" \
                    $MAIN_FOLDER/simu.conf > $DATA_FOLDER/$USER_FOLDNAME/$f/simu_${ISO}.conf

        sed 	    -e "s|%f|$f|g" \
                    -e "s|%ISO|$ISO|g" \
                    -e "s|%FAL|$FAL|g" \
                    -e "s|%SOURCE|$SOURCE|g" \
                    -e "s|%USER_FOLDNAME|$USER_FOLDNAME|g" \
                    -e "s|%MAIN_FOLDER|$MAIN_FOLDER|g" \
                    -e "s|%DATA_FOLDER|$DATA_FOLDER|g" \
                    -e "s|%SENSITIVITY_MODULE|$SENSITIVITY_MODULE|g" \
                    $MAIN_FOLDER/run.sh > $DATA_FOLDER/$USER_FOLDNAME/$f/run.sh 

        chmod 755 $DATA_FOLDER/$USER_FOLDNAME/$f/run.sh

        sbatch -o $DATA_FOLDER/$USER_FOLDNAME/$f/OUT_${f}.log -e $DATA_FOLDER/$USER_FOLDNAME/$f/ERR_${f}.log $DATA_FOLDER/$USER_FOLDNAME/$f/run.sh

    fi
done
		
###