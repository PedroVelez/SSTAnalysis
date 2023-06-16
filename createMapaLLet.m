clear all;close all

%Read options
configSSTWebpage

%Geographical Region
lat_minIB= 15.00; lat_maxIB=54;
lon_minIB=-45;    lon_maxIB=38;
lat_min=-65;    lat_max=65;
lon_min=-80;    lon_max=40;

%Google Map
GMCentroArgoIb=[36,-6];
GMZoomArgoIb=5;
GMTamanoArgoIb=[700,650];

%Titulo
PaginaWebDir='';
FileHtmlIEOOSStatus='./data/SSTMapa.html';

%% Inicio

fprintf('>>>>> %s\n',mfilename)
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');
fid = fopen(FileHtmlIEOOSStatus,'w');
fprintf('     > Writting leaflet file \n');

fprintf(fid,'<!DOCTYPE html>\n');
fprintf(fid,'<html> \n');
fprintf(fid,'<head> \n'); 
fprintf(fid,'	<title>IEO Ocean Observing System</title> \n'); 
fprintf(fid,'	<meta charset="utf-8" /> \n'); 
fprintf(fid,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n'); 
%Leaflet libraries
fprintf(fid,'   <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/> \n'); 
fprintf(fid,'   <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js" integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew==" crossorigin=""></script>\n'); 
fprintf(fid,'   <script src=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js''></script> \n');
fprintf(fid,'   <link href=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css'' rel=''stylesheet'' /> \n');
fprintf(fid,'	<style>\n');
fprintf(fid,'		html, body {height: 100%;margin: 0;}\n');
fprintf(fid,'		.leaflet-container {height: 500px;width: 600px;max-width: 100%;max-height: 100%;}\n');
fprintf(fid,'	</style>\n');
fprintf(fid,'	<style>#map { width: 800px; height: 600px; }\n');
fprintf(fid,'        .info { padding: 6px 8px; font: 14px/16px Arial, Helvetica, sans-serif; background: white; background: rgba(255,255,255,0.8); box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px; } .info h4 { margin: 0 0 5px; color: #777; }\n');
fprintf(fid,'        .legend { text-align: left; line-height: 18px; color: #555; } .legend i { width: 18px; height: 18px; float: left; margin-right: 8px; opacity: 0.7; }\n');
fprintf(fid,'    </style>\n');
fprintf(fid,'</head> \n');

fprintf(fid,'<body> \n');
fprintf(fid,'    <div align="center">\n');
fprintf(fid,'        Temperatura superficial del mar en las demarcaciones Españolas.<br/>\n');
fprintf(fid,'         Actualizado el %s .<br/>\n',date);
fprintf(fid,'        <div id="map" style="width: 700px; height: 650px;"></div> \n');
fprintf(fid,'    </div>\n');

fprintf(fid,'<script type="text/javascript">\n');

fprintf(fid,'// Initialize the map and set up control\n');  
fprintf(fid,'   const map = L.map(''map'',{scrollwheelzoom: false}).setView([38.00, -8.00],  5);\n');  
fprintf(fid,'   map.addControl(new L.Control.Fullscreen());\n');  
       
fprintf(fid,'//Tiles\n');  
fprintf(fid,'    const tiles = L.tileLayer(''https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'', {\n');  
fprintf(fid,'       attribution: ''Tiles &copy ESRI''}).addTo(map);\n');  
               
fprintf(fid,'//Defino iconos\n');  
fprintf(fid,'   var stationIcon = L.Icon.extend({\n');  
fprintf(fid,'       options: {\n');  
fprintf(fid,'           iconSize:     [10, 10],\n');  
fprintf(fid,'           iconAnchor:   [ 5,  5],\n');  
fprintf(fid,'           popupAnchor:  [-3, -76]\n');  
fprintf(fid,'       }\n');  
fprintf(fid,'   });\n');  
fprintf(fid,'   var marcador0 = new stationIcon({iconUrl: ''http://www.oceanografia.es/argo/imagenes/icons8-select-10.png''}),\n');  
fprintf(fid,'       marcador1 = new stationIcon({iconUrl: ''http://www.oceanografia.es/argo/imagenes/icons8-select-10.png''});\n');  
 

%Estaciones
fprintf(fid,' //Datos de las ultimas ocupaciones de las estaciones\n'); 
fprintf(fid,'   var estaciones = [\n');  

for ir=2:1:length(DataSet)
    fprintf('Reading %s section (%d/%d): \n',DataSet(ir).name,ir,length(DataSet))
    DataFile=strcat('SST',DataSet(ir).name);
    Estaciones=DataSet(ir).Estaciones;
    data=load(strcat(GlobalSU.AnaPath,'/SSTWebpage/data/SST',DataSet(ir).name,'.mat'));
    loneR=data.loneR;
    lateR=data.lateR;
    for ie=Estaciones
        NombreRadial=DataSet(ir).name;
        NombreRadialLong=DataSet(ir).nameLong;
        NombreEstacion=char((ie));
        SurfaceValue=sprintf('%4.2fºC',nanmean(data.sstd(:,end)));
        %BottonValue=sprintf('%3.0fdbar %4.1fC %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
         fprintf(fid,'           [1,''%s'',%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s'',''%s'',''%s''], \n', NombreEstacion,lateR(ie),loneR(ie),NombreRadial,NombreRadialLong,datestr(data.jdaySST(end)),SurfaceValue,'BottonValue','#bf3eff');

    end
end    
fprintf(fid,'		];\n');  


%%Marcador de posicion de las estaciones
fprintf(fid,'for (var i = 0; i < estaciones.length; i++) {\n');  
fprintf(fid,'		var estacion = estaciones[i];\n');  
fprintf(fid,'		if(estacion[0] == 1){\n');  
fprintf(fid,'			L.circleMarker([estacion[2], estacion[3]],\n');  
fprintf(fid,'            {radius : 3,\n');  
fprintf(fid,'            color  : estacion[9],\n');  
fprintf(fid,'            title: estacion[4]+estacion[1]+'' ''+estacion[5],\n');  
fprintf(fid,'            opacity: 1,\n');  
fprintf(fid,'            fillOpacity:.45,\n');  
fprintf(fid,'            fillColor:estacion[9]}).addTo(map).bindPopup(''<center><p><b><a href="http://www.oceanografia.es/IEOOS/SST/SST''+estacion[4]+''.html" target="_blank">''+estacion[5]+''</a></b><br><b>Último dato: </b>''+estacion[6]+''<br>''+estacion[7]+''</p> </center>'');\n');  
fprintf(fid,'		}else if (estacion[0] == 0) {\n');  
fprintf(fid,'			L.marker([estacion[2], estacion[3]],{\n');  
fprintf(fid,'			icon: marcador0,\n');  
fprintf(fid,'			title: estacion[4]+estacion[1]+'' ''+estacion[5],\n');  
fprintf(fid,'			}).addTo(map).bindPopup(''<center><p>Station <b><a href="http://www.oceanografia.es/IEOOS/SST/SST+''+estacion[1]+''.html" target="_blank">''+estacion[1]+''</a></b><br><b>''+estacion[4]+''</b><br><br><b>Last profile&nbsp;</b>''+estacion[5]+''</p></center>'');\n');  
fprintf(fid,'		}\n');
fprintf(fid,'	}\n');

    
fprintf(fid,'</script> \n'); 
fprintf(fid,'</body>\n');  
fprintf(fid,'</html>\n'); 

%% Lee las estaciones

fprintf(fid,'</html>\n');
fclose(fid);

%% Ftp the file
fprintf('     > Uploading  %s \n',FileHtmlIEOOSStatus);
ftpobj=FtpOceanografia;
cd(ftpobj,'/html/IEOOS/SST');
mput(ftpobj,FileHtmlIEOOSStatus);

%% Writting Informe
%save(FileNameInforme,'Informe','platformes','juldsIB','platdatacentr')
%fprintf('     > %s \n',Informe)


fprintf('%s <<<<<\n',mfilename)
