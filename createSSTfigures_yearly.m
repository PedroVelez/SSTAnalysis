clc;clear all;close all

%Read options
configSSTWebpage

%% Inicio

for numDatSet = 1:1:length(DataSet)

    DataFile=strcat('SST',DataSet(numDatSet).name);
    Estaciones=DataSet(numDatSet).Estaciones;
    TemperatureLimts=DataSet(numDatSet).TemperatureLimts;
    fprintf('Creating figures for %s section (%d/%d): \n',DataFile,numDatSet,length(DataSet))

    
    DSST=load(strcat('./data/',DataFile));
    SSTd=DSST.sstd;
    Timed=DSST.jdaySST;


    %Fehas en formato Vec
    [YdSST,MdSST,DdSST]=datevec(Timed);
    uY=unique(YdSST);

    %Fecha del valor ultimo
    [MYdSST,MMdSST,MDdSST]=datevec(max(Timed));

    FileNameInforme=strcat(DirFigures,'/data/reportYearly',DataFile);
    FicheroGraficoAno=strcat('./images/Graficos',DataFile,'_Anual', ...
        sprintf('_Seccion%02d_%02d.png',min(Estaciones),max(Estaciones)));

    FicheroGraficoAnoNombre=strcat('./images/Graficos',DataFile,'_Anual', ...
        sprintf('_Seccion%02d_%02d_%s_%4d.png',min(Estaciones),max(Estaciones), ...
        MesesEspanol(MMdSST),MYdSST));

    %% Calculo los promediosanuales anos completos
    % Bucle sobre todas las estaciones con datos
    for iEs=1:size(DSST.sstd,1)
        iim=0;
        %Bucle sobre todos los a?os para promedio anual
        for iY=1:length(uY)
            IndiY=find(YdSST==uY(iY));
            sstpunto=SSTd(iEs,IndiY);
            timepunto=Timed(IndiY);
            %solo para anos completos
            if (datenum(uY(iY),12,30.5)-timepunto(end))<0
                SSTanualM(iEs,iY)=nanmean(sstpunto);
                SSTanualS(iEs,iY)=nanstd(sstpunto);
                TimeAnual(iY)=nanmean(timepunto);
            else
                SSTanualM(iEs,iY)=NaN;
                SSTanualS(iEs,iY)=NaN;
                TimeAnual(iY)=NaN;
            end
        end
    end
    %Promedio sobre las estaciones
    MEstacionesSSTanualM=nanmean(SSTanualM(Estaciones,:));
    StdEstacionesSSTanualM=nanstd(MEstacionesSSTanualM);

    %% Calculo los promediosanuales hasta hoy
    %Bucle sobre todas las estaciones con datos
    for iEs=1:size(DSST.sstd,1)
        iim=0;
        %Bucle sobre todos los a?os para promedio anual
        for iY=1:length(uY)
            IndiY=find(YdSST==uY(iY) & MdSST<=MMdSST);
            sstpunto=SSTd(iEs,IndiY);
            timepunto=Timed(IndiY);
            SSTanualHoyM(iEs,iY)=nanmean(sstpunto);
            SSTanualHoyS(iEs,iY)=nanstd(sstpunto);
            TimeAnualHoy(iY)=nanmean(timepunto);
        end
    end
    %Promedio sobre las estaciones
    MEstacionesSSTanualHoyM=nanmean(SSTanualHoyM(Estaciones,:));
    StdEstacionesSSTanualHoyM=nanstd(MEstacionesSSTanualHoyM);

    % Calculo el offeset asociado a la falta de dias en el promedio anual
    OffSetDiaHoy=nanmean(MEstacionesSSTanualM-MEstacionesSSTanualHoyM);

    %% Figuras
    figure
    %Limites
    %TempLimits=extrem([MEstacionesSSTanualM(1:end-1) MEstacionesSSTanualHoyM(end)+OffSetDiaHoy nanmean(MEstacionesSSTanualM(1:end-1))-2*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))+2*StdEstacionesSSTanualM]);
    TempLimits=[nanmean(MEstacionesSSTanualM(1:end-1))-3*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))+3*StdEstacionesSSTanualM];

    %Desviacion standart
    patch([datenum(uY(1),1,1) datenum(uY(end),12,31) datenum(uY(end),12,31) datenum(uY(1),1,1)], ...
        [nanmean(MEstacionesSSTanualM(1:end-1))-2*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))-2*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))+2*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))+2*StdEstacionesSSTanualM], ...
        [0.95 0.95 0.95],'edgecolor',[0.95 0.95 0.95]); hold on;grid on;alpha(0.6)

    plot([datenum(uY(1),1,1) datenum(uY(end),12,31)], ...
        [nanmean(MEstacionesSSTanualM(1:end-1))-2*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))-2*StdEstacionesSSTanualM], ...
        'color',[0.95 0.95 0.95],'linewidth',2);

    plot([datenum(uY(1),1,1) datenum(uY(end),12,31)], ...
        [nanmean(MEstacionesSSTanualM(1:end-1))+2*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))+2*StdEstacionesSSTanualM], ...
        'color',[0.95 0.95 0.95],'linewidth',2);

    %Linea con la media
    plot([datenum(uY(1),1,1) datenum(uY(end),12,31)],[nanmean(MEstacionesSSTanualM(1:end-1)) nanmean(MEstacionesSSTanualM(1:end-1))],'-','color',[0.5 0.5 0.5],'linewidth',3)

    %Plot de los datos promedio anuales  y el promeido del ano en curso corregido
    plot([TimeAnual(1:end-1) TimeAnualHoy(end)],[MEstacionesSSTanualM(1:end-1) MEstacionesSSTanualHoyM(end)+OffSetDiaHoy],'ko-','MarkerFacecolor','k','Markersize',5); hold on
    plot(TimeAnualHoy(end),MEstacionesSSTanualHoyM(end)+OffSetDiaHoy,'o','MarkerFacecolor','c','Markersize',8); hold on

    %Lineas para el ultimo dato
    plot([TimeAnual(1) TimeAnualHoy(end-1)],[MEstacionesSSTanualHoyM(end)+OffSetDiaHoy MEstacionesSSTanualHoyM(end)+OffSetDiaHoy],'k--')
    plot([TimeAnualHoy(end) TimeAnualHoy(end)],[MEstacionesSSTanualHoyM(end)+OffSetDiaHoy TempLimits(1)],'k--')

    %Valor dato maximo
    plot(TimeAnual(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)),MEstacionesSSTanualM(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)),'sr','Markersize',10,'MarkerFaceColor','r');

    %Valor dato minimo
    plot(TimeAnual(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)),MEstacionesSSTanualM(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)),'sb','Markersize',10,'MarkerFaceColor','b');

    axis([datenum(uY(1),1,1) datenum(uY(end),12,31) TempLimits])
    datetick('x','yyyy','keeplimits','keepticks')
    box on

    %Crédito
    text(datenum(uY(end)-9,01,12),TempLimits(1)+0.15,FuenteDatos,'HorizontalAlignment','center')

    %Titulo
    InformeAnho1=sprintf('Temperatura media en %s: %4.2f C [%s].\n', ...
        datestr(TimeAnualHoy(end),'yyyy'), ...
        MEstacionesSSTanualHoyM(end)+OffSetDiaHoy, ...
        DataFile);

    InformeAnho2=sprintf('%s-%s: ', ...
        datestr(nanmin(TimeAnual),'yyyy'),datestr(nanmax(TimeAnual),'yyyy'));

    InformeAnho3=sprintf('Temperatura media: %4.2f C, desviacion standart: %04.2f C.\n', ...
        nanmean(MEstacionesSSTanualM(1:end-1)), ...
        nanstd(MEstacionesSSTanualM(1:end-1)));
    InformeAnho4=sprintf('Maxima [%s]: %4.2 ºC. ',...
        datestr(TimeAnual(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)),'yyyy'), ...
        MEstacionesSSTanualM(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)));

    InformeAnho5=sprintf('Minima [%s]: %4.2 ºC.',...
        datestr(TimeAnual(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)),'yyyy'), ...
        MEstacionesSSTanualM(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)));
    InformeAnho=sprintf('%s',InformeAnho1,InformeAnho2,InformeAnho3,InformeAnho4,InformeAnho5);
    title(InformeAnho)

    CreaFigura(gcf,FicheroGraficoAno,[4])
    CreaFigura(gcf,FicheroGraficoAnoNombre,[4])

    %Ftp the file
    ftpobj=FtpOceanografia;
    cd(ftpobj,'/html/pedro/images');
    mput(ftpobj,FicheroGraficoAno);
    mput(ftpobj,FicheroGraficoAnoNombre);
    close(ftpobj)

    save(FileNameInforme,'InformeAnho');
    fprintf(' \nSaving report\n')
end
