Limpia

iRegion=3;
DirDataAnual=strcat(GlobalSU.home,'/Dropbox/Oceanografia/Analisis/TendenciasEBUS/TendenciasAVHRR/Data');

AnhoI=1982;
AnhoF=2020;

for i1=1:1:4
    switch i1
        case 1 %CaCLME
            Region='CaCLME';load(strcat(GlobalSU.LibPath,'/Settings','/DS',Region));
        case 2 % ClCLME
            Region='ClCLME';load(strcat(GlobalSU.LibPath,'/Settings','/DS',Region));
        case 3 % BeCLME
            Region='BeCLME'; load(strcat(GlobalSU.LibPath,'/Settings','/DS',Region));
        case 4
            Region='HuCLME'; load(strcat(GlobalSU.LibPath,'/Settings','/DS',Region));
    end
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
end
