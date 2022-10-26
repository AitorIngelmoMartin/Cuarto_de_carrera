clear;clc;

% EJERCICIO 1

eficiencia = 0.65;
Diametros  = [3, 12];
Frecuencias = [14, 11]; %En Ghz
Ganancias_dB = 10*log10(eficiencia) + 20*log10(pi.*Diametros .*Frecuencias/0.3)


Rt = 6378
Rs =(((24*60*60)/(9.948e-3))^2)^(1/3);

gamma = 43.05
d     = Rs*sqrt(1 + (Rt/Rs)^2 -2*(Rt/Rs)*cosd(gamma))

Lasc = 92.4 + 20*log10(d)+20*log10(Frecuencias)

%% 

% Ejercicio 2