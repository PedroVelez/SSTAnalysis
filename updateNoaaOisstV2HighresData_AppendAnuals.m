clearvars ;close all
global GlobalSU;load Globales

% Une los .mat anuales creados con updateNoaaOisstV2HighresData_CreateAnual.m
% lo hacen en lon -180,180

DirDataAnual=fullfile(GlobalSU.DatPath_Server,'/Satelite/noaa.oisst.v2.highres');

AnhoI=1982;
AnhoF=2022;

Region='Espanha';
GlobalDS.lon_min=-25+360;
GlobalDS.lon_max=5;
GlobalDS.lat_min=20;
GlobalDS.lat_max=50;


fprintf('     > %s\n',Region)
ssttd=[];timetd=[];
lon=[];lat=[];

for ianho=AnhoI:1:AnhoF
    FileIn=strcat('/Anuales/NOAAOisstv2HighresSstDayMean_',datestr(datenum(ianho,1,1),'ddmmyyyy'),'_',datestr(datenum(ianho,12,31),'ddmmyyyy'),'_',Region);
    TFileIn=strcat(DirDataAnual,FileIn);
    fprintf('%s\n',FileIn)
    DATA=load(TFileIn);

    lon=DATA.tlon;
    lat=DATA.tlat;
    ssttd=cat(3,ssttd,DATA.tsst);
    timetd=cat(1,timetd,DATA.ttime);
    clear DATA
end

save(strcat('NOAAOisstv2HighresSstDayMean_',datestr(timetd(1),'ddmmyyyy'),'_',datestr(timetd(end),'ddmmyyyy'),'_',Region,'.mat'),'lon','lat','ssttd','timetd')
