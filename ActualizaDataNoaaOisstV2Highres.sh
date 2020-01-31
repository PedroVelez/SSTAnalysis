#!/bin/bash

Verbose=0

DirLog=$HOME/Dropbox/Oceanografia/Data/Satelite/noaa.oisst.v2.highres
MatlabPath=/Applications/MATLAB_R2019b.app/bin

#Delete log
/bin/rm -f $DirLog/*.log

#------------------------------------
#Actualiza datos
#------------------------------------
printf "NoaaOisstV2Highres Updating SST data\n"
if [ $Verbose -eq 1 ]
then
  matlab -nodisplay -nosplash -r 'cd $HOME/Dropbox/Oceanografia/Proyectos/PaginaWebSST;ActualizaDataNoaaOisstV2Highres;exit'
else
  matlab -nodisplay -nosplash -r 'cd $HOME/Dropbox/Oceanografia/Proyectos/PaginaWebSST;ActualizaDataNoaaOisstV2Highres;exit' >> $DirLog/ActualizaDataNoaaOisstV2Highres.log
fi
