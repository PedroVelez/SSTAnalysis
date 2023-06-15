clearvars ;close all
global GlobalSU;load Globales

% A partir de los netcdf anuales crea un .mat para la region especificada. 
% lo hacen en lon -180,180

AnhoI=1982;
AnhoF=2022;

DirOutData=fullfile(GlobalSU.DatPath_Server,'/Satelite/noaa.oisst.v2.highres');

Region='Espanha';
GlobalDS.lon_min=-25+360;
GlobalDS.lon_max=5;
GlobalDS.lat_min=20;
GlobalDS.lat_max=50;

fprintf('     > %s\n',Region)
%% inicio
for ianho=AnhoI:1:AnhoF
    FileInUltimo=strcat(GlobalSU.DatPath_Server,'/Satelite/noaa.oisst.v2.highres/NC/sst.day.mean.',num2str(ianho),'.nc');
    fprintf('     > Reading data from %s \n',FileInUltimo)

    ttime=double(ncread(FileInUltimo,'time'));ttime=ttime+datenum(1800,1,1);%days since 1800-01-01 00:00:00

    %Selecciono zona
    itime=length(ttime);
    lon=double(ncread(FileInUltimo,'lon')); %grids = 'Uniform grid from 0.125 to 359.875 by 0.25'
    lat=double(ncread(FileInUltimo,'lat')); %grids = 'Uniform grid from -89.875 to 89.875 by 0.25'

    ilon1=Locate(lon,GlobalDS.lon_min);
    ilon2=Locate(lon,GlobalDS.lon_max);
    ilat1=Locate(lat,GlobalDS.lat_min);
    ilat2=Locate(lat,GlobalDS.lat_max);

    tlon1=double(ncread(FileInUltimo,'lon',[ilon1],[length(lon)-ilon1]));
    tlat1=double(ncread(FileInUltimo,'lat',[ilat1],[ilat2-ilat1]));
    tsst1=double(ncread(FileInUltimo,'sst',[ilon1 ilat1 1],[length(lon)-ilon1  ilat2-ilat1 itime]));
    sstnan=double(ncreadatt(FileInUltimo,'sst','missing_value'));%missing_value = -9.969209968386869e+36
    tsst1(tsst1==sstnan)=NaN;


    tlon2=double(ncread(FileInUltimo,'lon',[1],[ilon2]));
    tsst2=double(ncread(FileInUltimo,'sst',[1 ilat1 1],[ilon2  ilat2-ilat1 itime]));
    tsst2(tsst2==sstnan)=NaN;

    tsst=cat(1,tsst1,tsst2);
    tlon= cat(1,tlon1-360,tlon2);
    tlat=tlat1;

    save(strcat(DirOutData,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',Region),'tlon','tlat','tsst','ttime')
    fprintf('     >Saving %s \n',strcat(DirOutData,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',Region))

end
