close all;clear all;clc

%% Begin
fprintf('>>>>> %s\n',mfilename)

%Read options
configSSTWebpage

[Ynow,Mnow,Dnow]=datevec(now);

%File report name
FileNameReport=strcat(DirDataSST,'/reportUpdateData');

%Download netcdf file for the current year
FileThisYear=strcat('sst.day.mean.',num2str(AnhoF),'.nc');
ftpobj = ftp('ftp.cdc.noaa.gov');
cd(ftpobj,'Datasets/noaa.oisst.v2.highres/');
mget(ftpobj,FileThisYear,DirDataSST);
mget(ftpobj,FileThisYear,DirDataSSTNC);
close(ftpobj)

%Name of the local files
FilesLocal=dir(strcat(DirDataSST,'/*NOAAOisstv2HighresSstDayMean*',num2str(AnhoF),'*',Region,'*'));
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

    %Update data if downloaded data is newer
    if DiaMaxWeb>LastLocalDay
        Report=sprintf('     >Updating data until %s \n',datestr(DiaMaxWeb));disp(Report)

        %Selecciono zona
        ttime=double(ncread(FileThisYear,'time'));ttime=ttime+datenum(1800,1,1);%days since 1800-01-01 00:00:00
        itime=length(ttime);

        lon=double(ncread(FileThisYear,'lon'));
        lat=double(ncread(FileThisYear,'lat'));

        ilon1=Locate(lon,lon_min);
        ilon2=Locate(lon,lon_max);
        ilat1=Locate(lat,lat_min);
        ilat2=Locate(lat,lat_max);

        tlon1=double(ncread(FileThisYear,'lon',[ilon1],[length(lon)-ilon1]));
        tlat1=double(ncread(FileThisYear,'lat',[ilat1],[ilat2-ilat1]));
        tsst1=double(ncread(FileThisYear,'sst',[ilon1 ilat1 1],[length(lon)-ilon1  ilat2-ilat1 itime]));
        sstnan=double(ncreadatt(FileThisYear,'sst','missing_value'));%missing_value = -9.969209968386869e+36
        tsst1(tsst1==sstnan)=NaN;

        tlon2=double(ncread(FileThisYear,'lon',[1],[ilon2]));
        tsst2=double(ncread(FileThisYear,'sst',[1 ilat1 1],[ilon2  ilat2-ilat1 itime]));
        tsst2(tsst2==sstnan)=NaN;
        tsst=cat(1,tsst1,tsst2);
        tlon= cat(1,tlon1-360,tlon2);
        tlat=tlat1;
        %Cuando estamos a 31/12/Anho salvo el fichero anual
        if MMaxWeb==12 && DMaxWeb==31
            save(strcat(DirDataSST,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',Region),'tlon','tlat','tsst','ttime','lat_min','lat_max','lon_min','lon_max','ilon_min','ilon_max','ilat_min','ilat_max')
            fprintf('     >Saving %s \n',strcat(DirDataSST,'/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(ttime(1),'ddmmyyyy'),'_',datestr(ttime(end),'ddmmyyyy'),'_',Region))
        end

        %Read file with the data in the period 1982-(lastyear-1)
        FileInt=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean_',datestr(datenum(AnhoI,1,1),'ddmmyyyy'),'_',datestr(datenum(AnhoF-1,12,31),'ddmmyyyy'),'_',Region);
        fprintf('     >Appending %s -->',FileInt)
        DATA=matfile(FileInt);
        ssttd=DATA.ssttd;
        timetd=DATA.timetd;

        %Add data just read
        ssttd=cat(3,ssttd,tsst);
        timetd=cat(1,timetd,ttime);
        lon=tlon;
        lat=tlat;
        
        %save new file
        FileOut=strcat(DirDataSST,'/NOAAOisstv2HighresSstDayMean_',datestr(timetd(1),'ddmmyyyy'),'_',datestr(timetd(end),'ddmmyyyy'),'_',Region,'.mat');
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
