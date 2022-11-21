clc;clear;

BWnominal = 10; %Mhz

% Ancho de banda ocupado, si no hay sobremuestreo

Portadoras_de_datos = 192+8;
NFFT = 256;

BW = (BWnominal/NFFT)*200

variacion_f = BWnominal/NFFT %Porque al no haber sobremuestreo Fs = BW total

% Ancho de banda ocupado, si hay sobremuestreo

n=144/125;

BW = BW*n 

Fs = 11.52/256




