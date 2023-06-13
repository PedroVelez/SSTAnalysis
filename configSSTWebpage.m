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

%Stations files

EstRaprocan = strcat(GlobalSU.AnaPath,'/SSTWebpage/data/EstacionesRaprocan.txt');
EstNorteTenerife = strcat(GlobalSU.AnaPath,'/SSTWebpage/data/EstacionesNorteTenerife.txt');
EstLasPalmas = strcat(GlobalSU.AnaPath,'/SSTWebpage/data/EstacionesLasPalmas.txt');
EstGijon = strcat(GlobalSU.AnaPath,'/SSTWebpage/data/EstacionesGijon.txt');

% Stations files
DataSet(1).name='Raprocan';
DataSet(1).Estaciones=[11:1:22];
DataSet(1).TemperatureLimts=[17 26];

DataSet(2).name='NorteTenerife';
DataSet(2).Estaciones=[1:1:2];
DataSet(2).TemperatureLimts=[17 26];

DataSet(3).name='LasPalmas';
DataSet(3).Estaciones=[1:1:2];
DataSet(3).TemperatureLimts=[17 26];

DataSet(4).name='Gijon';
DataSet(4).Estaciones=[1:1:2];
DataSet(4).TemperatureLimts=[11 24];

DataSet(5).name='Vigo';
DataSet(5).Estaciones=[1:1:2];
DataSet(5).TemperatureLimts=[11 24];



%
DirFigures=strcat(GlobalSU.AnaPath,'/SSTWebpage');

DirHTML='/html/pedro/images';

FuenteDatos=sprintf('Elaborado por el Instituto Espanol de Oceanografia\n a partir de datos de https://www.ncdc.noaa.gov/oisst');

NAnosR=4; %years to represent

