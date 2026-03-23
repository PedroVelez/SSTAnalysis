#!/bin/bash

Verbose=1
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=$HOME/Proyectos/SSTAnalysis
DirLog=$PaginaWebDir/log


strval=$(uname -a)
if [[ $strval == *Okapi* ]];
then
  MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab
fi
if [[ $strval == *rossby* ]];
then
  MatVersion=/usr/bin/matlab
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
printf "Updating SST\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTData;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTData;exit' > $DirLog/createSSTNorteTenerife.log
fi


#if [ $Verbose == 1 ]
#then
#  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTNorteTenerife;exit'
#else
#  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTNorteTenerife;exit' > $DirLog/createSSTNorteTenerife.log
#fi
#printf "Updating SSTRaprocan\n"
#if [ $Verbose == 1 ]
#then
#  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTRaprocan;exit'
#else
#  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTRaprocan;exit' > $DirLog/createSSTRaprocan.log
#fi

#------------------------------------
# Anual and Ciclo estacional y Hovmoller plots
#------------------------------------
printf "Updating seasonal cycle\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures01;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures01;exit' > $DirLog/createSSTfigures01.log
fi

printf "Updating hovmoller plotsa\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures02;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures02;exit' > $DirLog/createSSTfigures02.log
fi


#------------------------------------
# Update map
#------------------------------------
printf "Updating map\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createMapaLLet;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createMapaLLet;exit' > $DirLog/createMapaLLet.log
fi


#------------------------------------
# Update reports
#------------------------------------
printf "Updating reports\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createReport;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createReport;exit' > $DirLog/createReport.log
fi
