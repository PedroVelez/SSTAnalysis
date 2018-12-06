%Los datos de SST se actualizan en un script separado

%% Actualizo la base datos de SST en las estaciones Raprocan
A20CreaSSTNorteTenerife
A30CreaSSTRaprocan

%% Anual and Ciclo estacional y Hovmoller plots
A40GraficosSST_Anual
A50GraficosSST

%% Send reports
A11ActualizaGraficosSSTOpciones

InformeActualizaData=load(strcat(DirDataSST,'/InformeActualizaData'));
InformeCicloEstacional=load(strcat(DirFigures,'/Data/InformeCicloEstacionalSSTRaprocan'));
InformeAnual=load(strcat(DirFigures,'/Data/InformeAnualSSTRaprocan'));
try
    EnviaCorreoArgo('pedro.velez@ieo.es',sprintf('SST %s',InformeActualizaData.Informe(1:end-1)),sprintf('> Datos diarios\n%s\n\n> Datos mensuales\n%s\n\n > Datos anuales\n%s\nhttp://www.oceanografia.es/research_SST.html',InformeCicloEstacional.InformeDia,InformeCicloEstacional.InformeMes,InformeAnual.InformeAnho))
end
