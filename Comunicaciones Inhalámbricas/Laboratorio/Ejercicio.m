clc;clear;

Rb = 6; %En Mbps
f = 2.4;

% DATOS PUNTO DE ACCESO
Ptx_dBm = 17;
Gtx_dB  = 5;

% DATOS ESTACIÓN MÓVIL
U_dBm  = -90;
Grx_dB = 2.14;

Alfa  = [2.31, 3.79];
Beta  = [24.52, 21.01];
Gamma = [2.06, 1.34];
Sigma = [2.69, 9.05];
% Prx a 500 metros


Distancia = 500;
Lb_dB   = 10*Alfa*log10(Distancia) + Beta + 10*Gamma*log10(f);
Prx_dBm = Ptx_dBm + Gtx_dB  - Lb_dB + Grx_dB;

probabilidad = [0.9];
Aux    = erfcinv(2*probabilidad);
Prx_90 = Aux*sqrt(2)*Sigma + Prx_dBm;

% Apartado 3:
Porcentaje = erfc(((-85-Prx_dBm))./(sqrt(2).*Sigma))./2;

% Apartado 4: Radio de cobertura (Rcob1) con una calidad del 50%
Lb_2_dB = -U_dBm + Ptx_dBm + Gtx_dB + Grx_dB;


R_cob1_50 = 10.^((Lb_2_dB - Beta - 10*Gamma*log10(f))./(10*Alfa));

% Apartado 5: Radio de cobertura (Rcob1) con una calidad del 90%
Porcentaje = erfc(((-85-Prx_dBm))./(sqrt(2).*Sigma))./2;