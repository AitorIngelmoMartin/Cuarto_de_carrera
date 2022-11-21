clc;clear;

variacion_f = 31.25*1e3;

NFFT = 256;

Prefijo_ciclico = [1/4 1/8 1/16 1/32];

% Muestras del prefijo 
Numero_muestras = NFFT.*Prefijo_ciclico


% Duración del prefijo.
Tofdm = 1/variacion_f

Tiempo_prefijo_ciclico = Tofdm.*Prefijo_ciclico
 
 
