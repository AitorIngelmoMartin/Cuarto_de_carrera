clc;clear;

Nfft = 64;
variacion_f = 312.5*1e3; %En Khz

Prefijos_ciclicos = [0.4, 0.8];

% Apartado A) Retardo máximo capaz de absorver el sistema
% El máximo retardo que pueda absorver es el máximo prefijo cíclico, aunque
% tambien podemos calcularlo.

% Tofdm = L*Ts, pero ahora L es Nfft.

Tofdm   = 1/variacion_f;
Tau_max_ns = Tofdm/4 * 1e9

% Apartado B) En que entorno funciona
%       Los retardos más bajos el retardo es menor.

% Apartado C) Periodo de símbolo Tsofdm
Tsofdm =Tofdm + Prefijos_ciclicos;
% Apartado D) Fraccion de Tofdm que suponen ambos prefijos ciclicos
%       Es 1/4 y 1/8

% A partor de ahora, Tofdm (sin CPs) = 1/variacion_f y Tsofdm = Tofdm+CP

% Apartado E) Frecuencia de muestreo
Fs_Mhz = Nfft*variacion_f *1e-6


