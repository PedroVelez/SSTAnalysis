#!/bin/bash

Verbose=0
SoloSube=1 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=$HOME/Dropbox/Oceanografia/Proyectos/PaginaWebSST
DirLog=$HOME/Dropbox/Oceanografia/Proyectos/PaginaWebSST/Log
MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab


/bin/rm -f $DirLog/*.log

printf ">>>> Updating PaginaWeb SSTs \n"
printf "  Verbose $Verbose SoloSube $SoloSube \n"
printf "  DirLog      $DirLog \n"

/bin/rm -f $DirLog/*.log

#------------------------------------
#Actualiza datos SST
#------------------------------------
if [ $SoloSube == 0 ]
then
  printf "Updating SST data\n"
  if [ $Verbose -eq 1 ]
  then
    $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;A10ActualizaDataNoaaOisstV2Highres;exit'
  else
    $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;A01ActualizaDataNoaaOisstV2Highres;exit' >> $DirLog/ActualizaGraficosData.log
  fi
fi

#------------------------------------
# Actualizo la base datos de SST en las estaciones Raprocan
#------------------------------------
printf "Updating SSTNorte\n"
if [ $Verbose == 1 ]
then
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;A20CreaSSTNorteTenerife;exit'
else
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;A20CreaSSTNorteTenerife;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi
printf "Updating SSTRa\n"
if [ $Verbose == 1 ]
then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A20CreaSSTNorteTenerife;exit'
else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A20CreaSSTNorteTenerife;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi

#------------------------------------
# Anual and Ciclo estacional y Hovmoller plots
#------------------------------------
printf "Updating seasonal cycle\n"
if [ $Verbose == 1 ]
then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A40GraficosSST_Anual;exit'
else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A40GraficosSST_Anual;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi
printf "Updating hovmoller plotsa\n"
if [ $Verbose == 1 ]
then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A50GraficosSST;exit'
else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A50GraficosSST;exit' >> $DirLog/ActualizaPaginaWebSSSTNorte.log
fi
