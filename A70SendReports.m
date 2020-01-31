%% Send reports
A11ActualizaGraficosSSTOpciones
InformeActualizaData=load(strcat(DirDataSST,'/InformeActualizaData'));
InformeCicloEstacional=load(strcat(DirFigures,'/Data/InformeCicloEstacionalSSTRaprocan'));
InformeAnual=load(strcat(DirFigures,'/Data/InformeAnualSSTRaprocan'));
%try
%EnviaCorreoArgo('pedro.velez@ieo.es',sprintf('SST %s',InformeActualizaData.Informe(1:end-1)),sprintf('> Datos diarios\n%s\n\n> Datos mensuales\n%s\n\n > %Datos anuales\n%s\nhttp://www.oceanografia.es/research_SST.html',InformeCicloEstacional.InformeDia,InformeCicloEstacional.InformeMes,InformeAnual.InformeAnho))
%end
