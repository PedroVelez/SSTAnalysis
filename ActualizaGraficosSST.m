%Los datos de SST se actualizan en un script separado
%Actualizo despues la base datos de SST en las estaciones Raprocan
CreaSSTRaprocan
CreaSSTNorteTenerife
%Anual
GraficosSST_Anual
%Ciclo estacional y Hovmoller
GraficosSST

%% Envia informes
%DirData='/Users/pvb/Dropbox/Oceanografia/Analisis/TendenciasCCLME_SST/TendenciasAVHRR/Data';
%DirFigure='/Users/pvb/Dropbox/Oceanografia/Analisis/TendenciasHidrografiaCanaryBasinRaprocan/TendenciasSST';
%InformeActualizaData=load(strcat(DirData,'/InformeActualizaData'));
%InformeCicloEstacional=load(strcat(DirFigure,'/InformeCicloEstacionalSSTRaprocan'));
%InformeAnual=load(strcat(DirFigure,'/InformeAnualSSTRaprocan'));
%try
%    EnviaCorreoArgo('pvelezbelchi@gmail.com',sprintf('SST %s',InformeActualizaData.Informe(1:end-1)),sprintf('> Datos diarios\n%s\n\n> Datos mensuales\n%s\n\n > Datos anuales\n%s\nhttp://www.oceanografia.es/pedro/SST.html',InformeCicloEstacional.InformeDia,InformeCicloEstacional.InformeMes,InformeAnual.InformeAnho))
%end