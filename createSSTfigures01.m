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
    [Yn,Md,Dn]=datevec(now);
    [Ye,Me,De]=datevec(Timed(end));

    %El mes para la estadistica es el ultimo con datos
    MesSelecionado=Me;
    TMesSelecionado=MesesEspanol(MesSelecionado);

    FileNameInforme=strcat(DirFigures,'/data/reportSeasonalCycle',DataFile);
    FicheroGraficoCicloEstacional=strcat('./images/GraficosSST',DataFile(4:end),'_',sprintf('CicloEstacional_Seccion%02d_%02d.png',min(Estaciones),max(Estaciones)));
    FicheroGraficoMes=strcat('./images/GraficosSST',DataFile(4:end),'_',sprintf('Mensual_Seccion%02d_%02d.png',min(Estaciones),max(Estaciones)));
    FicheroGraficoMesNombre=strcat('./images/GraficosSST',DataFile(4:end),'_',sprintf('Mensual_Seccion%02d_%02d_%s_%s.png',min(Estaciones),max(Estaciones),TMesSelecionado,datestr(max(Timed),'yyyy')));
    FicheroGraficoHMDiario=strcat('./images/GraficosSST',DataFile(4:end),'_',sprintf('HovMollerDiario_Seccion%02d_%02d.png',min(Estaciones),max(Estaciones)));

    %Fechas en formato vec
    [YdSST,MdSST,DdSST]=datevec(Timed);
    uY=unique(YdSST);

    %Fecha del valor ultimo
    [MYdSST,MMdSST,MDdSST]=datevec(max(Timed));

    %% calculo los promedios mensuales y anuales
    %Bucle sobre todas las estaciones con datos
    for iEs=1:size(DSST.sstd,1)
        iim=0;
        %Bucle sobre todos los a?os para promedio anual
        for iY=1:length(uY)
            IndiY=find(YdSST==uY(iY));
            sstpunto=SSTd(iEs,IndiY);
            timepunto=Timed(IndiY);
            if (datenum(uY(iY),12,30.5)-timepunto(end))<0
                SSTa(iEs,iY)=nanmean(sstpunto);
                Timea(iY)=nanmean(timepunto);
            else
                SSTa(iEs,iY)=NaN;
                Timea(iY)=NaN;
            end
            %Bucle sobre todos los meses para promedio mensual
            for im=1:12
                iim=iim+1;
                Indim=find(YdSST==uY(iY) & MdSST==im);
                sstpunto=SSTd(iEs,Indim);
                timepunto=Timed(Indim);
                SSTm(iEs,iim)=nanmean(sstpunto);
                Timem(iim)=datenum(uY(iY),im,15);
            end
        end
    end

    %% Promedio los datos de todas las estaciones
    MEstacionesSSTd=nanmean(SSTd(Estaciones,:));
    MEstacionesSSTm=nanmean(SSTm(Estaciones,:));
    MEstacionesSSTa=nanmean(SSTa(Estaciones,:));

    [YmSST,MmSST,DmSST]=datevec(Timem);

    %creo el tiempo sintetico
    Timed2000=datenum(2000,MdSST,DdSST);

    %% Promedios diarios para el valor medio anual
    %quito el ultimo a?o
    jdayi=0;
    for im=1:12
        for id=1:1:eomday(2000,im)
            jdayi=jdayi+1;
            ind=find(MdSST==im & DdSST==id & YdSST<uY(end));
            CAMSSTa2000(jdayi)=nanmean(MEstacionesSSTd(ind));
            CASSSTa2000(jdayi)=nanstd(MEstacionesSSTd(ind));
            CATimed2000(jdayi)=datenum(2000,im,id);
        end
    end

    %% Promedio de los datos del mes previo
    %datos promedios del mes
    for iY=1:length(uY)
        IndMesPrevio=find(YdSST==uY(iY) & MdSST==MesSelecionado);
        SSTMesSelecionado(iY)=nanmean(MEstacionesSSTd(IndMesPrevio));
        TimeMesSelecionado(iY)=nanmean(Timed(IndMesPrevio));
    end
    MeanSSTMesSelecionado=nanmean(SSTMesSelecionado);
    StdSSTMesSelecionado=nanstd(SSTMesSelecionado);
    MeanTimeMesSelecionado=nanmean(TimeMesSelecionado);
    MaxSSTMesSelecionado=nanmax(SSTMesSelecionado);
    MaxTimeMesSelecionado=TimeMesSelecionado(SSTMesSelecionado==MaxSSTMesSelecionado);
    MinSSTMesSelecionado=nanmin(SSTMesSelecionado);
    MinTimeMesSelecionado=TimeMesSelecionado(SSTMesSelecionado==MinSSTMesSelecionado);

    fprintf('  Periodo de referencia %s-%s\n',datestr(min(TimeMesSelecionado),'yyyy'),datestr(max(TimeMesSelecionado),'yyyy'))

    fprintf('  Media Temperatura %s       %4.2f\n',string(datetime(datenum(uY(iY),MesSelecionado,1),'ConvertFrom','datenum'),"MMMM","es_ES"), ...
        MeanSSTMesSelecionado)
    fprintf('  Std   Temperatura %s       %04.2f\n',string(datetime(datenum(uY(iY),MesSelecionado,1),'ConvertFrom','datenum'),"MMMM","es_ES"), ...
        StdSSTMesSelecionado)
    fprintf('  Max   Temperatura %s    %4.2f\n',string(datetime(MaxTimeMesSelecionado,'ConvertFrom','datenum'),"MMMM.yy","es_ES"), ...
        MaxSSTMesSelecionado)
    fprintf('  Min   Temperatura %s    %4.2f\n\n',string(datetime(MaxTimeMesSelecionado,'ConvertFrom','datenum'),"MMMM.yy","es_ES"),...
        MinSSTMesSelecionado)
    for iY=length(uY)-NAnosR+1:length(uY)
        fprintf('  Media Temperatura %s    %4.2f, anomalia: %5.2f\n',string(datetime(MaxTimeMesSelecionado,'ConvertFrom','datenum'),"MMMM.yy","es_ES"), ...
            SSTMesSelecionado(iY),SSTMesSelecionado(iY)-MeanSSTMesSelecionado)
    end

    %% figuras
    %Ciclo anual
    figure
    Xt=[CATimed2000-366 CATimed2000 CATimed2000+366];
    Ym=[CAMSSTa2000     CAMSSTa2000 CAMSSTa2000];
    Ys=[CASSSTa2000     CASSSTa2000 CASSSTa2000];

    %Desviacion estándar
    patch([Xt fliplr(Xt) Xt(1) ],[Ym+2*Ys fliplr(Ym-2*Ys) Ym(1)+2*Ys(1)],[0.95 0.95 0.95],'edgecolor',[0.95 0.95 0.95]); hold on

    %media
    plot(Xt,Ym,'color',[0.5 0.5 0.5],'linewidth',3);hold on;grid on

    %Pinto solo los ultimos NAnosR años de datos.
    Canhos=cbrewer('seq','YlGnBu',NAnosR);
    AnosR=uY(end-(NAnosR-1):end)';
    ic=0;
    for ianhos=AnosR(1:end-1)
        ic=ic+1;
        IndUl=find(YdSST==ianhos);
        X=Timed(IndUl);
        Ya=MEstacionesSSTd(IndUl)';
        [yy,mm,dd]=datevec(X);
        Xa=datenum(2000,mm,dd);
        X=[Xa-365 Xa Xa+365];
        Y=[Ya Ya Ya];
        plot(X,Y,'-','color',Canhos(ic,:),'linewidth',1.5)
        clear X Y
    end

    %Pinto el ultimo ano de datos.
    IndUl=find(YdSST==AnosR(end));
    X=Timed(IndUl);
    Y=MEstacionesSSTd(IndUl);
    [yy,mm,dd]=datevec(X);
    X=datenum(2000,mm,dd);
    plot(X,Y,'-','color',Canhos(size(Canhos,1),:),'linewidth',3)
    plot(X(end),Y(end),'o','MarkerFacecolor',Canhos(size(Canhos,1),:),'Markersize',5)

    plot([datenum(2000,MMdSST,MDdSST) datenum(2000,MMdSST,MDdSST)],[TemperatureLimts(1) Y(end)],'k--','linewidth',1)
    plot([X(1) X(end)],[Y(end) Y(end)],'k--','linewidth',1)

    InformeDia=sprintf('Temperatura %s: %4.2f C [%s]. \n %s-%s. Media %s: %4.2f C. Desviación estándar: %04.2f C. Anomalía %4.2f C.', ...
        string(datetime(datenum(MYdSST,MMdSST,MDdSST),'ConvertFrom','datenum'),"dd MMMM yy","es_ES"), ...
        Y(end), ...
        DataSet(numDatSet).nameLong, ...
        string(datetime(min(TimeMesSelecionado),'ConvertFrom','datenum'),"yyyy","es_ES"), ...
        string(datetime(max(TimeMesSelecionado),'ConvertFrom','datenum'),"yyyy","es_ES"), ...
        string(datetime(datenum(MYdSST,MMdSST,MDdSST),'ConvertFrom','datenum'),"dd MMMM","es_ES"), ...
        Ym(Xt==datenum(2000,MMdSST,MDdSST)), ...
        Ys(Xt==datenum(2000,MMdSST,MDdSST)), ...
        Y(end)-Ym(Xt==datenum(2000,MMdSST,MDdSST)));

    text(datenum(2000,MMdSST,MDdSST),TemperatureLimts(1)+1, ...
        sprintf('%s %4.2f C',string(datetime(datenum(MYdSST,MMdSST,MDdSST),'ConvertFrom','datenum'),"dd.MMMM","es_ES"),Y(end)),'backgroundcolor','w')



    title(InformeDia)
    colormap(Canhos)
    caxis([min(AnosR) max(AnosR)])
    hc=colorbar;
    set(hc,'Ytick',uY(end-(NAnosR-1):end)')
    axis([datenum(2000,1,1) datenum(2000,12,31) TemperatureLimts(1) TemperatureLimts(2)])
    set(gca,'Xtick',[datenum(2000,2,1) datenum(2000,5,1) datenum(2000,8,1) datenum(2000,11,1)])
    datetick('x','dd.mmmm','keeplimits','keepticks')
    set(gca,'XtickLabel',['1 Febrero  ';'1 Mayo     ';'1 Agosto   ';'1 Noviembre'])
    box on
    text(datenum(2000,08,01),TemperatureLimts(1)+0.5,FuenteDatos,'HorizontalAlignment','center')
    CreaFigura(gcf,FicheroGraficoCicloEstacional,[4])

    %% Figura del mes seleccion
    figure

    %Limites
    TempLimits=[MeanSSTMesSelecionado-3*StdSSTMesSelecionado  MeanSSTMesSelecionado+3*StdSSTMesSelecionado];

    %desviacion
    patch([datenum(uY(1),1,1) datenum(uY(end),12,31) datenum(uY(end),12,31) datenum(uY(1),1,1)], ...
        [MeanSSTMesSelecionado-2*StdSSTMesSelecionado MeanSSTMesSelecionado-2*StdSSTMesSelecionado MeanSSTMesSelecionado+2*StdSSTMesSelecionado MeanSSTMesSelecionado+2*StdSSTMesSelecionado], ...
        [0.95 0.95 0.95],'edgecolor',[0.95 0.95 0.95]); hold on;grid on;alpha(0.6)

    plot([datenum(uY(1),1,1) datenum(uY(end),12,31)], ...
        [MeanSSTMesSelecionado-2*StdSSTMesSelecionado MeanSSTMesSelecionado-2*StdSSTMesSelecionado], ...
        'color',[0.95 0.95 0.95],'linewidth',2);

    plot([datenum(uY(1),1,1) datenum(uY(end),12,31)], ...
        [MeanSSTMesSelecionado+2*StdSSTMesSelecionado MeanSSTMesSelecionado+2*StdSSTMesSelecionado], ...
        'color',[0.95 0.95 0.95],'linewidth',2);

    %Promedio
    plot([datenum(uY(1),1,1) datenum(uY(end),12,31) ],[MeanSSTMesSelecionado MeanSSTMesSelecionado],'-','color',[0.5 0.5 0.5],'linewidth',3)

    %Evolucion
    plot(TimeMesSelecionado,SSTMesSelecionado,'ko-','MarkerFacecolor','k','Markersize',5);hold on
    plot([TimeMesSelecionado(1) TimeMesSelecionado(end)],[SSTMesSelecionado(end) SSTMesSelecionado(end)],'k--')
    plot([TimeMesSelecionado(end) TimeMesSelecionado(end)],[SSTMesSelecionado(end) MeanSSTMesSelecionado-3*StdSSTMesSelecionado],'k--')
    plot(TimeMesSelecionado(end),SSTMesSelecionado(end),'ko-','MarkerFacecolor','c','MarkerEdgecolor','c','Markersize',9);hold on
    plot(MaxTimeMesSelecionado,MaxSSTMesSelecionado,'sr','Markersize',10,'MarkerFaceColor','r');hold on
    plot(MinTimeMesSelecionado,MinSSTMesSelecionado,'sb','Markersize',10,'MarkerFaceColor','b');hold on

    axis([datenum(uY(1),1,1) datenum(uY(end),12,31) TempLimits])
    set(gca,'Xtick',fliplr(datenum(uY(end):-5:uY(1),MesSelecionado,15)))
    datetick('x','yyyy','keeplimits','keepticks')
    box on
    text(datenum(uY(end)-9,01,12),MeanSSTMesSelecionado-3*StdSSTMesSelecionado+0.25,FuenteDatos,'HorizontalAlignment','center')

    InformeMes1=sprintf('Temperatura media en %s %s: %4.2f C [%s].\n',...
        TMesSelecionado,...
        string(datetime(TimeMesSelecionado(end),'ConvertFrom','datenum'),"yyyy","es_ES"), ...
        SSTMesSelecionado(end), ...
        DataSet(numDatSet).nameLong);
    InformeMes2=sprintf('(%s-%s): ', ...
        datestr(min(TimeMesSelecionado),'yyyy'),datestr(max(TimeMesSelecionado),'yyyy'));
    InformeMes3=sprintf('Temperatura media en %s: %4.2f C, desviación estándar: %04.2f C.\n', ...
        TMesSelecionado,...
        MeanSSTMesSelecionado,StdSSTMesSelecionado);
    InformeMes4=sprintf('Temperatura máxima [%s]: %4.2f C. ', ...
        string(datetime(MaxTimeMesSelecionado,'ConvertFrom','datenum'),"MMMM yyyy","es_ES"), ...
        MaxSSTMesSelecionado);
    InformeMes5=sprintf('Temperatura mínima [%s]: %4.2f C.', ...
        string(datetime(MinTimeMesSelecionado,'ConvertFrom','datenum'),"MMMM yyyy","es_ES"), ...
        MinSSTMesSelecionado);
    InformeMes=sprintf('%s',InformeMes1,InformeMes2,InformeMes3,InformeMes4,InformeMes5);
    title(InformeMes)

    CreaFigura(gcf,FicheroGraficoMes,[4])
    CreaFigura(gcf,FicheroGraficoMesNombre,[4])
    CreaFigura(gcf,FicheroGraficoMesNombre,[4])

    %% Diagrama de Hovmoller
    % Ano sintentico en 1980
    CATimed1980=datenum(1980,1,1,12,0,0):1:datenum(1980,1,1,0,0,0)+365;
    for iY=1:length(uY)
        %cojo los datos de ese a?o
        IndiY=find(YdSST==uY(iY));
        sstpunto=MEstacionesSSTd(IndiY);
        timepunto=Timed(IndiY);
        if length(sstpunto)==365
            MEstSSTHM_d(iY,1:365)=sstpunto;
        elseif length(sstpunto)==366
            MEstSSTHM_d(iY,1:365)=interp1(1:366,sstpunto,1:365);
        else
            MEstSSTHM_d(iY,1:length(sstpunto))=sstpunto;
            MEstSSTHM_d(iY,length(sstpunto)+1:365)=NaN;
        end
    end

    %Calculo el promedio estacional
    MMEstSSTHMd=nanmean(MEstSSTHM_d(1:end-1,:),1);
    %Calculo anomalias
    for iY=1:length(uY)
        aMEstSSTHM_d(iY,:)=MEstSSTHM_d(iY,:)-MMEstSSTHMd;
    end

    % Diagrama HM de anomalia SST diaria
    figure
    aMEstSSTHM_d(aMEstSSTHM_d>2)=2;
    aMEstSSTHM_d(aMEstSSTHM_d<-2)=-2;

    %Replico la ultima fila
    aMEstSSTHM_d2=aMEstSSTHM_d;
    uY2=uY;
    aMEstSSTHM_d2(length(uY)+1,:)=aMEstSSTHM_d(length(uY),:);
    uY2(length(uY)+1)=uY(length(uY))+0.5;
    contourf(CATimed1980,uY2,aMEstSSTHM_d2,[-2:0.1:2],'edgecolor','none');hold on;grid on
    contour(CATimed1980,uY2,aMEstSSTHM_d2,[1 1],'k','linewidth',2);hold on;grid on
    contour(CATimed1980,uY2,aMEstSSTHM_d2,[-1 -1],'k--','linewidth',2);hold on;grid on

    %Ultimo dia con datos [no lo hace el ultimo dia del año.]
    if ~isempty(find(isnan(aMEstSSTHM_d(end,:)),1))
        plot(CATimed1980(find(isnan(aMEstSSTHM_d(end,:)),1)-1),uY(end),'o')
    end

    colormap(cmocean('balance') )
    colorbar
    caxis([-2 2])
    axis([-inf inf 1981 uY(end)+1])

    Yticks=1981:4:uY(end);
    if Yticks(end)~=uY(end)
        Yticks=[Yticks uY(end)];
    end
    set(gca,'Ytick',Yticks)
    set(gca,'Xtick',[datenum(1980,2,1) datenum(1980,5,1) datenum(1980,8,1) datenum(1980,11,1)])
    datetick('x','dd.mmmm','keeplimits','keepticks')
    set(gca,'XtickLabel',['1 Febrero  ';'1 Mayo     ';'1 Agosto   ';'1 Noviembre'])

    InformeHovMollerDiario=sprintf('Anomalías de temperatura diarias [%s]. Actualizado %s. \n Periodo de referencia para las anomalías (%4d-%4d).', ...
        DataSet(numDatSet).nameLong, ...
    string(datetime(max(Timed),'ConvertFrom','datenum'),"dd MMMM yyyy","es_ES"), ...
        uY(1), ...
        uY(end-1));
    title(InformeHovMollerDiario)

    CreaFigura(gcf,FicheroGraficoHMDiario,[4])

    %% Upload to ftp the images

    ftpobj=FtpOceanografia;
    cd(ftpobj,DirHTML);
    mput(ftpobj,FicheroGraficoCicloEstacional);
    mput(ftpobj,FicheroGraficoMes);
    mput(ftpobj,FicheroGraficoMesNombre);
    mput(ftpobj,FicheroGraficoHMDiario);
    close(ftpobj)


    ftpobj=FtpOceanografia;
    cd(ftpobj,DirHTMLIEOOS);
    mput(ftpobj,FicheroGraficoCicloEstacional);
    mput(ftpobj,FicheroGraficoHMDiario);
    mput(ftpobj,FicheroGraficoMes);
    mput(ftpobj,FicheroGraficoMesNombre);
    close(ftpobj)
    
    %% Save Reports
    save(FileNameInforme,'InformeMes','InformeDia');
end
