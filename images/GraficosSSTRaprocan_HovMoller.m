% Interpolo cada a?o de 1-365 para hacerlo compatible con el a?os 1980.

%% Daily hovmoler diagram

%Ano sintentico en 1980
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

%Diagrama HM de SST diaria
figure
contourf(CATimed1980,uY,MEstSSTHM_d,40,'edgecolor','none')
colorbar
datetick

%Diagrama HM de anomalia SST diaria
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


%Ultimo dia con datos
plot(CATimed1980(find(isnan(aMEstSSTHM_d(end,:)),1)-1),uY(end),'o')

colormap(jet)
colorbar
caxis([-2 2])
set(gca,'Ytick',[1980 1985 1986 1990 1995 1997 2000 2003 2004 2005 2010 2012 2014 2016 uY(end) 2020])
set(gca,'Xtick',[datenum(1980,2,1) datenum(1980,5,1) datenum(1980,8,1) datenum(1980,11,1)])
datetick('x','dd.mmmm','keeplimits','keepticks')
set(gca,'XtickLabel',['1 Febrero  ';'1 Mayo     ';'1 Agosto   ';'1 Noviembre'])

InformeHovMollerDiario=sprintf('Diagrama de anomalias de temperatura diarias.\n Periodo de referencia (%4d-%4d). %s',uY(1),uY(end-1),datestr(datestr(max(Timed)),'dd.mmmm'));
title(InformeHovMollerDiario)

axis([-inf inf 1980 2020])

CreaFigura(gcf,FicheroGraficoHMDiario,[4 7])
