Notas para pasar de 2023 a 2024

Este paso se realiza una vez ha finalziado el 2023 y cuando ya estan los datos de todo ese años disponibles. 

1- uso updateNoaaOisstV2HighresData_CreateAnual  para crear el fichero anual final del año que ha finalizado, hasta el 31 de diciembre de 2023
Poner AnhoF=2023;

2- uso updateNoaaOisstV2HighresData_AppendAnuals para crear el fichero total con los datos desde 01011982 hasta 31122023
Poner AnhoF=2023;

3- updateNoaaOisstV2HighresData_newyear para crear el primer ficherio 01011982 hasta 10012024 (por ejemplo)
Poner en AnhoF=2024; 
 

