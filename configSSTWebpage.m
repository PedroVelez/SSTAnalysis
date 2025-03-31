load Globales

%% Geographical region
Region='Espanha';
lon_min=-25+360;
lon_max=5;
lat_min=20;
lat_max=50;

%Time period
AnhoI=1982;
AnhoF=2025;

%Data files
DirDataSST=strcat(GlobalSU.DatPath,'/Satelite/noaa.oisst.v2.highres');
DirDataSSTAnuales=strcat(GlobalSU.DatPath,'/Satelite/noaa.oisst.v2.highres/Anuales');
DirDataSSTNC=strcat(GlobalSU.DatPath,'/Satelite/noaa.oisst.v2.highres/NC');
FileDataSST=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean');

%Stations files

EstRaprocan = strcat(GlobalSU.AnaPath,'/SSTAnalysis/data/EstacionesRaprocan.txt');
EstNorteTenerife = strcat(GlobalSU.AnaPath,'/SSTAnalysis/data/EstacionesNorteTenerife.txt');
EstLasPalmas = strcat(GlobalSU.AnaPath,'/SSTAnalysis/data/EstacionesLasPalmas.txt');
EstGijon = strcat(GlobalSU.AnaPath,'/SSTAnalysis/data/EstacionesGijon.txt');

% Stations files
isec=0;

isec=isec+1;
DataSet(1).name='Raprocan';
DataSet(1).nameLong='Raprocan';
DataSet(1).Estaciones=[11:1:22];
DataSet(1).TemperatureLimts=[17 26];

isec=isec+1;
DataSet(isec).name='NorteTenerife';
DataSet(isec).nameLong='NorteTenerife';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[17 26];

isec=isec+1;
DataSet(isec).name='Tenerife';
DataSet(isec).nameLong='Santa Cruz de Tenerife';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[17 26];

isec=isec+1;
DataSet(isec).name='Vigo';
DataSet(isec).nameLong='Vigo';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[11 21];

isec=isec+1;
DataSet(isec).name='Gijon';
DataSet(isec).nameLong='Gijón';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[11 24];

isec=isec+1;
DataSet(isec).name='Santander';
DataSet(isec).nameLong='Santander';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[11 24];

isec=isec+1;
DataSet(isec).name='Cadiz';
DataSet(isec).nameLong='Cádiz';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[16 25];

isec=isec+1;
DataSet(isec).name='Malaga';
DataSet(isec).nameLong='Málaga';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[13 28];

isec=isec+1;
DataSet(isec).name='Palma';
DataSet(isec).nameLong='Palma de Mallorca';
DataSet(isec).Estaciones=[1:1:2];
DataSet(isec).TemperatureLimts=[12 30];


%Directorios
DirFigures=strcat(GlobalSU.AnaPath,'/SSTAnalysis');

%Directorio html servidor PP
DirHTML='/html/pedro/images';
DirHTMLIEOOS='/html/IEOOS/SST/images';

FuenteDatos=sprintf('Elaborado por el Instituto Espanol de Oceanografia\n a partir de datos de https://www.ncdc.noaa.gov/oisst');

NAnosR=4; %years to represent

