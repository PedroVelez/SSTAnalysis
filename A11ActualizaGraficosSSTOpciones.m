load Globales
% ArgoEsOpciones
DirDataSST=strcat(GlobalSU.DatPath,'/Satelite/noaa.oisst.v2.highres');
FileDataSST=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean');

DirFigures=strcat(GlobalSU.ProPath,'/PaginaWebSST');
EstRaprocan=strcat(GlobalSU.ProPath,'/PaginaWebSST/Data/EstacionesRaprocan.txt');
EstNorteTenerife=strcat(GlobalSU.ProPath,'/PaginaWebSST/Data/EstacionesNorteTenerife.txt');

NAnosR=4; %Numero de anos atrasado a representar

