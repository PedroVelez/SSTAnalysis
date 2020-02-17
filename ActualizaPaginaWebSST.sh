#!/bin/bash

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=$HOME/Dropbox/Oceanografia/Proyectos/PaginaWebSST
DirLog=$PaginaWebDir/Log

strval=$(uname -a)
if [[ $strval == *Okapi* ]];
then
  MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab
fi
if [[ $strval == *vibrio* ]];
then
  MatVersion=matlab
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
  printf "Updating SST data\n"
  if [ $Verbose -eq 1 ]
  then
    cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A10ActualizaDataNoaaOisstV2Highres;exit'
  else
    cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A10ActualizaDataNoaaOisstV2Highres;exit' >> $DirLog/ActualizaGraficosData.log
  fi
fi

#------------------------------------
# Actualizo la base datos de SST en las estaciones Raprocan
#------------------------------------
printf "Updating SSTNorte\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A20CreaSSTNorteTenerife;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A20CreaSSTNorteTenerife;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi
printf "Updating SSTRa\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A20CreaSSTNorteTenerife;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A20CreaSSTNorteTenerife;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi

#------------------------------------
# Anual and Ciclo estacional y Hovmoller plots
#------------------------------------
printf "Updating seasonal cycle\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A40GraficosSST_Anual;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A40GraficosSST_Anual;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi

cd $PaginaWebDir; printf "Updating hovmoller plotsa\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'A50GraficosSST;exit'
else
  cd $PaginaWebDir;  $MatVersion -nodisplay -nosplash -r 'A50GraficosSST;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi
