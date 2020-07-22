#!/bin/bash

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=$HOME/Dropbox/Oceanografia/Proyectos/SSTWebpage
DirLog=$PaginaWebDir/log


strval=$(uname -a)
if [[ $strval == *Okapi* ]];
then
  MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab
fi
if [[ $strval == *vibrio* ]];
then
  MatVersion=/home/pvb/Matlab/Matlab2019b/bin/matlab
fi

#------------------------------------
#Inicio
#------------------------------------

/bin/rm -f $DirLog/*.log

printf ">>>> Updating PaginaWeb SSTs \n"
printf "  Verbose $Verbose SoloSube $SoloSube \n"
printf "  PaginaWebDir $PaginaWebDir \n"
printf "  DirLog       $DirLog \n"


#------------------------------------
#Actualiza datos SST
#------------------------------------
if [ $SoloSube == 0 ]
then
  printf "Updating SST dataset for the region\n"
  if [ $Verbose -eq 1 ]
  then
    cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'updateNoaaOisstV2HighresData;exit'
  else
    cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'updateNoaaOisstV2HighresData;exit' > $DirLog/updateNoaaOisstV2HighresData.log
  fi
fi

#------------------------------------
# Actualizo la base datos de SST en las estaciones Raprocan
#------------------------------------
printf "Updating SSTNorte\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTNorteTenerife;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTNorteTenerife;exit' > $DirLog/createSSTNorteTenerife.log
fi
printf "Updating SSTRaprocan\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTRaprocan;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTRaprocan;exit' > $DirLog/createSSTRaprocan.log
fi

#------------------------------------
# Anual and Ciclo estacional y Hovmoller plots
#------------------------------------
printf "Updating seasonal cycle\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures_yearly;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures_yearly;exit' > $DirLog/createSSTfigures_yearly.log
fi

printf "Updating hovmoller plotsa\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures;exit' > $DirLog/createSSTfigures.log
fi

printf "Updating reports\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createReport;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createReport;exit' > $DirLog/createReport.log
fi


#------------------------------------
# i TelegramBot
#------------------------------------
URL="https://api.telegram.org/bot$ArgoEsBotTOKEN/sendMessage"
MENSAJE=`cat $HOME/Dropbox/Oceanografia/Proyectos/SSTWebpage/data/report.txt`
curl -s -X POST $URL -d chat_id=$ArgoEsBotID -d text="$MENSAJE" -d parse_mode=html
