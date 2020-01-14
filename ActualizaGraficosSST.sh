#!/bin/bash

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

DirFigure=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST/Figures
DirLog=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST/Log
DirLocalWeb=/Users/pvb/Dropbox/Particular/DisenoGrafico/PaginaWeb/pedro/images

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
    /Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Data/Satelite/noaa.oisst.v2.highres;ActualizaDataNoaaOisstV2Highres;exit'
  else
    /Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Data/Satelite/noaa.oisst.v2.highres;ActualizaDataNoaaOisstV2Highres;exit' >> $DirLog/ActualizaDataNoaaOisstV2Highres.log
  fi
fi

#------------------------------------
# Update the figures (png)
#------------------------------------
if [ $SoloSube == 0 ]
then
printf "Updating the figures\n"
  if [ $Verbose == 1 ]
  then
  /Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A10ActualizaGraficosSST;exit'
  else
  /Applications/MATLAB_R2019b.app/bin/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;A10ActualizaGraficosSST;exit' >> $DirLog/ActualizaGraficosSST_matlab.log
  fi
fi
