#!/bin/bash

Verbose=0

DirLog=$HOME/Dropbox/Oceanografia/Data/Satelite/noaa.oisst.v2.highres
MatlabPath=/Applications/MATLAB_R2019b.app/bin

#Delete log
/bin/rm -f $DirLog/*.log

#------------------------------------
#Actualiza datos
#------------------------------------
if [ $Verbose -eq 1 ]
then
  $MatlabPath/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Data/Satelite/noaa.oisst.v2.highres;ActualizaDataNoaaOisstV2Highres;exit'
else
  $MatlabPath/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Data/Satelite/noaa.oisst.v2.highres;ActualizaDataNoaaOisstV2Highres;exit' >> $DirLog/ActualizaDataNoaaOisstV2Highres.log
fi
