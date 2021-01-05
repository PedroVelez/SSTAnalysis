close all;clear all;clc

%Dowload netcdf NOAA OI SST V2 High Resolution Dataset described in
%https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.highres.html
%
%This is the htpps catalog:
%https://www.esrl.noaa.gov/psd/thredds/catalog/Datasets/noaa.oisst.v2.highres/catalog.html?dataset=Datasets/noaa.oisst.v2.highres/sst.day.mean.2020.v2.nc
%
%This is the ftp catalog:
%https://www.esrl.noaa.gov/psd/cgi-bin/db_search/DBListFiles.pl?did=132&tid=84318&vid=2423
%
%Original source NCEI at ftp://eclipse.ncdc.noaa.gov/pub/OI-daily-v2/.

NameRegion='CCLME';

lat_min=5.1250; lat_max=44.8750;
lon_min=333.1250; lon_max=354.8750;

[Ynow,Mnow,Dnow]=datevec(now);
AnhoI=1982;
AnhoF=2021;

%% Begin
fprintf('>>>>> %s\n',mfilename)
%Read options
configSSTWebpage

%File report name
FileNameReport=strcat(DirDataSST,'/reportUpdateData');

%Download netcdf file for the current year
FileThisYear=strcat('sst.day.mean.',num2str(AnhoF),'.nc');
ftpobj = ftp('ftp.cdc.noaa.gov');
cd(ftpobj,'Datasets/noaa.oisst.v2.highres/');
mget(ftpobj,FileThisYear,DirDataSST);

%Name of the local files
FilesLocal=dir(strcat(DirDataSST,'/*NOAAOisstv2HighresSstDayMean*',num2str(AnhoF),'*'));
LastLocalDay=0;

if ~isempty(FilesLocal)
    for i1=1:length(FilesLocal)
        T=load(strcat(DirDataSST,'/',FilesLocal(i1).name),'timetd');
        LastLocalDay=max([T.timetd;LastLocalDay]);
    end
    
    %Look if the recently loaded files is newer than the local data
    FileThisYear=fullfile(DirDataSST,FileThisYear);
    fprintf('     >Reading data from %s \n',FileThisYear)
    
    ttime=double(ncread(FileThisYear,'time'));ttime=ttime+datenum(1800,1,1);%days since 1800-01-01 00:00:00
    DiaMaxWeb=max(ttime);
    [YnMaxWeb,MMaxWeb,DMaxWeb]=datevec(DiaMaxWeb);
    fprintf('     >Data web %s, local data %s\n',datestr(DiaMaxWeb),datestr(LastLocalDay))
    
    %Update data is downloaded data is newer
    if DiaMaxWeb>LastLocalDay
        Report=sprintf('     >Updating data until %s \n',datestr(DiaMaxWeb));disp(Report)
        %Selecciono zona
        itime=length(ttime);
        lon=double(ncread(FileThisYear,'lon')); %grids = 'Uniform grid from 0.125 to 359.875 by 0.25'
        lat=double(ncread(FileThisYear,'lat')); %grids = 'Uniform grid from -89.875 to 89.875 by 0.25'
        ilon_min=Locate(lon,lon_min);
        ilon_max=Locate(lon,lon_max);
        ilat_min=Locate(lat,lat_min);
        ilat_max = Locate(lat,lat_max);
        tlon = double(ncread(FileThisYear,'lon',[ilon_min],[ilon_max-ilon_min+2]));
        tlat = double(ncread(FileThisYear,'lat',[ilat_min],[ilat_max-ilat_min+2]));
        tsst = double(ncread(FileThisYear,'sst',[ilon_min ilat_min 1],[ilon_max-ilon_min+2  ilat_max-ilat_min+2 itime]));
        sstnan = double(ncreadatt(FileThisYear,'sst','missing_value'));%missing_value = -9.969209968386869e+36
        tsst (tsst == sstnan) = NaN;
        
        %Cuando estamos a 31/12/Anho salvo el fichero anual
        if MMaxWeb==12 && DMaxWeb==31
            save(strcat(DirDataSST,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',NameRegion),'tlon','tlat','tsst','ttime','lat_min','lat_max','lon_min','lon_max','ilon_min','ilon_max','ilat_min','ilat_max')
            fprintf('     >Saving %s \n',strcat(DirDataSST,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',NameRegion))
        end
        
        %Read file with the data in the period 1982-(lastyear-1)
        FileInt=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean_',datestr(datenum(AnhoI,1,1),'ddmmyyyy'),'_',datestr(datenum(AnhoF-1,12,31),'ddmmyyyy'),'_',NameRegion);
        fprintf('     >Appending %s -->',FileInt)
        DATA=matfile(FileInt);
        ssttd=DATA.ssttd;
        timetd=DATA.timetd;
        
        %Add data just read
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
        Report=sprintf('     >Local data is already the last version %s \n',datestr(LastLocalDay));
        disp(Report)
    end
    save(FileNameReport,'Report');
end
