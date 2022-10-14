clc;clear;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % %                                 % % % % % % % % % % %
% % % % % % % % % % %            EJERCICIO1           % % % % % % % % % % %
% % % % % % % % % % %                                 % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% DATOS COMUNES
Rb = 6;   %En Mbps
f  = 2.4; %En Ghz
% DATOS PUNTO DE ACCESO
Ptx_dBm = 17;
Gtx_dB  = 5;
% DATOS ESTACIÓN MÓVIL
U_dBm  = -90;
Grx_dB = 2.14;

%--------------------------------OFICINAS----------------------------------
alfa  = [1.46, 2.46];
beta  = [34.62, 29.53];
gamma = [2.03, 2.38];
sigma = [3.76, 5.04];

%% Problema 1
Distancia = 500;
Lb_dB  = 10*alfa*log10(Distancia) + beta + 10*gamma*log10(f);
Prx_dB = Ptx_dBm + Gtx_dB - Lb_dB + Grx_dB; %dBm


%% Problema 2

x0=(erfcinv(2*0.9)*sqrt(2)*sigma)+Prx_dB;

%% Problema 3
Porcentaje = erfc((-85-Prx_dB)./(sqrt(2)*sigma))/2;

%% Problema 4
Lb_50porciento_dB           = Ptx_dBm + Gtx_dB + Grx_dB - U_dBm;
Radio_cobertura_50porciento = 10.^((Lb_50porciento_dB - beta - 10*gamma*log10(f))./(10*alfa));

%% Problema 5
x = U_dBm - erfcinv(2*0.9)*sqrt(2)*sigma;

Lb_90porciento_dB           = Ptx_dBm + Gtx_dB + Grx_dB - x;
Radio_cobertura_90porciento = 10.^((Lb_90porciento_dB - beta - 10*gamma*log10(f))./(10*alfa)); %LOS

%% Problema 6
Ptx_necesaria_dBm = x - Gtx_dB - Grx_dB + Lb_50porciento_dB;

%--------------------------------PASILLO-----------------------------------

alfa  = [1.63, 2.77];
beta  = [28.12, 29.27];
gamma = [2.25, 2.48];
sigma = [4.07, 7.63];
%% Problema 1
Distancia = 500;

Lb_dB  = 10*alfa*log10(Distancia) + beta + 10*gamma*log10(f);
Prx_dB = Ptx_dBm + Gtx_dB - Lb_dB + Grx_dB; %dBm


%% Problema 2

x0=(erfcinv(2*0.9)*sqrt(2)*sigma)+Prx_dB;

%% Problema 3
Porcentaje = erfc((-85-Prx_dB)./(sqrt(2)*sigma))/2;

%% Problema 4
Lb_50porciento_dB           = Ptx_dBm + Gtx_dB + Grx_dB - U_dBm;
Radio_cobertura_50porciento = 10.^((Lb_50porciento_dB - beta - 10*gamma*log10(f))./(10*alfa));

%% Problema 5
x = U_dBm - erfcinv(2*0.9)*sqrt(2)*sigma;

Lb_90porciento_dB           = Ptx_dBm + Gtx_dB + Grx_dB - x;
Radio_cobertura_90porciento = 10.^((Lb_90porciento_dB - beta - 10*gamma*log10(f))./(10*alfa)); %LOS

%% Problema 6
Ptx_necesaria_dBm = x - Gtx_dB - Grx_dB + Lb_50porciento_dB;


%--------------------------------FABRICA-----------------------------------

alfa  = [2.31, 3.79];
beta  = [24.52, 21.01];
gamma = [2.06, 1.34];
sigma = [2.69, 9.05];

%% Problema 1
Distancia = 500;

Lb_dB  = 10*alfa*log10(Distancia) + beta + 10*gamma*log10(f);
Prx_dB = Ptx_dBm + Gtx_dB - Lb_dB + Grx_dB; %dBm


%% Problema 2

x0=(erfcinv(2*0.9)*sqrt(2)*sigma)+Prx_dB;

%% Problema 3
Porcentaje = erfc((-85-Prx_dB)./(sqrt(2)*sigma))/2;

%% Problema 4
Lb_50porciento_dB           = Ptx_dBm + Gtx_dB + Grx_dB - U_dBm;
Radio_cobertura_50porciento = 10.^((Lb_50porciento_dB - beta - 10*gamma*log10(f))./(10*alfa));

%% Problema 5
x = U_dBm - erfcinv(2*0.9)*sqrt(2)*sigma;

Lb_90porciento_dB           = Ptx_dBm + Gtx_dB + Grx_dB - x;
Radio_cobertura_90porciento = 10.^((Lb_90porciento_dB - beta - 10*gamma*log10(f))./(10*alfa)); %LOS

%% Problema 6
Ptx_necesaria_dBm=x-Gtx_dB-Grx_dB+Lb_50porciento_dB;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % %                                 % % % % % % % % % % %
% % % % % % % % % % %            PRACTICA1            % % % % % % % % % % %
% % % % % % % % % % %                                 % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Apartado A

% Calcular el porcentaje de puntos situados a d1/d2/d3 que reciben al menos el valor de RSSI
% anotado en la MEDIDA 1/2 y 3.
alfa  = [1.46, 2.46];
beta  = [34.62, 29.53];
gamma = [2.03, 2.38];
Sigma = [3.76, 5.04];

f = 2.4;

d1 = [6.7, 13.4, 18];% NLOS

Prx_dBm = [-57, -58, -79];

Ptx_dBm = 16;
Gtx_dB  = 3.5;
Grx_dB  = 0.6323;

for i = (1:size(d1,2))
   Lb_dB(i,:) = 10*alfa.*log10(d1(i))+beta+ 10*gamma*log10(f);
   Prx_50porcieto_dBm = Ptx_dBm + Gtx_dB  - Lb_dB + Grx_dB;
   Porcentaje_Ptx(i,:) = erfc((( Prx_dBm(i) - Prx_50porcieto_dBm(i) ))./(sqrt(2).*Sigma))./2;
end

% Apartado B

d4 = 26;% Pierdo señal
d5 = 29/2;% Distacia entre routers 
Sensibilidad_dispositivo_dBm = -91; %dBm
Sensibilidad_medida4_dBm     = -79; %dBm

%% Preguntas 1 y 2: 1.Calcular probabilidades de rebasamiento por variabilidad con las ubicaciones
%                   2. Entender el significado de las probabilidades de rebasamiento

Lb_uah=10*alfa(1)*log10(d4)+beta(1) + 10*gamma(1)*log10(f);
Prx_uah=Ptx_dBm+Gtx_dB-Lb_uah+Grx_dB;

Porcentaje_uah_1 = erfc((Sensibilidad_dispositivo_dBm-Prx_uah)/(sqrt(2)*Sigma(1)))/2*100; %Porcentaje de puntos empleando la sensibilidad
Porcentaje_uah_2 = erfc((Sensibilidad_medida4_dBm-Prx_uah)/(sqrt(2)*Sigma(1)))/2*100;     %Porcentaje de puntos empleando la medida 4 

%% Pregunta 3

x_uah = Sensibilidad_medida4_dBm-erfcinv(2*0.95)*sqrt(2)*Sigma(1);

Lb2_cobertura_95_dB = Ptx_dBm + Gtx_dB + Grx_dB - x_uah;
Radio_cobertura_95  = 10^((Lb2_cobertura_95_dB-beta(1)-10*gamma(1)*log10(f))/(10*alfa(1))); % Radio cobertura al 95%

%% Pregunta 4

Lb_medida5 = 10*alfa(1)*log10(d5)+beta(1)+ 10*gamma(1)*log10(f);

Prx_medida5_dbm = Ptx_dBm + Gtx_dB - Lb_medida5 + Grx_dB;
Porcentaje_uah5 = erfc((Sensibilidad_dispositivo_dBm-Prx_medida5_dbm)/(sqrt(2)*Sigma(1)))/2*100; %Porcentaje de puntos distancia 5

