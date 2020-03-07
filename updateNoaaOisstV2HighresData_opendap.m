close all;clear all;clc

%NOAA OI SST V2 High Resolution Dataset
%Baja los datos de https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.highres.html
%https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.highres.html
%
%Original source NCEI at ftp://eclipse.ncdc.noaa.gov/pub/OI-daily-v2/.

NameRegion='CCLME';

lat_min=5.1250; lat_max=44.8750;
lon_min=333.1250; lon_max=354.8750;

[Ynow,Mnow,Dnow]=datevec(now);
AnhoI=1982;
AnhoF=2020;

%Read options
configSSTWebpage

%% inicio

FileNameInforme=strcat(DirDataSST,'/reportUpdateData');

%Nombre del fichero vigente
FilesLocal=dir(strcat(DirDataSST,'/*NOAAOisstv2HighresSstDayMean*',num2str(AnhoF),'*'));
DiaMax=0;
if ~isempty(FilesLocal)
    for i1=1:length(FilesLocal)
        T=load(strcat(DirDataSST,'/',FilesLocal(i1).name),'timetd');
        DiaMax=max([T.timetd;DiaMax]);
    end
    
    % Bajo los datos del ultimo anho
    %FileWeb=strcat('https://www.esrl.noaa.gov/psd/thredds/fileServer/Datasets/noaa.oisst.v2.highres/sst.day.mean.',num2str(AnhoF),'.v2.nc');
    FileWeb=strcat('http://www.esrl.noaa.gov/psd/thredds/dodsC/Datasets/noaa.oisst.v2.highres/sst.day.mean.',num2str(AnhoF),'.v2.nc');
    fprintf('     >Reading data from %s \n',FileWeb)
    
    %Miro se si han actualizado los datos en la web
    ttime=double(ncread(FileWeb,'time'));ttime=ttime+datenum(1800,1,1);%days since 1800-01-01 00:00:00
    DiaMaxWeb=max(ttime);
    [YnMaxWeb,MMaxWeb,DMaxWeb]=datevec(DiaMaxWeb);
    fprintf('     >Datos web %s, Datos local %s\n',datestr(DiaMaxWeb),datestr(DiaMax))
    
    % Actualizo los datos
    if DiaMaxWeb>DiaMax
        Informe=sprintf('     >Actualizando los datos hasta el %s \n',datestr(DiaMaxWeb));disp(Informe)
        %Selecciono zona
        itime=length(ttime);
        lon=double(ncread(FileWeb,'lon')); %grids = 'Uniform grid from 0.125 to 359.875 by 0.25'
        lat=double(ncread(FileWeb,'lat')); %grids = 'Uniform grid from -89.875 to 89.875 by 0.25'
        ilon_min=Locate(lon,lon_min);
        ilon_max=Locate(lon,lon_max);
        ilat_min=Locate(lat,lat_min);
        ilat_max = Locate(lat,lat_max);
        tlon = double(ncread(FileWeb,'lon',[ilon_min],[ilon_max-ilon_min+2]));
        tlat = double(ncread(FileWeb,'lat',[ilat_min],[ilat_max-ilat_min+2]));
        try
            tsst = double(ncread(FileWeb,'sst',[ilon_min ilat_min 1],[ilon_max-ilon_min+2  ilat_max-ilat_min+2 itime]));
            
%            ncid = netcdf.open(FileWeb,'NOWRITE');
%            varid = netcdf.inqVarID(ncid,'sst');
%            data = double(netcdf.getVar(ncid,varid,[ilon_min ilat_min 1],[ilon_max-ilon_min+2  ilat_max-ilat_min+2 itime]));
            
        catch ME
            for i1 = 1:itime
                fprintf('%03d, ',i1)
                vartemp = double(ncread(FileWeb,'sst',[ilon_min ilat_min i1],[ilon_max-ilon_min+2  ilat_max-ilat_min+2 1]));
                tsst(:,:,i1) = vartemp;
            end
        end
        sstnan = double(ncreadatt(FileWeb,'sst','missing_value'));%missing_value = -9.969209968386869e+36
        tsst ( tsst == sstnan) = NaN;
        
        %Cuando estamos a 31/12/Anho salvo el fichero anual
        if MMaxWeb==12 && DMaxWeb==31
            save(strcat(DirDataSST,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',NameRegion),'tlon','tlat','tsst','ttime','lat_min','lat_max','lon_min','lon_max','ilon_min','ilon_max','ilat_min','ilat_max')
            fprintf('     >Saving %s \n',strcat(DirDataSST,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',NameRegion))
        end
        
        %Read file with the data in the period 1982-(ultimoano-1) and add it
        FileInt=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean_',datestr(datenum(AnhoI,1,1),'ddmmyyyy'),'_',datestr(datenum(AnhoF-1,12,31),'ddmmyyyy'),'_',NameRegion);
        fprintf('     >Appending %s -->',FileInt)
        DATA=matfile(FileInt);
        ssttd=DATA.ssttd;
        timetd=DATA.timetd;
        
        %Add data I have just read
        ssttd=cat(3,ssttd,tsst);
        timetd=cat(1,timetd,ttime);
        lon=tlon;
        lat=tlat;
        FileOut=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean_',datestr(timetd(1),'ddmmyyyy'),'_',datestr(timetd(end),'ddmmyyyy'),'_',NameRegion,'.mat');
        fprintf('%s \n',FileOut)
        save(FileOut,'lon','lat','ssttd','timetd','lat_min','lat_max','lon_min','lon_max')
        
        %Delete previous local file
        if ~isempty(FilesLocal)
            for i1=1:length(FilesLocal)
                unix(sprintf('rm %s',strcat(DirDataSST,'/',FilesLocal(i1).name)));
            end
        end
    else
        Informe=sprintf('     >No se han actualizado los datos. Ya estan hasta el %s \n',datestr(DiaMax));
        disp(Informe)
    end
    save(FileNameInforme,'Informe');
end
