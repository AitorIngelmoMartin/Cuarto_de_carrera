clc;clear;close all
%% Datos
Retardos = [0, 0.6, 1, 1.25, 1.8 ]; %us
prx_dB   = [0,-3, -5, -8, -12];

F_muestreo   = 10e6; %Muestras/segundo
prx          = 10.^(prx_dB/10);

%%  Representación del perfil de retardo

Potencia_normalizada        = prx./(sum(prx));
Numero_muestras_en_tiempoRX = F_muestreo*Retardos*1e-6;

figure();stem(Numero_muestras_en_tiempoRX,Potencia_normalizada);
title("Representación del perfil de potencia");xlabel("Número de muestras");ylabel("Potencia normalizada");