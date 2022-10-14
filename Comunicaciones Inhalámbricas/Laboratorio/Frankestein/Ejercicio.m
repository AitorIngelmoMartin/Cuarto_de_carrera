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

% Apartado 1:Potencia media recibida a 500m del punto de acceso
Distancia = 500;

Lb_dB   = 10*Alfa*log10(Distancia) + Beta + 10*Gamma*log10(f);
Prx_dBm = Ptx_dBm + Gtx_dB  - Lb_dB + Grx_dB;

% Apartado 2: Potencia recibida superada en el 90% de los puntos situados 
% a 500m del punto de acceso
probabilidad = 0.9;

Aux    = erfcinv(2*probabilidad);
Prx_90 = Aux*sqrt(2)*Sigma + Prx_dBm;

% Apartado 3: Porcentaje de puntos situados a 500m del punto de acceso que
% reciben una potencia mayor a -85dBm
Porcentaje_Ptx = erfc(((-85-Prx_dBm))./(sqrt(2).*Sigma))./2;

% Apartado 4: Radio de cobertura (Rcob1) con una calidad del 50%
Lb_50porciento_dB  = -U_dBm + Ptx_dBm + Gtx_dB + Grx_dB;
R_cobertura1_50    = 10.^((Lb_50porciento_dB - Beta - 10*Gamma*log10(f))./(10*Alfa));

% Apartado 5: Radio de cobertura (Rcob1) con una calidad del 90%
Aux    = U_dBm-erfcinv(2*0.9)*sqrt(2)*Sigma;
Lb_90porciento_dB = Ptx_dBm+Gtx_dB+Grx_dB-Aux;

R_cobertura1_90 = 10.^((Lb_90porciento_dB-Beta-10*Gamma*log10(f))./(10*Alfa))*1e-1;%En Km

%  Apartado 6: Determinar la potencia que había que transmitir para
% conseguir un radio de cobertura(Rcob1) con una calidad del 90%
Ptx_dBm_R_cobertura1_90=Aux-Gtx_dB-Grx_dB+Lb_50porciento_dB;
