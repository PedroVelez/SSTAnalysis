#!/bin/bash
source $HOME/.telegram

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=$HOME/Analisis/SSTWebpage
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
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures02;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures02;exit' > $DirLog/createSSTfigures01.log
fi

printf "Updating hovmoller plotsa\n"
if [ $Verbose == 1 ]
then
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures02;exit'
else
  cd $PaginaWebDir; $MatVersion -nodisplay -nosplash -r 'createSSTfigures02;exit' > $DirLog/createSSTfigures02.log
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
URLimg="https://api.telegram.org/bot$ArgoEsBotTOKEN/sendphoto?chat_id=$ArgoEsChannel"
MENSAJE=`cat $HOME/Analisis/SSTWebpage/data/report.txt`

curl -s -X POST $URL -d chat_id=$ArgoEsChannel -d text="$MENSAJE" -d parse_mode=html > $DirLog/bot.log
curl -F "photo=@$HOME/Analisis/SSTWebpage/images/GraficosSSTNorteTenerife_CicloEstacional_Seccion01_02.png" $URLimg -F caption="GraficosSSTNorteTenerife_CicloEstacional"
curl -F "photo=@$HOME/Analisis/SSTWebpage/images/GraficosSSTNorteTenerife_Anual_Seccion01_02.png" $URLimg -F caption="GraficosSSTNorteTenerife_Anual"
curl -F "photo=@$HOME/Analisis/SSTWebpage/images/GraficosSSTNorteTenerife_Mensual_Seccion01_02.png" $URLimg -F caption="GraficosSSTNorteTenerife_Mensual"



