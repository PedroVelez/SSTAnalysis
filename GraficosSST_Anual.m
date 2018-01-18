clc;clear all;close all

ActualizaGraficosSSTOpciones

%% Inicio
for NumDatSet=[1 2]
    
    if NumDatSet==1
        DataFile='SSTRaprocan';
        Estaciones=[11:1:22]; %Oceanicas
        TemperatureLimts=[17 26];
    elseif NumDatSet==2
        DataFile='SSTNorteTenerife';
        Estaciones=[1:2];
        TemperatureLimts=[17 26];
    end
    
    FileNameInforme=strcat(DirFigures,'/Data/InformeAnual',DataFile);
    FicheroGraficoAno=strcat('./Figures/Graficos',DataFile,'_Anual',sprintf('_Seccion%02d_%02d',min(Estaciones),max(Estaciones)));
    
    DSST=load(strcat('./Data/',DataFile));
    SSTd=DSST.sstd;
    Timed=DSST.jdaySST;
    
    %Fehas en formato Vec
    [YdSST,MdSST,DdSST]=datevec(Timed);
    uY=unique(YdSST);
    %Fecha del valor ultimo
    [MYdSST,MMdSST,MDdSST]=datevec(max(Timed));
    
    
    %% Calculo los promediosanuales anos completos
    %Bucle sobre todas las estaciones con datos
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
    
    % Calculo el 'offeset asociado a la falta de d?as"
    OffSetDiaHoy=nanmean(MEstacionesSSTanualM-MEstacionesSSTanualHoyM);
    
    %% Figuras
    figure
    %Desviacion standart
    patch([datenum(uY(1),1,1) datenum(uY(end),12,31) datenum(uY(end),12,31) datenum(uY(1),1,1)], ...
        [nanmean(MEstacionesSSTanualM(1:end-1))-1*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))-1*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))+1*StdEstacionesSSTanualM nanmean(MEstacionesSSTanualM(1:end-1))+1*StdEstacionesSSTanualM], ...
        [0.95 0.95 0.95],'edgecolor',[0.95 0.95 0.95]); hold on;grid on
    
    %Limites
    TempLimits=extrem([MEstacionesSSTanualM(1:end-1) MEstacionesSSTanualHoyM(end)+OffSetDiaHoy]);
    % Plot de los datos promedio anuales  y el promeido del utlimo a?o corregido
    plot([TimeAnual(1:end-1) TimeAnualHoy(end)],[MEstacionesSSTanualM(1:end-1) MEstacionesSSTanualHoyM(end)+OffSetDiaHoy],'ko-','MarkerFacecolor','k','Markersize',5); hold on
    plot(TimeAnualHoy(end),MEstacionesSSTanualHoyM(end)+OffSetDiaHoy,'o','MarkerFacecolor','c','Markersize',8); hold on
    
    %D=[TimeAnual(1:end-1) TimeAnualHoy(end)];
    %SST=[MEstacionesSSTanualM(1:end-1) MEstacionesSSTanualHoyM(end)+OffSetDiaHoy];
    %linea con la media
    plot([datenum(uY(1),1,1) datenum(uY(end),12,31)],[nanmean(MEstacionesSSTanualM(1:end-1)) nanmean(MEstacionesSSTanualM(1:end-1))],'-','color',[0.5 0.5 0.5],'linewidth',3)
    
    %Lineas para el ultimo dato
    plot([TimeAnual(1) TimeAnualHoy(end-1)],[MEstacionesSSTanualHoyM(end)+OffSetDiaHoy MEstacionesSSTanualHoyM(end)+OffSetDiaHoy],'k--')
    plot([TimeAnualHoy(end) TimeAnualHoy(end)],[MEstacionesSSTanualHoyM(end)+OffSetDiaHoy TempLimits(1)],'k--')
    
    %Vaor dato maximo
    plot(TimeAnual(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)),MEstacionesSSTanualM(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)),'sr','Markersize',10,'MarkerFaceColor','r');
    %Vaor dato minimo
    plot(TimeAnual(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)),MEstacionesSSTanualM(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)),'sb','Markersize',10,'MarkerFaceColor','b');
    axis([datenum(uY(1),1,1) datenum(uY(end),12,31) TempLimits])
    datetick('x','yyyy','keeplimits','keepticks')
    grid on
    box on
    
    InformeAnho1=sprintf('Temperatura media en %s: %4.2f C.\n',datestr(TimeAnualHoy(end),'yyyy'),MEstacionesSSTanualHoyM(end)+OffSetDiaHoy);
    
    InformeAnho2=sprintf('Datos en el periodo de referecia (%s-%s)\n', ...
        datestr(nanmin(TimeAnual),'yyyy'),datestr(nanmax(TimeAnual),'yyyy'));
    
    InformeAnho3=sprintf('Temperatura media anual: %4.2f C, con desviacion standart: %04.2f C.\n', ...
        nanmean(MEstacionesSSTanualM(1:end-1)), ...
        nanstd(MEstacionesSSTanualM(1:end-1)));
    InformeAnho4=sprintf('La temperatura max. ocurrio en %s y fue de %4.2f C.\n',...
        datestr(TimeAnual(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)),'yyyy'), ...
        MEstacionesSSTanualM(MEstacionesSSTanualM==nanmax(MEstacionesSSTanualM)));
    
    InformeAnho5=sprintf('La temperatura min. ocurrio en %s y fue de %4.2f C.\n',...
        datestr(TimeAnual(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)),'yyyy'), ...
        MEstacionesSSTanualM(MEstacionesSSTanualM==nanmin(MEstacionesSSTanualM)));
    InformeAnho=sprintf('%s',InformeAnho1,InformeAnho2,InformeAnho3,InformeAnho4,InformeAnho5);
    title(InformeAnho)
    
    CreaFigura(gcf,FicheroGraficoAno,[4])
    save(FileNameInforme,'InformeAnho');
end

