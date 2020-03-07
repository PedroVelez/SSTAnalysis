clc;clear all;close all

%Read options
configSSTWebpage

Files=dir(strcat(FileDataSST,'*'));
for i1=1:length(Files)
    DatatSST=matfile(strcat(Files(i1).folder,'/',Files(i1).name));
    TimeLast(i1)=nanmax(DatatSST.timetd);
end
iFileLast=find(TimeLast==max(TimeLast));

Data=matfile(strcat(Files(iFileLast).folder,'/',Files(iFileLast).name));

Op.datei=max(Data.timetd);
Op.Caxis=0;[14.5 22];
Op.CaxisAnomaly=[-3 1];
Op.figuras=[4 7];
Op.colormap='jet';


Op.filecosta=strcat('CanaryIslandsCoast');	% Fichero con la costa de la zona
Op.lon_min=360-24;
Op.lon_max=360-8;
Op.lat_min=22;
Op.lat_max=34;


%% Read data
[Ye,Mo,Da]=datevec(Op.datei);

ilon_min=Locate(Data.lon,Op.lon_min);
ilon_max=Locate(Data.lon,Op.lon_max);
ilat_min=Locate(Data.lat,Op.lat_min);
ilat_max=Locate(Data.lat,Op.lat_max);
ijday=Locate(Data.timetd,Op.datei);

lon=Data.lon(ilon_min:ilon_max,1);
lat=Data.lat(ilat_min:ilat_max,1);
jday=Data.timetd(ijday,1);
jdayT=Data.timetd(:,1);
[YT,MT,DT]=datevec(jdayT);

zvarT=Data.ssttd(ilon_min:ilon_max,ilat_min:ilat_max,:);
zvar=Data.ssttd(ilon_min:ilon_max,ilat_min:ilat_max,ijday);

zvarm=nanmean(zvarT(:,:,MT==Mo),3);

%% figure datei
figure
m_proj('mercator','lon',[Op.lon_min Op.lon_max],'lat',[Op.lat_min Op.lat_max])
[c,h1]=m_contourf(lon,lat,zvar',100,'edgecolor','none');hold on
XL=nanmin(lon(:))+0.05*Rango(lon);
YL=nanmax(lat(:))-0.025*Rango(lat);
h3=m_text(XL,YL,sprintf('%4d %02d %02d',Ye,Mo,Da),'backgroundcolor','w','Fontsize',16);

m_usercoast(Op.filecosta,'patch',[.7 .6 .4,],'edgecolor',[.7 .6 .4,]);hold on
m_grid('linestyle','none')
colorbar
if Op.Caxis==0
    colormap(Op.colormap);
else
    caxis([Op.Caxis])
    colormap(Op.colormap);
end
orient landscape;


%% promedio mensual
figure
m_proj('mercator','lon',[Op.lon_min Op.lon_max],'lat',[Op.lat_min Op.lat_max])
[c,h1]=m_contourf(lon,lat,zvarm',80,'edgecolor','none');hold on
m_usercoast(Op.filecosta,'patch',[.7 .6 .4,],'edgecolor',[.7 .6 .4,]);hold on
m_grid('linestyle','none')
colorbar

if Op.Caxis==0
    colormap(Op.colormap);
else
    caxis([Op.Caxis])
    colormap(Op.colormap);
end
orient landscape;

%% anomaly
figure
m_proj('mercator','lon',[Op.lon_min Op.lon_max],'lat',[Op.lat_min Op.lat_max])
[c,h1]=m_contourf(lon,lat,zvar'-zvarm',80,'edgecolor','none');hold on
m_usercoast(Op.filecosta,'patch',[.7 .6 .4,],'edgecolor',[.7 .6 .4,]);hold on
m_grid('linestyle','none')
colorbar
caxis([Op.CaxisAnomaly])
colormap(Op.colormap);
orient landscape;
