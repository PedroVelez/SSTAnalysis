load Globales


%% Geographical region
NameRegion='CCLME';
lat_min=5.1250; lat_max=44.8750;
lon_min=333.1250; lon_max=354.8750;

%Time period
AnhoI=1982;
AnhoF=2020;

%Data files
DirDataSST=strcat(GlobalSU.DatPath,'/Satelite/noaa.oisst.v2.highres');
FileDataSST=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean');

%Stations foles
EstRaprocan=strcat(GlobalSU.ProPath,'/SSTWebpage/data/EstacionesRaprocan.txt');
EstNorteTenerife=strcat(GlobalSU.ProPath,'/SSTWebpage/data/EstacionesNorteTenerife.txt');

DirFigures=strcat(GlobalSU.ProPath,'/SSTWebpage');

DirHTML='/html/pedro/images';

FuenteDatos=sprintf('Elaborado por el Instituto Español de Oceanografía\n a partir de datos de https://www.ncdc.noaa.gov/oisst');

NAnosR=4; %years to represent

