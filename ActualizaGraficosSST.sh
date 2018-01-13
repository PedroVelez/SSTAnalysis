#!/bin/bash

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

DirFigure=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST/Figures
DirLog=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST
DirLocalWeb=/Users/pvb/Dropbox/Particular/DisenoGrafico/PaginaWeb/pedro/images

/bin/rm -f $DirLog/ActualizaGraficosSST_matlab.log

# Update the figures (png)
#------------------------------------
if [ $SoloSube == 0 ]
then
printf "Updating the figures\n"
  if [ $Verbose == 1 ]
  then
  /Applications/MATLAB_R2016b.app/bin/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;ActualizaGraficosSST;exit'
  else
  /Applications/MATLAB_R2016b.app/bin/matlab -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebSST;ActualizaGraficosSST;exit' >> $DirLog/ActualizaGraficosSST_matlab.log
  fi
fi

#------------------------------------
# Rename .pg files
#------------------------------------

if [ $SoloSube == 0 ]
then
  printf "Renaming .png files \n"
  #Raprocan
  /bin/cp $DirFigure/GraficosSSTRaprocan_CicloEstacional_Seccion11_22.png $DirLocalWeb/RGraficosSSTRaprocan_CicloEstacional_Seccion11_22.png
  /bin/cp $DirFigure/GraficosSSTRaprocan_Mensual_Seccion11_22.png $DirLocalWeb/RGraficosSSTRaprocan_Mensual_Seccion11_22.png
  /bin/cp $DirFigure/GraficosSSTRaprocan_Anual_Seccion11_22.png $DirLocalWeb/RGraficosSSTRaprocan_Anual_Seccion11_22.png
  /bin/cp $DirFigure/GraficosSSTRaprocan_HovMollerDiario_Seccion11_22.png $DirLocalWeb/RGraficosSSTRaprocan_HovMollerDiario_Seccion11_22.png

  #Norte Tenerife
  /bin/cp $DirFigure/GraficosSSTNorteTenerife_CicloEstacional_Seccion01_02.png $DirLocalWeb/RGraficosSSTNorteTenerife_CicloEstacional_Seccion01_02.png
  /bin/cp $DirFigure/GraficosSSTNorteTenerife_Mensual_Seccion01_02.png $DirLocalWeb/RGraficosSSTNorteTenerife_Mensual_Seccion01_02.png
  /bin/cp $DirFigure/GraficosSSTNorteTenerife_Anual_Seccion01_02.png $DirLocalWeb/RGraficosSSTNorteTenerife_Anual_Seccion01_02.png
  /bin/cp $DirFigure/GraficosSSTNorteTenerife_HovMollerDiario_Seccion01_02.png $DirLocalWeb/RGraficosSSTNorteTenerife_HovMollerDiario_Seccion01_02.png
fi

#------------------------------------
# Upload png files to the server
#------------------------------------
printf "Upload png files to the server\n"
cd $DirLocalWeb
ncftpput OceanografiaES /html/images RGraficosSSTRaprocan_CicloEstacional_Seccion11_22.png
ncftpput OceanografiaES /html/images RGraficosSSTRaprocan_Mensual_Seccion11_22.png
ncftpput OceanografiaES /html/images RGraficosSSTRaprocan_Anual_Seccion11_22.png
ncftpput OceanografiaES /html/images RGraficosSSTRaprocan_HovMollerDiario_Seccion11_22.png
ncftpput OceanografiaES /html/images RGraficosSSTNorteTenerife_CicloEstacional_Seccion01_02.png
ncftpput OceanografiaES /html/images RGraficosSSTNorteTenerife_Mensual_Seccion01_02.png
ncftpput OceanografiaES /html/images RGraficosSSTNorteTenerife_Anual_Seccion01_02.png
ncftpput OceanografiaES /html/images RGraficosSSTNorteTenerife_HovMollerDiario_Seccion01_02.png
