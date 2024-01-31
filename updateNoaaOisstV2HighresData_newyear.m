close all;clear all;clc

%Script arealizar para crear el paso a un año nuevo. 
% Coge los datos AnhoI-An
% Ya esta los datos del
%año previo hasta 31/12 y hay datos a partir de 1/1 del año siguiente

%Actualiza la base de datos existente

[Ynow,Mnow,Dnow]=datevec(now);
AnhoI=1982;
AnhoF=2024;

%% inicio
configSSTWebpage

% Nombre del fichero vigente
% Download netcdf file for the current year
FileThisYear=strcat('sst.day.mean.',num2str(AnhoF),'.nc');
fprintf('     > Downlaoding %s\n',FileThisYear)
%ftpobj = ftp('ftp.cdc.noaa.gov');
%cd(ftpobj,'Datasets/noaa.oisst.v2.highres/');
%mget(ftpobj,FileThisYear,DirDataSST);
%mget(ftpobj,FileThisYear,DirDataSSTNC);

%Miro se si han actualizado los datos en la web
ttime=double(ncread(fullfile(DirDataSST,FileThisYear),'time'));ttime=ttime+datenum(1800,1,1);%days since 1800-01-01 00:00:00
DiaMaxWeb=max(ttime);
[YnMaxWeb,MMaxWeb,DMaxWeb]=datevec(DiaMaxWeb);
fprintf('     >Datos web %s\n',datestr(DiaMaxWeb))

%% Actualizo los datos locales
Informe=sprintf('     >Actualizando los datos hasta el %s \n',datestr(DiaMaxWeb));disp(Informe)

%Selecciono zona
ttime=double(ncread(fullfile(DirDataSST,FileThisYear),'time'));ttime=ttime+datenum(1800,1,1);%days since 1800-01-01 00:00:00
itime=length(ttime);

lon=double(ncread(fullfile(DirDataSST,FileThisYear),'lon'));
lat=double(ncread(fullfile(DirDataSST,FileThisYear),'lat'));

ilon1=Locate(lon,lon_min);
ilon2=Locate(lon,lon_max);
ilat1=Locate(lat,lat_min);
ilat2=Locate(lat,lat_max);

tlon1=double(ncread(fullfile(DirDataSST,FileThisYear),'lon',[ilon1],[length(lon)-ilon1]));
tlat1=double(ncread(fullfile(DirDataSST,FileThisYear),'lat',[ilat1],[ilat2-ilat1]));
tsst1=double(ncread(fullfile(DirDataSST,FileThisYear),'sst',[ilon1 ilat1 1],[length(lon)-ilon1  ilat2-ilat1 itime]));
sstnan=double(ncreadatt(fullfile(DirDataSST,FileThisYear),'sst','missing_value'));%missing_value = -9.969209968386869e+36
tsst1(tsst1==sstnan)=NaN;


tlon2=double(ncread(fullfile(DirDataSST,FileThisYear),'lon',[1],[ilon2]));
tsst2=double(ncread(fullfile(DirDataSST,FileThisYear),'sst',[1 ilat1 1],[ilon2  ilat2-ilat1 itime]));
tsst2(tsst2==sstnan)=NaN;

tsst=cat(1,tsst1,tsst2);
tlon= cat(1,tlon1-360,tlon2);
tlat=tlat1;

%Leo datos periodo 1982-(ultimoano-1) and add it
FileInt=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean_',datestr(datenum(AnhoI,1,1),'ddmmyyyy'),'_',datestr(datenum(AnhoF-1,12,31),'ddmmyyyy'),'_',Region);
fprintf('     >Appending %s --> \n',FileInt)
DATA=matfile(FileInt);
ssttd=DATA.ssttd;
timetd=DATA.timetd;

%Add data I have just read
ssttd=cat(3,ssttd,tsst);
timetd=cat(1,timetd,ttime);
lon=tlon;
lat=tlat;
FileOut=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean_',datestr(timetd(1),'ddmmyyyy'),'_',datestr(timetd(end),'ddmmyyyy'),'_',Region,'.mat');
fprintf('%s \n',FileOut)
save(FileOut,'lon','lat','ssttd','timetd','lat_min','lat_max','lon_min','lon_max')
