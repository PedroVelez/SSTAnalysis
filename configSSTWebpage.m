load Globales

FuenteDatos=sprintf('Elaboracion Instituto Español de Oceanografía\n a partir de datos de https://www.ncdc.noaa.gov/oisst');

DirHTML='/html/pedro/images';

DirDataSST=strcat(GlobalSU.DatPath,'/Satelite/noaa.oisst.v2.highres');
FileDataSST=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean');

DirFigures=strcat(GlobalSU.ProPath,'/SSTWebpage');
EstRaprocan=strcat(GlobalSU.ProPath,'/SSTWebpage/data/EstacionesRaprocan.txt');
EstNorteTenerife=strcat(GlobalSU.ProPath,'/SSTWebpage/data/EstacionesNorteTenerife.txt');

NAnosR=4; %years to represent

