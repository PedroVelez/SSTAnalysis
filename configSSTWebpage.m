load Globales

%% Geographical region
NameRegion='CCLME';
lat_min=5.1250; lat_max=44.8750;
lon_min=333.1250; lon_max=354.8750;

%Time period
AnhoI=1982;
AnhoF=2023;

%Data files
DirDataSST=strcat(GlobalSU.DatPath_Server,'/Satelite/noaa.oisst.v2.highres');
DirDataSSTNC=strcat(GlobalSU.DatPath_Server,'/Satelite/noaa.oisst.v2.highres');
FileDataSST=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean');

%Stations foles
EstRaprocan=strcat(GlobalSU.ProPath,'/SSTWebpage/data/EstacionesRaprocan.txt');
EstNorteTenerife=strcat(GlobalSU.ProPath,'/SSTWebpage/data/EstacionesNorteTenerife.txt');
EstLasPalmas=strcat(GlobalSU.ProPath,'/SSTWebpage/data/EstacionesLasPalmas.txt');

DirFigures=strcat(GlobalSU.ProPath,'/SSTWebpage');

DirHTML='/html/pedro/images';

FuenteDatos=sprintf('Elaborado por el Instituto Espanol de Oceanografia\n a partir de datos de https://www.ncdc.noaa.gov/oisst');

NAnosR=4; %years to represent

